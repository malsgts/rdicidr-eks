# IAM user GitHub Actions uses to push images and deploy. Its Kubernetes
# permissions come from the EKS access entry in eks.tf; this policy only grants
# the AWS-API actions needed to (a) push to ECR and (b) fetch the kubeconfig.
resource "aws_iam_user" "ci" {
  name = var.ci_user_name
  tags = var.tags
}

resource "aws_iam_access_key" "ci" {
  user = aws_iam_user.ci.name
}

data "aws_iam_policy_document" "ci" {
  # ECR auth token is account-wide and cannot be scoped to a repository.
  statement {
    sid       = "EcrAuth"
    effect    = "Allow"
    actions   = ["ecr:GetAuthorizationToken"]
    resources = ["*"]
  }

  # Push/pull scoped to this one repository.
  statement {
    sid    = "EcrPushPull"
    effect = "Allow"
    actions = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "ecr:InitiateLayerUpload",
      "ecr:UploadLayerPart",
      "ecr:CompleteLayerUpload",
      "ecr:PutImage",
    ]
    resources = [aws_ecr_repository.app.arn]
  }

  # Needed for `aws eks update-kubeconfig`; kubectl authz is handled by the
  # EKS access entry, not IAM.
  statement {
    sid       = "EksDescribe"
    effect    = "Allow"
    actions   = ["eks:DescribeCluster"]
    resources = [module.eks.cluster_arn]
  }
}

resource "aws_iam_policy" "ci" {
  name   = "${var.ci_user_name}-deploy"
  policy = data.aws_iam_policy_document.ci.json
}

resource "aws_iam_user_policy_attachment" "ci" {
  user       = aws_iam_user.ci.name
  policy_arn = aws_iam_policy.ci.arn
}
