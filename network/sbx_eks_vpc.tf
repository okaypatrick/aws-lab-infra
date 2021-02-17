#This VPC is the default Sandbox VPC for EKS cluster

resource "aws_vpc" "sandbox_eks" {

    cidr_block = "172.31.0.0/16"
    instance_tenancy = "default"

    tags = {

        Name = "sandbox_eks"
    }

}