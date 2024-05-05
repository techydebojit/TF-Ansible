provider "aws" {
  region = var.region
}

resource "aws_security_group" "nginx" {
  name   = "nginx_access"
  vpc_id = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "nginx" {
  ami                         = var.ami_id
  subnet_id                   = var.subnet
  instance_type               = var.instance_type
  associate_public_ip_address = true
  security_groups             = [aws_security_group.nginx.id]
  key_name                    = var.key_name

  connection {
      type        = "ssh"
      user        = var.ssh_user
      private_key = file(var.private_key_path)
      host        = aws_instance.nginx.public_ip
  }

  provisioner "file" {
    source      = "ansible/inventory.ini"
    destination = "/tmp/inventory.ini"
  }

  provisioner "file" {
    source      = "ansible/playbook.yml"
    destination = "/tmp/playbook.yml"
  }

  provisioner "file" {
    source      = "ansible/index.html"  
    destination = "/tmp/index.html"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y python3-pip",
      "sudo pip3 install ansible",
      "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i /tmp/inventory.ini /tmp/playbook.yml"
    ]
  }

}

output "nginx_ip" {
  value = aws_instance.nginx.public_dns
}