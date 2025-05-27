## CI/CD: Terraform Validation and Plan

This repository uses GitHub Actions to validate and plan Terraform infrastructure changes before merging to `main`.

### Workflow File

The Terraform workflow is defined in `.github/workflows/terraform.yaml`. It runs on every pull request targeting the `main` branch.

### What It Does

When a pull request is opened or updated, the workflow:

1. Checks out the code
2. Configures AWS credentials using GitHub secrets
3. Initializes Terraform in the `Main/` directory
4. Runs `terraform fmt -check` to ensure proper formatting
5. Runs `terraform validate` to confirm configuration is valid
6. Runs `terraform plan` to show what will be created, changed, or destroyed

### Required Secrets

Set these secrets in your repository's **Settings > Secrets and variables > Actions**:

| Secret Name             | Description                                      |
|-------------------------|--------------------------------------------------|
| `AWS_ACCESS_KEY_ID`     | AWS access key for Terraform to authenticate     |
| `AWS_SECRET_ACCESS_KEY` | Corresponding secret key                         |

These credentials must have permissions to plan and (optionally) apply infrastructure using the AWS provider.

### Working Directory

Terraform files are located in the `Main/` directory. The workflow sets the working directory accordingly using:

```yaml
defaults:
  run:
    working-directory: Main
```

### Example: Successful Validation Output

The following is an excerpt from a successful plan output:

```
Terraform used the selected providers to generate the following execution plan.
Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:
  + aws_instance.web1
  + aws_instance.web2
  + aws_db_instance.main
  + aws_lb.todo_alb
  ...
Plan: 28 to add, 0 to change, 0 to destroy.
```

### Notes

- This workflow ensures infrastructure changes are reviewed and validated **before deployment**.
- Actual deployment (i.e., `terraform apply`) is not performed in this workflow — it is reserved for manual execution or a separate workflow.
