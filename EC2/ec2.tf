resource "aws_instance" "web1" {
  ami           = "ami-07706bb32254a7fe5"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public_a.id
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  key_name = "bastion-host-key"
  associate_public_ip_address = true

  user_data = templatefile("${path.module}/user_data.tpl", {
    db_host     = aws_db_instance.main.endpoint
    db_user     = "admin"
    db_password = var.db_password
    db_name     = "tododb"
    app_port    = var.app_port
  })

  tags = {
    Name = "web-server-1"
  }
}

resource "aws_instance" "web2" {
  ami           = "ami-07706bb32254a7fe5"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public_a.id
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  key_name = "bastion-host-key"
  associate_public_ip_address = true

  user_data = templatefile("${path.module}/user_data.tpl", {
    db_host     = aws_db_instance.main.endpoint
    db_user     = "admin"
    db_password = var.db_password
    db_name     = "tododb"
    app_port    = var.app_port
  })

  tags = {
    Name = "web-server-2"
  }
}

# Bastion host ec2 in order to initialize mySQL
resource "aws_instance" "bastion" {
  ami           = "ami-07706bb32254a7fe5"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public_a.id
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  key_name = "bastion-host-key"
  associate_public_ip_address = true

  tags = {
    Name = "bastion-host"
  }
}

resource "aws_eip" "web1_ip" {
  instance = aws_instance.web1.id
  domain = "vpc"
}

resource "aws_eip" "web2_ip" {
  instance = aws_instance.web2.id
  domain = "vpc"
}

resource "aws_eip" "bastion_ip" {
    instance = aws_instance.bastion.id
    domain = "vpc"
}
