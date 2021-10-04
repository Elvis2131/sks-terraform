resource "aws_launch_configuration" "sks_api_launch_config" {
  image_id        = "ami-0bb629e29a19781d7"
  instance_type   = "t2.micro"
  security_groups = var.security_group

  user_data = filebase64("./scripts/setup.sh")

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "example" {
  launch_configuration = aws_launch_configuration.sks_api_launch_config.name
  vpc_zone_identifier  = ["${var.subnet1}","${var.subnet2 }"]
  target_group_arns    = ["${var.target_group_arn}"]
  health_check_type    = "ELB"

  min_size = 2
  max_size = 10

  tag {
    key                 = "Name"
    value               = "sks-api-asg"
    propagate_at_launch = true
  }
}