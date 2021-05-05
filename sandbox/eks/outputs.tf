#
# Outputs
#

locals {
  config_map_aws_auth = <<CONFIGMAPAWSAUTH


apiVersion: v1
kind: ConfigMap
metadata:
  name: aws-auth
  namespace: kube-system
data:
  mapRoles: |
    - rolearn: ${aws_iam_role.sbx-node.arn}
      username: system:node:{{EC2PrivateDNSName}}
      groups:
        - system:bootstrappers
        - system:nodes
CONFIGMAPAWSAUTH

  kubeconfig = <<KUBECONFIG


apiVersion: v1
clusters:
- cluster:
    server: ${aws_eks_cluster.sbx.endpoint}
    certificate-authority-data: ${aws_eks_cluster.sbx.certificate_authority[0].data}
  name: kubernetes
contexts:
- context:
    cluster: kubernetes
    user: aws
  name: aws
current-context: aws
kind: Config
preferences: {}
users:
- name: aws
  user:
    exec:
      apiVersion: client.authentication.k8s.io/v1alpha1
      command: aws-iam-authenticator
      args:
        - "token"
        - "-i"
        - "${var.cluster-name}"
KUBECONFIG
}

output "config_map_aws_auth" {
  value = local.config_map_aws_auth
}

output "kubeconfig" {
  value = local.kubeconfig
}

output "efs-name" {

  value = aws_efs_file_system.jenkins-eks-efs.tags 
}

output "efs-id" {

  value = aws_efs_file_system.jenkins-eks-efs.id 

}

output "mount_target_subnet_ids" {

  value = aws_efs_mount_target.jenkins-efs-mt[*].id

}

output "efs_access_point_id" {

  value = aws_efs_access_point.jenkins-efs-ap.id 
}

output "aws_vpc_cidr" {

  value = aws_vpc.sbx.cidr_block
}


//These outputs are for temporary jumpbox used for troubleshooting.

output "aws_eks_sandbox_subnet_id" {

  value = aws_subnet.sbx[*].id 

}

output "eks_sandbox_sg_ingress_allow_ssh_id" {

  value = aws_security_group.allow_ingress_ssh.id 

}

output "eks_sandbox_sg_egress_allow_all_id" {

  value = aws_security_group.allow_egress_all.id 

}