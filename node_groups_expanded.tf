locals {
  node_groups_expanded = { for k, v in var.node_groups : k => merge(
    {
      name          = var.node_groups[k].name
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
