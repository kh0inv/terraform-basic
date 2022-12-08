data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

resource "aws_launch_template" "web" {
  name_prefix   = "${var.project}-web-"
  image_id      = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  key_name      = var.key_name

  block_device_mappings {
    device_name = "/dev/sda1"

    ebs {
      volume_size = 60
      volume_type = "gp3"
    }
  }

  iam_instance_profile {
    arn = var.web_instance_profile_arn
  }

  vpc_security_group_ids = [var.security_groups.web]
  user_data              = filebase64("${path.module}/user-data.sh")

  tag_specifications {
    resource_type = "volume"
    tags = {
      Name        = "${var.project}-volume"
      Project     = "${var.project}"
      Environment = "prod"
    }
  }

  tags = {
    Name        = "${var.project}-launch-template"
    Project     = "${var.project}"
    Environment = "prod"
  }
}

resource "aws_autoscaling_group" "web" {
  name                = "${var.project}-asg"
  min_size            = 2
  desired_capacity    = 2
  max_size            = 3
  vpc_zone_identifier = var.vpc.private_subnets
  target_group_arns   = [aws_lb_target_group.target_group.arn]

  launch_template {
    id      = aws_launch_template.web.id
    version = aws_launch_template.web.latest_version
  }

  tag {
    key                 = "Name"
    value               = "${var.project}-asg"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_policy" "asg_policy" {
  name                   = "${var.project}-asg-policy"
  autoscaling_group_name = aws_autoscaling_group.web.name
  policy_type            = "TargetTrackingScaling"

  target_tracking_configuration {
    target_value = 70.0

    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
  }
}
