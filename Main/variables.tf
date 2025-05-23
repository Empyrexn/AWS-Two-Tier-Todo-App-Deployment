variable "region" {
    default = "us-west-1"
}

variable "vpc_cidr" {
    default = "10.0.0.0/16"
}

variable "db_password" {
  description = "Password for RDS"
  sensitive   = true
}

variable "app_port" {
  default = 3000
}
