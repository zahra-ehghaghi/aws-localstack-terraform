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


variable "cidr_blocks" {
  type        = list(object({cidr_block = string
                             name=string}))
  
  description = "subnet  and vpc cidr block range"
}

resource "aws_vpc"  "development-vpc" {
  cidr_block = var.cidr_blocks[1].cidr_block
  tags = {
    name : var.cidr_blocks[1].name
  }
}



resource "aws_subnet" "dev-subnet-1" {
  vpc_id =  aws_vpc.development-vpc.id
  cidr_block = var.cidr_blocks[0].cidr_block
  availability_zone = "eu-central-1a"
  tags = {
    name : var.cidr_blocks[0].name
  }
}

data "aws_vpc"  "existing-vpc" {
  default = true
}

data "aws_subnet"  "existing-subnet" {
  vpc_id =  data.aws_vpc.existing-vpc.id
  availability_zone = "eu-central-1c"
} 
resource "aws_subnet" "dev-subnet-2" {
  vpc_id =  data.aws_vpc.existing-vpc.id  
  cidr_block = "172.31.48.0/20"
  availability_zone = "eu-central-1a"
  tags = {
    name : "dev-subnet-2"
  }

}

output "dev-vpc" {
  value       = aws_vpc.development-vpc.id 
}
output "dev-sub-1" {
  value       = aws_subnet.dev-subnet-1.id 
}
