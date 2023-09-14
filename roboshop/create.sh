#!/bin/bash
AMI_ID=$(aws ec2 describe-images --filters "Name=name,Values=DevOps-LabImage-CentOS7-Backup" | jq '.Images[].ImageId' | sed -e 's/"//g')

echo "AMI id is $AMI_ID"
#aws ec2 describe-images --filters "Name=name,Values=DevOps-LabImage-CentOS7-Backup"   #aws cli commands for ami

