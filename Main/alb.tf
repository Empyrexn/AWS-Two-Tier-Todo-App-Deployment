# Creating ALB
resource "aws_lb" "todo_alb" {
  name               = "TodoApp-ALB"
  load_balancer_type = "application"
  internal           = false
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [aws_subnet.public_a.id, aws_subnet.public_b.id]

  tags = {
    Name = "TodoApp-ALB"
  }
}

# Creating Target Group
resource "aws_lb_target_group" "todo_tg" {
  name     = "Todo-TG"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    Name = "TodoApp-TG"
  }
}

# Target Group + Attachments
resource "aws_lb_target_group_attachment" "web1" {
  target_group_arn = aws_lb_target_group.todo_tg.arn
  target_id        = aws_instance.web1.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "web2" {
  target_group_arn = aws_lb_target_group.todo_tg.arn
  target_id        = aws_instance.web2.id
  port             = 80
}

# Listener
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.todo_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.todo_tg.arn
  }
}