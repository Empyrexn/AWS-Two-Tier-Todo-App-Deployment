resource "aws_db_subnet_group" "main" {
  name       = "two-tier-db-subnet-group"
  subnet_ids = [aws_subnet.private_a.id, aws_subnet.private_b.id]

  tags = {
    Name = "DB Subnet Group"
  }
}

# Database creation
resource "aws_db_instance" "main" {
  identifier             = "two-tier-db"
  engine                 = "mysql"
  instance_class         = "db.t3.micro"
  allocated_storage      = 20
  username               = "admin"
  password               = var.db_password
  db_name                = "tododb"
  publicly_accessible    = false
  skip_final_snapshot    = true
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.main.name

  tags = {
    Name = "two-tier-db"
  }
}
