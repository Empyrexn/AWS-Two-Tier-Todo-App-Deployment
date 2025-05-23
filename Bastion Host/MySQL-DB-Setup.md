### SSH Into the Bastion Host

```bash
ssh -i path/to/bastion-key.pem ec2-user@<bastion-public-ip>
```

Make sure your key permissions are secure (`chmod 400 bastion-key.pem`).

---

### Install the MySQL Client (on the Bastion Host)

```bash
sudo yum update -y
sudo yum install -y wget

# Add MySQL 8.0 repo
sudo wget https://dev.mysql.com/get/mysql80-community-release-el9-1.noarch.rpm
sudo dnf install -y mysql80-community-release-el9-1.noarch.rpm
sudo rpm --import https://repo.mysql.com/RPM-GPG-KEY-mysql-2023

# Install MySQL client
sudo dnf install -y mysql-community-client
```

---

### Connect to the RDS MySQL Instance

Use the endpoint and credentials from Terraform output or your `.env` file:

```bash
mysql -h <rds-endpoint> -P 3306 -u admin -p
```

Enter your RDS password when prompted.

---

### Create the Database and Table

Inside the MySQL shell:

```sql
CREATE DATABASE tododb;
USE tododb;

CREATE TABLE Tasks (
    id INT AUTO_INCREMENT PRIMARY KEY,
    task_name VARCHAR(255) NOT NULL,
    task_description TEXT,
    due_date DATE NULL,
    completed BOOLEAN DEFAULT FALSE
);
```

Verify:

```sql
SHOW TABLES;
DESCRIBE Tasks;
```

---

### Exit the MySQL Shell

```sql
exit;
```
