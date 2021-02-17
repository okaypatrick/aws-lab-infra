#This VPC is the default Sandbox VPC for all compute engine instances

resource "aws_vpc" "sandbox_compute" {

    cidr_block = "10.0.0.0/16"
    instance_tenancy = "default"

    tags = {
        Name = "sandbox_compute"
    }
}