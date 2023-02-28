#!/bin/bash
sudo yum update && sudo yum install docker -y
sudo systemctl start docker
sudo usermode -aG docker ec2-user
docker run -p 8080:80 nginx