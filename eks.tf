resource "aws_eks_cluster" "tf_eks" {
  name     = var.cluster_name
  role_arn = aws_iam_role.master.arn
  version  = var.kubernetes_version

  vpc_config {
    security_group_ids = [aws_security_group.master.id]
    subnet_ids         = aws_subnet.eks[*].id
  }

  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.AmazonEKSServicePolicy
  ]
}

resource "aws_eks_node_group" "workers" {
  for_each        = local.node_groups_expanded

  cluster_name    = var.cluster_name
  node_group_name = each.value["name"]
  node_role_arn   = aws_iam_role.worker.arn
  subnet_ids      = aws_subnet.eks[*].id
  instance_types  = [each.value["instance_type"]]
  ami_type        = each.value["ami_type"]
  disk_size       = each.value["disk_size"]

  scaling_config {
    desired_size = each.value["desired_size"]
    max_size     = each.value["max_size"]
    min_size     = each.value["min_size"]
  }

  labels = {
    node_group = each.value["name"]
  }

  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly,
    aws_eks_cluster.tf_eks
  ]
}
