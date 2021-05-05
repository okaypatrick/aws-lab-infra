
data "terraform_remote_state" "sandbox_vpc"{

  backend = "s3"

  config = {
    
    bucket = "ppg9912-tf-state-bucket-02"
    key = "./network/terraform.tfstate"
    region = "us-west-1"

  }
}

data "terraform_remote_state" "eks_sandbox" {

  backend = "s3"

  config = {
    
    bucket = "ppg9912-tf-state-bucket-02"
    key = "./sandbox/eks/terraform.tfstate"
    region = "us-west-1"

  }

}

/* data "aws_subnet_ids" "eks_subnet_ids" {

    vpc_id = data.terraform_remote_state.eks_sandbox.outputs.aws_eks_sandbox_subnet_id[*].id
}  */

resource "aws_instance" "jumpbox" {

  ami           = "ami-0a741b782c2c8632d"
  instance_type = "t2.large"
  associate_public_ip_address = true
  subnet_id = data.terraform_remote_state.sandbox_vpc.outputs.sbx_public_compute_01_id
  security_groups = ["${data.terraform_remote_state.sandbox_vpc.outputs.sbx_sg_ingress_allow_ssh_id}","${data.terraform_remote_state.sandbox_vpc.outputs.sbx_sg_egress_allow_all_id}"]

  key_name = aws_key_pair.pg.key_name

  tags = {

    Name = "lab-jumpbox"

  }
  
}

resource "aws_instance" "jumpbox-eks" {

  count = 2 

  ami           = "ami-0a741b782c2c8632d"
  instance_type = "t2.large"
  associate_public_ip_address = true
  subnet_id = data.terraform_remote_state.eks_sandbox.outputs.aws_eks_sandbox_subnet_id[count.index]
  //[To-do] Create new security groups for ingress ssh in EKS cluster
  security_groups = ["${data.terraform_remote_state.eks_sandbox.outputs.eks_sandbox_sg_ingress_allow_ssh_id}","${data.terraform_remote_state.eks_sandbox.outputs.eks_sandbox_sg_egress_allow_all_id}"]



  key_name = aws_key_pair.pg.key_name

  tags = {
    
    Name = "temp-eks-jumpbox"

  }
  
}
