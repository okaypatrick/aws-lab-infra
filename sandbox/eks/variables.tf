variable "aws_region" {
  default = "us-west-1"
}

variable "cluster-name" {
  default = "terraform-eks-sbx"
  type    = string
}

/*
variable "subnets" {
  type        = "list"
  description = "list of subnets to mount the fs to"
}

variable "subnets-count" {
  type        = "string"
  description = "number of subnets to mount to"
}*/