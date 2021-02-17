output "sbx_vpc_compute_id" {
    value = aws_vpc.sandbox_compute.id 
}

output "sbx_public_compute_01_id" {
    
    value = aws_subnet.sbx_public_compute_01.id 
}

output "sbx_vpc_eks_id" {
    value = aws_vpc.sandbox_compute.id 
}

output "sbx_public_eks_01_id" {
    
    value = aws_subnet.sbx_public_eks_01.id 
}

output "sbx_sg_ingress_allow_ssh_id" {

    value = aws_security_group.allow_ingress_ssh.id 
}

output "sbx_sg_ingress_allow_http_80_id" {

    value = aws_security_group.allow_ingress_http_80.id
}

output "sbx_sg_egress_allow_all_id" {

    value = aws_security_group.allow_egress_all.id
}
output "sbx_sg_ingress_allow_ssh_name" {

    value = aws_security_group.allow_ingress_ssh.name  
}

output "sbx_sg_egress_allow_all_name" {

    value = aws_security_group.allow_egress_all.name 
}