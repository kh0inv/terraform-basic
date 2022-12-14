/*
Error: Error putting IAM role policy runners-docker-logging:
NoSuchEntity: The role with name runners-docker-instance cannot be found
==> Just run terraform apply again
*/

module "runner" {
  source = "npalm/gitlab-runner/aws"

  aws_region  = "us-east-1"
  environment = "runners-docker"

  runners_use_private_address = false
  enable_eip                  = true
  enable_schedule             = false

  vpc_id    = "vpc-002ef6196712b8fb7"
  subnet_id = "subnet-05667e88d09af8755"

  instance_type      = "t3.medium"
  runners_executor   = "docker"
  runners_name       = "docker"
  runners_gitlab_url = "https://gitlab.com"

  gitlab_runner_registration_config = {
    registration_token = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
    tag_list           = "docker_runner"
    description        = "runner docker - auto"
    locked_to_project  = "true"
    run_untagged       = "true"
    maximum_timeout    = "3600"
  }

  tags = {
    Project     = "mamnon"
    Environment = "dev"
  }
}
