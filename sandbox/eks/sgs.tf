
#sgs.tf
#holds all security groups and rules for EKS SBX cluster


resource "aws_security_group" "efs_mount_sg" {

    name = "efs_mount_sg"
    description = "Amazon EFS for EKS, SG for mount target"
    vpc_id = aws_vpc.sbx.id

    tags = {
        Name = "eks-efs-sg"
    }

    ingress {

        description = "Allow EKS nodes to access EFS"
        from_port = 2049
        to_port = 2049
        protocol = "tcp"
        cidr_blocks = ["10.0.0.0/16"]

    }

}