# AWS Two-Tier Todo App Deployment

This project provisions a two-tier architecture on AWS using Terraform. It includes:

- A VPC with public and private subnets
- EC2 instances for a Node.js-based Todo app
- An Application Load Balancer (ALB)
- An RDS MySQL database
- GitHub Actions for CI/CD deployment to EC2

---

## Prerequisites

Before you deploy this project, ensure you have:

- [Terraform](https://developer.hashicorp.com/terraform/downloads) installed (v1.3+ recommended)
- An AWS account with a user that has permissions to create VPC, EC2, RDS, ALB, etc.
- A key pair created in AWS EC2 (or use Terraform to manage it)
- AWS credentials configured locally or provided via GitHub Secrets

---

## How to Deploy

### 1. Clone the Repository

```bash
git clone https://github.com/Empyrexn/AWS-Two-Tier-Todo-App-Deployment.git
cd AWS-Two-Tier-Todo-App-Deployment/Main
```

### 2. Configure Variables (Optional)

You may edit `variables.tf` or create a `terraform.tfvars` file to override defaults.

```hcl
db_password = "your-secure-db-password"
```

### 3. Initialize Terraform

```bash
terraform init
```

### 4. Review the Execution Plan

```bash
terraform plan
```

### 5. Apply the Infrastructure

```bash
terraform apply
```

Type `yes` when prompted.

Terraform will:
- Create a VPC and subnets
- Launch EC2 instances
- Provision RDS and ALB
- Install and run the Todo app using EC2 user data

---

## How to Access the Application

After deployment, Terraform will output the ALB DNS name:

```bash
Outputs:

alb_dns = "todo-alb-123456789.us-west-1.elb.amazonaws.com"
```

Visit `http://alb_dns` in your browser to view the app.

---

## CI/CD Pipeline

This project includes GitHub Actions workflows for:

- **Terraform Validation and Plan** on pull requests to `main`
- **App Deployment via SSH** on pushes to `main`

See the [CI/CD documentation section](#ci/cd-terraform-validation-and-plan) in this README for details.

---

## Secrets Configuration (For GitHub Actions)

Configure the following secrets under **Settings > Secrets and variables > Actions** in your GitHub repository:

| Secret Name             | Description                                      |
|-------------------------|--------------------------------------------------|
| `AWS_ACCESS_KEY_ID`     | Your AWS access key                              |
| `AWS_SECRET_ACCESS_KEY` | Your AWS secret key                              |
| `EC2_SSH_KEY`           | Private SSH key matching the EC2 key pair        |
| `EC2_PUBLIC_IP_1`       | Public IP of the first EC2 instance              |
| `EC2_PUBLIC_IP_2`       | Public IP of the second EC2 instance             |

---

## Destroying the Infrastructure

To remove all resources created by Terraform:

```bash
terraform destroy
```

Type `yes` when prompted.

---
