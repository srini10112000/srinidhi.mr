provider "aws" {
region = "ap-southeast-2"
}

#creating vpc using variable

variable "vpc" {
default = "10.0.0.0/16"
}

variable "subnet" {
default = "10.0.0.0/21"
}

resource "aws_key_pair" "ktm" {
key_name = "aws_key1"
public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC4lPGCUgGXeklOMc2iv8Ro12YgA8dZ0f4jPWeaScZYLCJ/dgKazz5jocEeKOR/7vmAkJcbEPN+9B1GH/TO8Ehk3faRCc51ZfC4U0AmGm6xHE3Laz8FKI8+mNbHZ2pIfdv0rryNdhTUB8oOUMUGEH/vC52B5KREveY3s1xdyiknfj/0tcmuvmn7r2P42xUaDBA4FyXPF12JhqTo38B33tn/gRIZnImTN66XJTSVzXQOHxFxL3aNS+6YkTZ58Vyl14DoBQsRJ3SAX1to+Z5IdULHsJ9nzCYgm1gc5V7yZzjaCbGFjDEIEeEXwhPufP0fY6LNvI2JUzIDjJz5CojCNfiDN91nkyvFP4v9ClFV+Y/ghHK06OxDJrKqsYqmJOcZriypKuXVttvDKvaNX/6fCQvwZBmxgnp76jp0k92eIXl96CEgFCMUGSEvdlpIXJeQIvBK6P/uxlJzqkgcnzEzVQ8qT7GD/WGEWxyn4Dy7AYUBViG2zAusv/dM2y7xlPN2WfU= ubuntu@ip-172-31-33-178"
}

#creating vpc

resource "aws_vpc" "vpc1" {
cidr_block = var.vpc
}

#creating subnet using vpc and variable

resource "aws_subnet" "sb" {
vpc_id = aws_vpc.vpc1.id
cidr_block = var.subnet
map_public_ip_on_launch =true
}

#creatig internet gateway for below vpc

resource "aws_internet_gateway" "igw" {
vpc_id = aws_vpc.vpc1.id
}

#creating route table for givenn vpc

resource "aws_route_table" "rt" {
vpc_id = aws_vpc.vpc1.id

route {
cidr_block = "0.0.0.0/0"
gateway_id = aws_internet_gateway.igw.id
}

}

#connecting route table with subnet called subnet association
resource "aws_route_table_association" "as" {
subnet_id = aws_subnet.sb.id
route_table_id = aws_route_table.rt.id
}

#writing security group for below vpc

resource "aws_security_group" "sgw" {
vpc_id = aws_vpc.vpc1.id


ingress {
from_port = 22
to_port = 22
protocol = "tcp"
cidr_blocks = ["0.0.0.0/0"]
}
ingress {
from_port = 80
to_port = 80
protocol = "tcp"
cidr_blocks = ["0.0.0.0/0"]
}
egress {
from_port = 0
to_port = 0
protocol = "-1"
cidr_blocks = ["0.0.0.0/0"]
}
tags = {
name = "sq"
}

}
 # creating ec2 and linking subnet and security group
resource "aws_instance" "aws" {
ami = "ami-080660c9757080771"
instance_type = "t2.micro"
subnet_id =  aws_subnet.sb.id
key_name = "aws_key1"
#route_table_id = aws_route-table.rt.id
vpc_security_group_ids = [aws_security_group.sgw.id]


connection {
type = "ssh"
host = self.public_ip
user = "ubuntu"
private_key = file("/home/ubuntu/aws_key1")
timeout = "4m"
}


provisioner "file" {
    source      = "/home/ubuntu/d1/app.py"  # Replace with the path to your local file
    destination = "/home/ubuntu/app.py"  # Replace with the path on the remote instance
  }

provisioner "local-exec" {
command = "touch h"

}
  provisioner "remote-exec" {
    inline = [
      "echo 'Hello from the remote instance'",
      "sudo apt update -y",  # Update package lists (for ubuntu)
      "sudo apt-get install -y python3-pip",  # Example package installation
      "cd /home/ubuntu",
      "sudo pip3 install flask",
      "sudo python3 app.py &",
    ]
  }
}
