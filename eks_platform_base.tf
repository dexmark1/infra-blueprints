# Cluster Blueprint
# Example modular IaC, IAM and scaling logic.

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.15"

  cluster_name    = "production-platform"
  cluster_version = "1.28"

  vpc_id                   = var.vpc_id
  subnet_ids               = var.private_subnets
  enable_irsa              = true # IAM Roles for Service Accounts

  # Managed Node Groups with specific scaling & affinity logic
  eks_managed_node_groups = {
    # General workloads
    default = {
      instance_types = ["t3.medium"]
      min_size     = 3
      max_size     = 10
      desired_size = 3
    }

    # High-performance group for Auth/Database services
    # Reflects experience in pod affinity and resource isolation
    critical_apps = {
      instance_types = ["c5.large"]
      labels = {
        workload = "high-priority"
      }
      taints = [{
        key    = "dedicated"
        value  = "high-priority"
        effect = "NO_SCHEDULE"
      }]
    }
  }
}
