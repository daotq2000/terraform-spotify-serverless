resource "aws_lb" "alb" {
  name               = "application-loadbalancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [aws_subnet.public-subnet-1a.id,aws_subnet.private-subnet-1b.id,]
  enable_deletion_protection = false
  tags = {
    name="terraform project"
    description = "managed by terraform provisioning"
  }

}
resource "aws_lb_target_group" "alb_target_group" {
  name     = "alb-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc-main.id  # Replace with your VPC ID
  target_type = "ip"
  health_check {
    interval            = 30
    path                = "/actuator/health"
    protocol            = "HTTP"
    matcher             = "200"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
  }

  # other relevant target group settings...
}
resource "aws_lb_listener" "alb_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_target_group.arn
  }

}

# Define the Load Balancer Listener Rule
# resource "aws_lb_listener_rule" "alb_listener_rule" {
#   listener_arn = aws_lb_listener.alb_listener.arn
#   priority     = 100
#
#   action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.alb_target_group.arn
#   }
#
#   condition {
#     host_header {
#       values = [aws_lb.alb.dns_name]  # Replace with the domain name used in CloudFront
#     }
#   }
#
#   # You can add additional rules or conditions...
# }

# HTTPS Listener
resource "aws_lb_listener" "https_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = aws_acm_certificate.cert.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_target_group.arn
  }
  depends_on = [
  aws_acm_certificate.cert
  ]
}