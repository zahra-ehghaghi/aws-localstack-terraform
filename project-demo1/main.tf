provider "aws"{
    region = "eu-central-1"
    #access_key = "zahraehghaghi"
    #secret_key = "zahraehghaghi"
    #skip_credentials_validation = true
    #skip_metadata_api_check     = true
    #skip_requesting_account_id  = true
 endpoints {
    apigateway     = "http://localhost:4566"
    apigatewayv2   = "http://localhost:4566"
    cloudformation = "http://localhost:4566"
    cloudwatch     = "http://localhost:4566"
    dynamodb       = "http://localhost:4566"
    ec2            = "http://localhost:4566"
    es             = "http://localhost:4566"
    elasticache    = "http://localhost:4566"
    firehose       = "http://localhost:4566"
    iam            = "http://localhost:4566"
    kinesis        = "http://localhost:4566"
    lambda         = "http://localhost:4566"
    rds            = "http://localhost:4566"
    redshift       = "http://localhost:4566"
    route53        = "http://localhost:4566"
    s3             = "http://s3.localhost.localstack.cloud:4566"
    secretsmanager = "http://localhost:4566"
    ses            = "http://localhost:4566"
    sns            = "http://localhost:4566"
    sqs            = "http://localhost:4566"
    ssm            = "http://localhost:4566"
    stepfunctions  = "http://localhost:4566"
    sts            = "http://localhost:4566"

  }
}

variable "myip" {}
variable "vpc_cidr_blocks" {}
variable "subnet_cidr_block" {}
variable "avail_zone" {}
variable "env_prefix" {}
variable "instance_type" {}
variable "my_public_key_location" {}

resource "aws_vpc"  "myapp-vpc" {
  cidr_block = var.vpc_cidr_blocks
  tags = {
    name : "${var.env_prefix}-vpc"
  }
}



resource "aws_subnet" "myapp-subnet-1" {
  vpc_id =  aws_vpc.myapp-vpc.id
  cidr_block = var.subnet_cidr_block
  #availability_zone = "eu-central-1a"
  availability_zone = var.avail_zone
  tags = {
    name : "${var.env_prefix}-subnet-1"
  }
}

  
resource "aws_default_route_table" "main-rtb" {
  default_route_table_id= aws_vpc.myapp-vpc.default_route_table_id
  #vpc_id =  aws_vpc.myapp-vpc.id
  route  {
    cidr_block="0.0.0.0/0"
    gateway_id= aws_internet_gateway.myapp-igw.id
  }
   tags = {
    name : "${var.env_prefix}-main-rtb"
  }
}

resource "aws_internet_gateway" "myapp-igw" {
  vpc_id =  aws_vpc.myapp-vpc.id
  tags = {
    name : "${var.env_prefix}-igw-1"
  }
}

/*resource "aws_route_table_association" "a-rtb-subnet" { 
  route_table_id=aws_route_table.myapp-route-table.id
  subnet_id=aws_subnet.myapp-subnet-1.id
}*/ 

resource "aws_default_security_group" "default-sg"{
  vpc_id =  aws_vpc.myapp-vpc.id
  
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks =[var.myip]
  }

  ingress {
    from_port = 8080
    to_port= 8080
    protocol = "tcp"
    cidr_blocks=["0.0.0.0/0"]
  }

  /*egress {     
    from_port = 0
    to_port= 0
    protocol = "-1"
    cidr_blocks =["0.0.0.0/0"]
    prefix_list_ids = []
  }*/ 
 
tags = {
    name : "${var.env_prefix}-default-sg"
  }
}

data "aws_ami" "latest-amazo-linux-image" {
 most_recent = true
 owners = ["amazon"]
 filter {
   name= "name"
   values = ["amzn2-ami-hvm-*-x86_64-gp2"]
 }
 filter {
   name= "virtualization-type"
   values = ["hvm"]
 }
}

resource "aws_instance" "myapp-server" {
  ami =  data.aws_ami.latest-amazo-linux-image.id
  instance_type = var.instance_type
  subnet_id =  aws_subnet.myapp-subnet-1.id
  vpc_security_group_ids = [aws_default_security_group.default-sg.id]
  availability_zone = var.avail_zone
  key_name = aws_key_pair.ssh-key.key_name
  associate_public_ip_address = true
  tags = {
      name : "${var.env_prefix}-server"
   }
   /*user_data = <<EOF
    #!/bin/bash
    sudo yum update && sudo yum install docker -y
    sudo systemctl start docker
    sudo usermode -aG docker ec2-user
    docker run -p 8080:80 nginx
   EOF*/
    user_data = file ("entry-script.sh")
}

/*output "aws_ami_id" {
value = data.aws_ami.latest-amazo-linux-image.id
}*/

resource "aws_key_pair" "ssh-key" {
  key_name = "server_key"
  public_key = file(var.my_public_key_location)

}



 
