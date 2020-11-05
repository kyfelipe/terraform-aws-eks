output "host" {
  value = aws_eks_cluster.tf_eks.endpoint
}

output "cluster_ca_certificate" {
  value = aws_eks_cluster.tf_eks.certificate_authority[0].data
}

output "token" {
  value = data.aws_eks_cluster_auth.ipaas.token
}
