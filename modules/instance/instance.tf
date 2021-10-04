#Creating our target group for our load balancer
resource "aws_lb_target_group" "api_lb" {
  name     = "SokoShopper-API-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.main_network
}


#Creating a launch template
resource "aws_launch_template" "SokoShopper_API_template" {
  name = "SokoShopper-API"

  block_device_mappings {
    device_name = "/dev/sda1"

    ebs {
      volume_size = 20
    }
  }

  cpu_options {
    core_count       = 4
    threads_per_core = 2
  }

  credit_specification {
    cpu_credits = "standard"
  }

  disable_api_termination = false

  ebs_optimized = true

  image_id = "ami-0bb629e29a19781d7"

  instance_initiated_shutdown_behavior = "terminate"

  instance_type = "c5.large"


  key_name = "main_key"

  monitoring {
    enabled = true
  }

  network_interfaces {
    associate_public_ip_address = false
    subnet_id   = var.private_subnet
    # security_groups = var.security_groups
  }

  placement {
    availability_zone = var.asg_availability
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "SokoShopper-API"
    }
  }

  user_data = filebase64("./scripts/setup.sh")
}