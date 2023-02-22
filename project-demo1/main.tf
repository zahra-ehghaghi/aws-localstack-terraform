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


variable "vpc_cidr_blocks" {   
  description = "vpc cidr block range"
}
variable "subnet_cidr_block" {
    description=" subnet cidr block"
}
variable "avail_zone" {}

variable "env_prefix" {}

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

  



