## CI/CD: GitHub Actions Deployment

This project includes a GitHub Actions pipeline to automate deployment of the Node.js application to AWS EC2 instances.

### Workflow File

The deployment pipeline is defined in `.github/workflows/app-deploy.yml`. It is triggered on every push to the `main` branch.

### Workflow Overview

Upon triggering, the workflow performs the following steps:

1. Checks out the repository code.
2. Connects to two EC2 instances using the `appleboy/ssh-action`.
3. Runs the following commands remotely on each instance:
   git config --global --add safe.directory /home/ec2-user/Todo-Two-Tier
   cd ~/Todo-Two-Tier
   git pull origin main
   pm2 restart todoapp || pm2 start index.js --name todoapp

Uses PM2 to ensure the application is running in the bAckground.

### Successful Deployment Output (Excerpt)

The following is an example of a successful run shown in the GitHub Actions logs:

[PM2] Starting /home/ec2-user/Todo-Two-Tier/index.js in fork_mode (1 instance)
[PM2] Done.

![Screenshot 2025-05-27 130045](https://github.com/user-attachments/assets/1b05fcbc-0b35-468e-89b4-8ef808dab033)

### SSH Access and Security

To secure SSH access to the EC2 instances:

- The EC2 security group allows port 22 only from GitHub Actions IP ranges.
- SSH access is performed using a private key stored as a GitHub secret (`EC2_SSH_KEY`).
- Each EC2 instance’s public IP is stored in the GitHub secrets `EC2_PUBLIC_IP_1` and `EC2_PUBLIC_IP_2`.
- The SSH key used matches the key pair specified in the EC2 `key_name` argument in Terraform.

### Notes

Git may emit the following warning when pulling updates:

fatal: detected dubious ownership in repository at '/home/ec2-user/Todo-Two-Tier'
To add an exception for this directory, call:
	git config --global --add safe.directory /home/ec2-user/Todo-Two-Tier

This warning is resolved in the workflow by pre-configuring the directory as a trusted source.

### Technologies Used

- GitHub Actions
- Terraform (for infrastructure provisioning)
- SSH via `appleboy/ssh-action`
- PM2 for Node.js process management

## Secrets Configuration

This project uses GitHub Actions for CI/CD. The following secrets must be configured in your GitHub repository settings to enable secure deployment via SSH:

### Required GitHub Secrets

| Secret Name          | Description                                                                 |
|----------------------|-----------------------------------------------------------------------------|
| `EC2_SSH_KEY`        | The private SSH key (in PEM format) for accessing the EC2 instances. This key must match the `key_name` used in your Terraform EC2 instance configuration. |
| `EC2_PUBLIC_IP_1`    | The public IPv4 address of the first EC2 web server (e.g., web1). You can obtain this from the AWS Console or output it via Terraform. |
| `EC2_PUBLIC_IP_2`    | The public IPv4 address of the second EC2 web server (e.g., web2). Same process as above. |

### Notes

- `EC2_SSH_KEY` should include the full contents of the `.pem` file, including the `-----BEGIN RSA PRIVATE KEY-----` and `-----END RSA PRIVATE KEY-----` lines.
- Do not include any passphrase for the key unless you have configured it to use one, in which case you will also need to add a `PASSPHRASE` secret and pass it to the GitHub Action.
- You can retrieve the public IPs from Terraform outputs like so:
  ```hcl
  output "web1_ip" {
    value = aws_eip.web1_ip.public_ip
  }
  output "web2_ip" {
    value = aws_eip.web2_ip.public_ip
  }

To add these secrets:

1. Go to your repository on GitHub.

2. Navigate to Settings > Secrets and variables > Actions.

3. Click New repository secret.

4. Add each secret with the appropriate name and value.
