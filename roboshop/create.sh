#!/bin/bash
AMI_ID=$(aws ec2 describe-images --filters "Name=name,Values=DevOps-LabImage-CentOS7-Backup" | jq '.Images[].ImageId' | sed -e 's/"//g')
SG_ID=$(aws ec2 describe-security-groups --filters Name=group-name,Values=B54-Allow-All | jq '.SecurityGroups[].GroupId' | sed -e 's/"//g')
echo -e "AMI id used to launch the EC2 is \e[32m $AMI_ID \e[0m"
echo -e "AMI id used to launch the EC2 is \e[35m $SG_ID \e[0m"
#aws ec2 describe-images --filters "Name=name,Values=DevOps-LabImage-CentOS7-Backup"   #aws cli commands for ami

echo -e "******* Launching Server *******"
aws ec2 run-instances --image-id ${AMI_ID} --instance-type t2.micro | jq .



