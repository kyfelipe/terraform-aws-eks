data "aws_iam_policy_document" "master" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "master" {
  name = var.iam_master_name
  assume_role_policy = data.aws_iam_policy_document.master.json
}

resource "aws_iam_role_policy_attachment" "AmazonEKSClusterPolicy" {
  # Fornece ao EKS as permissões necessárias para gerenciar recursos em seu nome.
  # O EKS requer permissões EC2 de criação de tags, instâncias, grupos de segurança e interfaces de rede elástica.  
  
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.master.name
}

resource "aws_iam_role_policy_attachment" "AmazonEKSServicePolicy" {
  # Permite que o recurso crie e gerencie o necessário para o funcionamento de um cluster EKS. 
  
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.master.name
}
