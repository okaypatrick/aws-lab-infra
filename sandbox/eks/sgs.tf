
#sgs.tf
#holds all security groups and rules for EKS SBX cluster


resource "aws_security_group" "efs_mount_sg" {

    name = "efs_mount_sg"
    description = "Amazon EFS for EKS, SG for mount target"
    vpc_id = aws_vpc.sbx.id

    tags = {
        Name = "eks-sbx-sg-efs-allow-ingress-mt"
    }

    ingress {

        description = "Allow EKS nodes to access EFS"
        from_port = 2049
        to_port = 2049
        protocol = "tcp"
        cidr_blocks = ["10.0.0.0/16"]

    }

}


//These SGs are for the temp jumpbox to do troubleshooting --------
resource "aws_security_group" "allow_ingress_ssh" {

    name = "allow_ingress_ssh"
    description = "Allow inbound SSH traffic"
    vpc_id = aws_vpc.sbx.id 

    tags = {

        Name = "eks-sbx-sg-ingress-allow-ssh"

    }

    ingress {
        
        description = "SSH from anywhere"
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_security_group" "allow_egress_all" {

    name = "allow_outbound_all"
    description = "for public subnets only, allow outbound all ports and protocols"
    vpc_id = aws_vpc.sbx.id

    tags = {

        Name = "eks-sbx-sg-egress-allow-all"

    }


    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

}