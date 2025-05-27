#!/bin/bash

# Update and install MySQL client
yum update -y
yum install -y wget

wget https://dev.mysql.com/get/mysql80-community-release-el9-1.noarch.rpm
dnf install -y mysql80-community-release-el9-1.noarch.rpm
rpm --import https://repo.mysql.com/RPM-GPG-KEY-mysql-2023
dnf install -y mysql-community-client

# Run SQL commands to set up DB and table
mysql -h ${db_host} -P 3306 -u ${db_user} -p${db_password} <<EOF
CREATE DATABASE IF NOT EXISTS ${db_name};
USE ${db_name};
CREATE TABLE IF NOT EXISTS Tasks (
    id INT AUTO_INCREMENT PRIMARY KEY,
    task_name VARCHAR(255) NOT NULL,
    task_description TEXT,
    due_date DATE NULL,
    completed BOOLEAN DEFAULT FALSE
);
EOF
