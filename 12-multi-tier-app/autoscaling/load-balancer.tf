resource "aws_lb" "alb" {
  name               = "${var.project}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.security_groups.lb]
  subnets            = var.vpc.public_subnets

  tags = {
    Name        = "${var.project}-alb"
    Project     = "${var.project}"
    Environment = "prod"
  }
}

# resource "aws_lb_listener" "http_listener" {
#   load_balancer_arn = aws_lb.alb.arn
#   port              = "80"
#   protocol          = "HTTP"

#   default_action {
#     type = "redirect"

#     redirect {
#       protocol    = "HTTPS"
#       port        = "443"
#       host        = "#{host}"
#       path        = "/#{path}"
#       query       = "#{query}"
#       status_code = "HTTP_301"
#     }
#   }
# }

# resource "aws_lb_listener" "https_listener" {
#   load_balancer_arn = aws_lb.alb.arn
#   protocol          = "HTTPS"
#   port              = "443"

#   ssl_policy      = "ELBSecurityPolicy-2016-08"
#   certificate_arn = "arn:aws:acm:us-east-1:269597175775:certificate/f8199304-d89f-44c2-9812-1b2152726d98"

#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.target_group.arn
#   }
# }

resource "aws_lb_listener" "https_listener" {
  load_balancer_arn = aws_lb.alb.arn
  protocol          = "HTTP"
  port              = "80"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.arn
  }
}

resource "aws_lb_target_group" "target_group" {
  name                 = "${var.project}-target-group"
  vpc_id               = var.vpc.vpc_id
  protocol             = "HTTP"
  port                 = 80
  target_type          = "instance"
  deregistration_delay = 100

  health_check {
    path     = "/"
    protocol = "HTTP"
    interval = 10
    timeout  = 5
    matcher  = "200-499"
  }

  tags = {
    Name        = "${var.project}-target-group"
    Project     = "${var.project}"
    Environment = "prod"
  }
}
