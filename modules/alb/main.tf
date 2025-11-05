resource "aws_lb" "main" {
  name               = "${var.desafio_sre}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.sg_alb]
  subnets            = var.public_subnets

  tags = {
    Name = "${var.desafio_sre}-alb"
  }
}

resource "aws_lb_target_group" "wordpress" {
  name     = "${var.desafio_sre}-wp-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path                = "/health.html" # Arquivo que o Ansible criará
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.main.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.wordpress.arn
  }
}