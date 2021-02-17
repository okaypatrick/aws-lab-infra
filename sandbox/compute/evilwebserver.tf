
resource "aws_instance" "evilwebserver" {

  ami           = "ami-0a741b782c2c8632d"
  instance_type = "t2.medium"
  associate_public_ip_address = true
  subnet_id = data.terraform_remote_state.sandbox_vpc.outputs.sbx_public_compute_01_id
  #need to add port 80 or 8000 to open ingress
  security_groups = ["${data.terraform_remote_state.sandbox_vpc.outputs.sbx_sg_ingress_allow_ssh_id}","${data.terraform_remote_state.sandbox_vpc.outputs.sbx_sg_ingress_allow_http_80_id}","${data.terraform_remote_state.sandbox_vpc.outputs.sbx_sg_egress_allow_all_id}"]

  key_name = aws_key_pair.pg.key_name

  //To-do: add a remote-exec provisioner and start a python simple HTTP web server.

    user_data = "${file("scripts/startwebserver.sh")}"


}
