resource "aws_lb_target_group" "my-target-group" {
  health_check {
    interval            = 10
    path                = "/"
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
  }

  name     = "SokoShopper-API-target-group"
  port        = 80
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = var.main_vpc
}

resource "aws_lb" "my-aws-alb" {
  name     = "sokoshopper-api-lb"
  internal = true

  security_groups = var.security_group

  subnets = [var.subnet1,var.subnet2]

  # depends_on = [var.subnet1]

  tags = {
    Name = "sokoshopper-api-alb"
  }

  ip_address_type    = "ipv4"
  load_balancer_type = "application"
}

resource "aws_lb_listener" "sokoshopper-api-alb-listner" {
  load_balancer_arn = "${aws_lb.my-aws-alb.arn}"
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.my-target-group.arn}"
  }
}