
#EFS


data "aws_subnet_ids" "example" {
  vpc_id = aws_vpc.sbx.id 
}

/* 
output "subnet_cidr_blocks" {
  value = [for s in data.aws_subnet.example : s.cidr_block]
} */

resource "aws_efs_file_system" "jenkins-eks-efs"{

    creation_token = "jenkins-eks-efs"
    performance_mode = "generalPurpose"
    throughput_mode = "bursting"
    encrypted = "true"

    tags = {

        Name = "JenkinsEFSStorage"
    }

}

#EFS mount targets for both AZs 

resource "aws_efs_mount_target" "jenkins-efs-mt"{

    count = 2

    file_system_id = "${aws_efs_file_system.jenkins-eks-efs.id}"
    subnet_id = "${element(aws_subnet.sbx.*.id, count.index)}" //multi-subnet
    security_groups = [aws_security_group.efs_mount_sg.id]

}

#EFS access point

resource "aws_efs_access_point" "jenkins-efs-ap" {

    file_system_id = aws_efs_file_system.jenkins-eks-efs.id

    posix_user {

        uid = 1000
        gid = 1000
    }

    root_directory {
        
        #path needs to have the / at the beginning and no / at the end
        path = "/opt/bitnami/jenkins/jenkins_home" 
        creation_info {
        owner_gid   = 1000
        owner_uid   = 1000
        permissions = 777
        }
        

    }

}