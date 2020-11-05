data "aws_eks_cluster_auth" "ipaas" {
  name = local.cluster_name
}

data "template_file" "kubeconfig" {
  count = var.create_kubeconfig ? 1 : 0
  template = file("${path.module}/kubeconfig.tpl")

  vars = {
    region       = var.region
    cluster_name = local.cluster_name
    endpoint     = aws_eks_cluster.tf_eks.endpoint
    ca           = aws_eks_cluster.tf_eks.certificate_authority[0].data
  }

  depends_on = [aws_eks_cluster.tf_eks]
}

resource "local_file" "kubeconfig" {
  count           = var.create_kubeconfig ? 1 : 0
  content         = data.template_file.kubeconfig[0].rendered
  filename        = var.kubeconfig_path
  file_permission = 600
}
