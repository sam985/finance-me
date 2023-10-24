resource "aws_instance" "test-server" {
  ami = "ami-0f5ee92e2d63afc18"
  instance_type = "t2.micro"
  key_name = "Gmail_keypair"
  vpc_security_group_ids = ["sg-08f9f7e5065827435"]
  connection {
     type 		= "ssh"
     user		= "ubuntu"
     private_key	= file("./Gmail_keypair.pem")
     host		= self.public_ip
}

provisioner "remote-exec" {
    inline = ["echo 'wait to start the instance' "]
}
tags = {
  Name = "test-server"
}
provisioner "local-exec" {
    command = " echo ${aws_instance.test-server.public_ip} > inventory "
}
provisioner "local-exec" {
    command = "ansible-playbook /var/lib/jenkins/workspace/finance-me/server-files/finance-playbook.yml"
}
}
