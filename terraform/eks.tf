module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = "${var.project_name}-eks"
  cluster_version = var.eks_cluster_version

  cluster_endpoint_public_access = true

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  enable_cluster_creator_admin_permissions = true

  eks_managed_node_groups = {
    default = {
      instance_types = var.node_instance_types
      capacity_type  = "ON_DEMAND"
      desired_size   = var.node_desired_size
      min_size       = var.node_min_size
      max_size       = var.node_max_size
    }
  }
}

resource "aws_eks_access_entry" "jenkins" {
  cluster_name  = module.eks.cluster_name
  principal_arn = aws_iam_role.jenkins_role.arn
}

resource "aws_eks_access_policy_association" "jenkins_admin" {
  cluster_name  = module.eks.cluster_name
  principal_arn = aws_iam_role.jenkins_role.arn
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"

  access_scope {
    type = "cluster"
  }
}

resource "aws_vpc_security_group_ingress_rule" "jenkins_to_eks_api" {
  security_group_id            = module.eks.cluster_security_group_id
  referenced_security_group_id = aws_security_group.jenkins_sg.id

  from_port   = 443
  to_port     = 443
  ip_protocol = "tcp"

  description = "Allow Jenkins to access EKS API"
}