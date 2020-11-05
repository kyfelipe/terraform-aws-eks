locals {
  security_group_master = join("-", ["security-group", local.cluster_name])
  subnet_name           = join("-", ["subnet", var.project])
  igw_name              = join("-", ["internet-gateway", var.project])
  vpc_name              = join("-", ["vpc", var.project])
  iam_master_name       = join("-", ["master", local.cluster_name])
  iam_worker_name       = join("-", ["worker", local.cluster_name])
  cluster_name          = join("-", [var.cluster_name, random_id.project_identifier.hex])
  node_groups_expanded = { for k, v in var.node_groups : k => merge(
    {
      name          = join("-", [local.cluster_name, var.node_groups[k].name])
      instance_type = var.node_groups[k].instance_type
      desired_size  = var.node_groups[k].desired_size
      max_size      = var.node_groups[k].max_size
      min_size      = var.node_groups[k].min_size
      ami_type      = lookup(var.node_groups[k], "ami_type", null)
      disk_size     = lookup(var.node_groups[k], "disk_size", null)
    }
    )
  }
}
