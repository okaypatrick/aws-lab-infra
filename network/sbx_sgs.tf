resource "aws_security_group" "allow_ingress_ssh" {

    name = "allow_ingress_ssh"
    description = "Allow inbound SSH traffic"
    vpc_id = aws_vpc.sandbox_compute.id 

    ingress {
        
        description = "SSH from anywhere"
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_security_group" "allow_ingress_http_80" {

    name = "allow_ingress_http_port80"
    description = "Allow inbound HTTP traffic on port 80"
    vpc_id = aws_vpc.sandbox_compute.id 

    ingress {
        
        description = "HTTP from anywhere"
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
}
resource "aws_security_group" "allow_egress_all" {

    name = "allow_outbound_all"
    description = "for public subnets only, allow outbound all ports and protocols"
    vpc_id = aws_vpc.sandbox_compute.id 

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

}