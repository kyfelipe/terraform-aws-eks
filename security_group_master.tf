resource "aws_security_group" "master" {
  name        = "terraform-eks-master"
  description = "Cluster communication with worker nodes"
  vpc_id      = aws_vpc.eks.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
    
  tags = {
    Name = "terraform-eks-master"
  }
}

# Setup master node security group
resource "aws_security_group_rule" "ingress_workstation_https" {
  cidr_blocks       = var.accessing_computer_ips
  description       = "Allow workstation to communicate with the cluster API Server"
  from_port         = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.master.id
  to_port           = 443
  type              = "ingress"
}
