# AWS-Two-Tier-Todo-App-Deployment

# Overview
This project demonstrates the design and deployment of a full-stack two-tier web application on AWS using Terraform. The architecture consists of a Node.js-based backend running on EC2 instances and a MySQL RDS database for persistent data storage. An Application Load Balancer (ALB) distributes traffic across EC2 instances to ensure high availability and scalability. The infrastructure is built using Infrastructure as Code (IaC) principles with Terraform for repeatability and automation.

![AppArchitecture](https://github.com/user-attachments/assets/a7442cd3-ef13-4d14-9cba-8d6624dcee19)

# Key Components

## Amazon EC2 (Web Servers)
**Role:** Hosts the Node.js Todo App and serves traffic via NGINX reverse proxy on port 80. PM2 is used to ensure the application remains running after restarts and reboots.

**Security:** The EC2 instances reside in public subnets and are secured with security groups that allow HTTP access from the ALB and SSH access only from a specified IP for administrative purposes.

## Amazon RDS (MySQL)
**Role:** Provides a managed relational database for storing application data securely and reliably.

**Security:** The RDS instance is deployed in private subnets, making it inaccessible from the internet. Only EC2 instances within the same VPC are permitted access. Data is encrypted at rest and in transit.

## Application Load Balancer (ALB)
**Role:** Distributes incoming HTTP requests evenly across the EC2 instances, ensuring consistent application availability and improved fault tolerance.

**Security:** The ALB is internet-facing, with a security group that allows HTTP traffic from the public (0.0.0.0/0). It routes traffic only to healthy EC2 targets.

## Virtual Private Cloud (VPC)
**Role:** Provides isolated networking infrastructure, separating public and private subnets for secure resource placement.

**Security:** Configured with custom route tables, public and private subnets, internet and NAT gateways (optional), and tightly scoped security groups to control traffic flow.

## IAM Roles & Policies
**Role:** Grants the necessary permissions to EC2 instances and other components to interact with AWS services securely, such as accessing instance metadata, CloudWatch logs, or bootstrapping applications.

**Security:** IAM roles are defined with least privilege policies to prevent over-permissioning and avoid the use of hardcoded credentials.

# Objectives
- **Two-Tier Architecture:** Clean separation of application and database layers to promote modularity and enhance security.
- **Infrastructure as Code:** Use Terraform to define, deploy, and manage infrastructure consistently and reliably.
- **Security Best Practices:** Implement private subnets, role-based access control, and metadata protection to safeguard resources.
- **Scalability and Availability:** Ensure the application can handle load fluctuations and remain available across multiple availability zones using an ALB.
- **Automation:** Use `user_data.tpl` and `bastion_host_data.tpl` to bootstrap EC2 instances with the Node.js app and PM2 for the web instances and to automatically connect to and set up the database in the bastion instance for persistent runtime.

# CI/CD Integration
This project includes basic CI/CD pipelines using GitHub Actions to automate both application deployment and infrastructure validation:

- **Application Deployment:** On each push to the main branch, GitHub Actions automatically SSHs into both EC2 instances, pulls the latest code, and restarts the Node.js app with PM2.
- **Infrastructure Validation:** On each pull request, Terraform code is automatically checked for formatting, validated, and planned to preview changes before merging.

These pipelines improve code reliability, support rapid iteration, and help maintain infrastructure and app quality.

# Conclusion
This project showcases the implementation of a secure, scalable, and automated AWS infrastructure to support a two-tier web application. Leveraging services like EC2, RDS, and ALB, and managing them with Terraform, provides a reliable and modular cloud solution. This architecture lays a strong foundation for future enhancements, including HTTPS via ACM, autoscaling, CloudWatch integration, and CI/CD pipelines for continuous delivery and monitoring.

![Screenshot 2025-05-23 152715](https://github.com/user-attachments/assets/f41c5b14-64bc-4254-94ca-34fc0ee52a16)
