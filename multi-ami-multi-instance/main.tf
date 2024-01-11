provider "aws" {
    region = "us-east-1"
    profile = "personal"
  
}
locals {
  serverconfig = [
    for srv in var.var.configuration: [
        for i in range(1,srv.no_of_instances+1): {
            instance_name = "${srv.application_name}-${1}"
            instance_type = srv.instance_type
            subnet_id = srv.subnet_id
            ami = srv.ami
            security_group = srv.security_group
        }
    ]
  ]
}

// we need to flatten it before using it.

locals {
  instances = flatten(local.serverconfig)
}

resource "aws_instance" "jenkins" {
  for_each = {for server in local.local.instances: server.instance_name => server}
  ami = each.value.ami
  instance_type =each.value.instance_type
  vpc_security_group_ids = each.value.security_group
  key_name = var.key
  user_data = <<EOF
  #!/bin/bash

  echo "Copying the SSH Key to the remote server"
  echo -e "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDvhXuMn9FwsrcK/DkgOlZdQFbY9e0+InX2sdHm8ZF7hGOQvg3CTMdBtMHlALnzqsYlS0aN0puzNF7fWAvUawdGjcSYxKEMlO1CaKPYxEgLTPDdiuYm3DNUutNMOLB0KHSJDk1Vb83UEpXm4vZjAWwHQTgoSsyXA57GcV4+IiTOy+iIIiiB7XzTDjt7ePVOW237HJAENlB/txh0qEl4Gn0eNGykg2E00jN8cOfIf/sKuY2kXBRgSjTjr6HArB4an6+aJpNJMWFFLyk47+NOIepaZhJNuXL39y0kGp/KzTlQw45g+ct92CSoCvySGqSUGN85ofPeYfzwB45yVJ9bMrZpY88TG4kLGAFeAg4DHVxUmJQhbjQOBRL8FDadOZuHmawlBUNeqFFtQ1EAad9Z2FWAZ80htaPysE9coA2VXC559VapIs9fsx2nPStKoB8bPP91rArS4Q9tt077+BgPE3d4IK2GRTYsC1TXzrF6hvGGk9zk+nWpZMqDtW5sQxdxl0k=" >> /home/ubuntu/.ssh/authorized_keys

  echo "Changing the hostname to ${each.value.instance_name}"
  hostname ${each.value.instance_name}
  echo "${each.value.instance_name}" > /etc/hostname //please check this before executing
  EOF

  subnet_id = each.value.subnet_id
  tags = {
    name = "${each.value.instance_name}"
  }
}

output "instances" {
  value = "${aws_instance.jenkins}"
  description = "All machine details"
}