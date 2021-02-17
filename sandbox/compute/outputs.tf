output "jumpbox_public_ip" {

    value = aws_instance.jumpbox.public_ip 

}


output "evilwebserver_public_ip" {

    value = aws_instance.evilwebserver.public_ip 

}