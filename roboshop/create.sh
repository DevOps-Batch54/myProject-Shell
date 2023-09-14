#!/bin/bash
AMI_ID=$(aws ec2 describe-images --filters "Name=name,Values=DevOps-LabImage-CentOS7-Backup" | jq '.Images[].ImageId' | sed -e 's/"//g')

echo -e "AMI id used to launch the EC2 is \e[32m $AMI_ID \e[0m"
#aws ec2 describe-images --filters "Name=name,Values=DevOps-LabImage-CentOS7-Backup"   #aws cli commands for ami

