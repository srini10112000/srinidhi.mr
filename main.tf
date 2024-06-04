provider "aws" {
region = "ap-southeast-2"
} 

#create vpc 

resource "aws_vpc" "vpc10" {
cidr_block = "10.0.0.0/16"
}

#creste subnet using vpc 

resource "aws_subnet" "sb10" {
cidr_block = "10.0.0.0/21"
vpc_id = aws_vpc.vpc10.id
}

#create internet-gateway

resource "aws_internet_gateway" "igw10" {
vpc_id = aws_vpc.vpc10.id
}

#create route table 
resource "aws_route_table" "rt10"{
vpc_id = aws_vpc.vpc10.id


route {
cidr_block = "0.0.0.0/0"
gateway_id = aws_internet_gateway.igw10.id
}
}

#create subnet association with route table

resource "aws_route_table_association" "rta1"{
subnet_id = aws_subnet.sb10.id
route_table_id = aws_route_table.rt10.id
}

#create security group for the vpc you r created 
resource "aws_security_group" "webSg" {
  name   = "web"
  vpc_id = aws_vpc.vpc10.id

  ingress {
    description = "HTTP from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Web-sg"
  }
} 


#creating ec2 instance and attching subnet and vpc security group 

resource "aws_instance" "ec2" {
ami = "ami-080660c9757080771"
instance_type = "t2.micro"
subnet_id = aws_subnet.sb10.id
vpc_security_group_ids = [aws_security_group.webSg.id]
}








