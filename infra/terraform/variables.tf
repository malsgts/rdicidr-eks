variable "region" {
  description = "AWS region for all resources."
  type        = string
  default     = "us-east-1"
}

variable "project" {
  description = "Name prefix applied to all resources."
  type        = string
  default     = "rdicidr"
}

variable "cluster_name" {
  description = "EKS cluster name."
  type        = string
  default     = "rdicidr-eks"
}

variable "kubernetes_version" {
  description = "EKS control-plane version. Pick one currently on EKS standard support."
  type        = string
  default     = "1.34"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "node_instance_types" {
  description = "Instance types for the managed node group."
  type        = list(string)
  default     = ["t3.medium"]
}

variable "node_desired_size" {
  description = "Desired number of worker nodes."
  type        = number
  default     = 2
}

variable "node_min_size" {
  description = "Minimum number of worker nodes."
  type        = number
  default     = 2
}

variable "node_max_size" {
  description = "Maximum number of worker nodes."
  type        = number
  default     = 3
}

variable "ci_user_name" {
  description = "IAM user GitHub Actions uses to push to ECR and deploy to EKS."
  type        = string
  default     = "rdicidr-ci"
}

variable "tags" {
  description = "Tags applied to all resources."
  type        = map(string)
  default = {
    Project   = "rdicidr"
    ManagedBy = "terraform"
  }
}
