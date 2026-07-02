module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.8"

  cluster_name    = var.cluster_name
  cluster_version = var.kubernetes_version

  # Public endpoint so kubectl (and GitHub Actions) can reach the API server.
  cluster_endpoint_public_access = true

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  # Grant whoever runs `terraform apply` cluster-admin so you can kubectl locally.
  enable_cluster_creator_admin_permissions = true

  eks_managed_node_groups = {
    default = {
      instance_types = var.node_instance_types
      desired_size   = var.node_desired_size
      min_size       = var.node_min_size
      max_size       = var.node_max_size
    }
  }

  # Map the CI IAM user into the cluster via an EKS access entry.
  # AmazonEKSClusterAdminPolicy is broad (fine for the assessment); tighten to
  # a namespaced policy or custom RBAC for production.
  access_entries = {
    ci = {
      principal_arn = aws_iam_user.ci.arn
      policy_associations = {
        admin = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
          access_scope = {
            type = "cluster"
          }
        }
      }
    }
  }

  tags = var.tags
}
