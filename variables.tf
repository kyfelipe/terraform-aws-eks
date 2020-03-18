variable "region" {
  type        = string
  description = "AWS Region"
}

variable "access_key" {
  type        = string
  description = "AWS Access Key"
}

variable "secret_key" {
  type        = string
  description = "AWS Secret Key"
}

variable "cluster_name" {
  type        = string
  description = "EKS name"
}

variable "accessing_computer_ips" {
  type        = list(string)
  description = "cidr blocks"
}

variable "number_of_subnets" {
  type        = number
  default     = 2
  description = "Number of subnets"
}

variable "iam_master_name" {
  type = string
  default = "terraform-eks-master"
  description = "IAM master name"
}

variable "iam_worker_name" {
  type = string
  default = "terraform-eks-worker"
  description = "IAM worker name"
}

variable "iam_worker_instance_profile_name" {
  type = string
  default = "terraform-eks-worker"
  description = "IAM worker instance profile name"
}

variable "kubeconfig_path" {
  type = string
  default = "./kubeconfig"
  description = "Kubeconfig path"
}

variable "kubernetes_version" {
  type = string
  default = "1.14"
  description = "EKS kubernetes version. The value must be configured and increased to upgrade the version when desired. Downgrades are not supported by EKS."
}

variable "node_groups" {
  type = list(object({
    name          = string
    desired_size  = number
    max_size      = number
    min_size      = number
    instance_type = string
    # Opcionais
    # ami_type  = string (Default: AL2_x86_64)
    # disk_size = number (Default: 20)
  }))
  default = [
    {
      name          = "node-example"
      desired_size  = 1
      max_size      = 3
      min_size      = 1
      instance_type = "t3.micro"
    }
  ]
}
