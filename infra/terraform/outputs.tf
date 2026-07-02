output "region" {
  value = var.region
}

output "ecr_repository_url" {
  description = "Push images here; also the value for the CD ECR_REPOSITORY/registry."
  value       = aws_ecr_repository.app.repository_url
}

output "cluster_name" {
  value = module.eks.cluster_name
}

output "update_kubeconfig_command" {
  description = "Run this to point kubectl at the cluster."
  value       = "aws eks update-kubeconfig --name ${module.eks.cluster_name} --region ${var.region}"
}

# ---- GitHub Actions secrets (mark the workflow secrets from these) ----
output "ci_aws_access_key_id" {
  description = "Set as GitHub secret AWS_ACCESS_KEY_ID."
  value       = aws_iam_access_key.ci.id
}

output "ci_aws_secret_access_key" {
  description = "Set as GitHub secret AWS_SECRET_ACCESS_KEY."
  value       = aws_iam_access_key.ci.secret
  sensitive   = true
}
