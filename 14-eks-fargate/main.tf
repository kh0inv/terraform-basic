variable "cluster_name" {
  type    = string
  default = "eks-alb-2048game"
}

variable "region" {
  type    = string
  default = "us-east-1"
}

variable "project" {
  type    = string
  default = "mamnon"
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 3.0"

  name = var.cluster_name
  cidr = "10.0.0.0/16"

  azs             = ["${var.region}a", "${var.region}b", "${var.region}c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]

  enable_nat_gateway     = true
  single_nat_gateway     = true
  one_nat_gateway_per_az = false
  enable_dns_hostnames   = true

  public_subnet_tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                    = 1
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"           = 1
  }

  tags = {
    Project     = "${var.project}"
    Environment = "prod"
  }
}

resource "aws_iam_role" "eks_role" {
  name = "eks-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = "sts:AssumeRole"
        Principal = {
          Service = "eks.amazonaws.com"
        }
      },
    ]
  })

  managed_policy_arns = ["arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"]

  tags = {
    Name = "eks-role"
  }
}

resource "aws_eks_cluster" "cluster" {
  name     = var.cluster_name
  role_arn = aws_iam_role.eks_role.arn

  vpc_config {
    endpoint_private_access = false
    endpoint_public_access  = true
    public_access_cidrs     = ["0.0.0.0/0"]
    subnet_ids              = concat(module.vpc.private_subnets, module.vpc.public_subnets)
  }

  depends_on = [aws_iam_role.eks_role]
}

resource "aws_iam_role" "eks_fargate_role" {
  name = "eks-fargate-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "eks-fargate-pods.amazonaws.com"
      }
    }]
  })

  managed_policy_arns = ["arn:aws:iam::aws:policy/AmazonEKSFargatePodExecutionRolePolicy"]
}

resource "aws_eks_fargate_profile" "game_2048" {
  cluster_name           = aws_eks_cluster.cluster.name
  fargate_profile_name   = "game-2048"
  pod_execution_role_arn = aws_iam_role.eks_fargate_role.arn

  # These subnets must have the following resource tag:
  # kubernetes.io/cluster/<CLUSTER_NAME>.
  subnet_ids = module.vpc.private_subnets

  selector {
    namespace = "game-2048"
  }
}

# resource "aws_eks_addon" "coredns" {
#   addon_name        = "coredns"
#   addon_version     = "v1.8.4-eksbuild.1"
#   cluster_name      = var.cluster_name
#   resolve_conflicts = "OVERWRITE"
#   depends_on        = [aws_eks_cluster.cluster]
# }

#aws eks update-kubeconfig --name eks-alb-2048game --region us-east-1  --alias test-2048
#kubectl config use-context eks-alb-2048game
#aws eks --region ap-southeast-1 update-kubeconfig --name prod-eks-magento --alias ASUS-Prod
#export KUBECONFIG=$(pwd)/kube_config_rancher-cluster.yml
