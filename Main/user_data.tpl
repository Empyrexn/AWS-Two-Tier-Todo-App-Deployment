#!/bin/bash

# Log user_data output for debugging
exec > >(tee /var/log/user_data.log | logger -t user-data -s 2>/dev/console) 2>&1

# Update packages and install dependencies
yum update -y
yum install -y git nginx
curl -fsSL https://rpm.nodesource.com/setup_18.x | bash -
yum install -y nodejs

# Clone the app
cd /home/ec2-user
git clone https://github.com/Himanshu-Sangshetti/Todo-Two-Tier.git
cd Todo-Two-Tier

# Wait briefly to ensure network + metadata service is available
sleep 5

# Get public IP using IMDSv2
TOKEN=$(curl -sX PUT "http://169.254.169.254/latest/api/token" \
  -H "X-aws-ec2-metadata-token-ttl-seconds: 60")

# Use escaped variable so Terraform doesn't complain
cat <<EOF > .env
DB_HOST="${db_host}"
DB_USER="${db_user}"
DB_PASSWORD="${db_password}"
DB_NAME="${db_name}"
PORT= 3306
API_BASE_URL="http://$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" \
  http://169.254.169.254/latest/meta-data/public-ipv4)
"
EOF

# Install Node.js dependencies and start the app
npm install
npm install -g pm2
pm2 start index.js --name todoapp
sudo env PATH=$PATH:/usr/bin pm2 startup systemd -u ec2-user --hp /home/ec2-user
pm2 save

# Configure NGINX
rm -f /etc/nginx/nginx.conf
cat <<EONGINX > /etc/nginx/nginx.conf
events {
  worker_connections 1024;
}
http {
  server {
    listen 80;
    server_name _;

    location / {
      proxy_pass http://localhost:${app_port};
      proxy_http_version 1.1;
      proxy_set_header Upgrade \$http_upgrade;
      proxy_set_header Connection 'upgrade';
      proxy_set_header Host \$host;
      proxy_cache_bypass \$http_upgrade;
    }

    location /static/ {
      root /home/ec2-user/Todo-Two-Tier/public;
    }
  }
}
EONGINX

# Restart NGINX to apply new config
systemctl restart nginx
systemctl enable nginx
