locals {

    az = [
        "us-west-1a",
        "us-west-1b"
    
    ]

}
/*
*********************************PUBLIC SUBNETS*************************************
*/

#public subnet for EC2 
resource "aws_subnet" "sbx_public_compute_01" {

    vpc_id = aws_vpc.sandbox_compute.id
    cidr_block = "10.0.0.0/21"
    availability_zone = local.az[0]

    tags = {

        Name = "sbx_compute_public_01"
    }

}
#Internet gateway for public EC2 subnet
resource "aws_internet_gateway" "sbx_compute_network_ig"{

    vpc_id = aws_vpc.sandbox_compute.id
}

#Route table entry for egress public Internet traffic
resource "aws_route_table" "us_west_1a_public_compute_01" {

    vpc_id = aws_vpc.sandbox_compute.id

    route {
        cidr_block = "0.0.0.0/0"
        //gateway_id = "${aws_internet_gateway.sbx-network-ig.id}"
        gateway_id = aws_internet_gateway.sbx_compute_network_ig.id 
    }
}

#route table association for IG and public subnet
resource "aws_route_table_association" "default_internet_route_sbx_compute_public_01"{
    
    subnet_id = aws_subnet.sbx_public_compute_01.id 
    route_table_id = aws_route_table.us_west_1a_public_compute_01.id 

}

#public subnet for EKS cluster
resource "aws_subnet" "sbx_public_eks_01" {

    vpc_id = aws_vpc.sandbox_eks.id
    cidr_block = "172.31.0.0/21"
    availability_zone = local.az[0]

    tags = {

        Name = "sbx_eks_public_01"
    }

}
#Internet gateway for public EC2 subnet
resource "aws_internet_gateway" "sbx_eks_network_ig"{

    vpc_id = aws_vpc.sandbox_eks.id
}

#Route table entry for egress public Internet traffic
resource "aws_route_table" "us_west_1a_public_eks_01" {

    vpc_id = aws_vpc.sandbox_eks.id

    route {

        #send any network traffic not destined for AWS subnets to Internet Gateway
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.sbx_eks_network_ig.id 
    }
}

#route table association for IG and public subnet
resource "aws_route_table_association" "default_internet_route_sbx_eks_public_01"{
    
    subnet_id = aws_subnet.sbx_public_eks_01.id 
    route_table_id = aws_route_table.us_west_1a_public_eks_01.id 

}

/*
****************************END PUBLIC SUBNETS*****************************************
*/

/*
****************************PRIVATE SUBNETS***************************
*/

#Private subnet for EC2 instances
resource "aws_subnet" "sbx_private_compute_01" {

    vpc_id = aws_vpc.sandbox_compute.id
    cidr_block = "10.0.8.0/21"
    availability_zone = local.az[0]

    tags = {

        Name = "sbx_private_compute_01"
    }

}

#Private subnet for EKS -- May not need
resource "aws_subnet" "sbx_private_eks_01" {

    vpc_id = aws_vpc.sandbox_eks.id
    cidr_block = "172.31.8.0/21"
    availability_zone = local.az[0]

    tags = {

        Name = "sbx_private_eks_01"
    }

}