#!bin/bash

COMPONENT=mongodb
LOGFILE="/tmp/$COMPONENT.log"
ID=$(id -u)
if [ $ID -ne 0 ] ; then
        echo -e "\e[35m This script is expected to be run as a root user or with a sudo previlege user \e[0m"
        exit 1
fi


stat(){
    if [ $? -eq 0 ] ; then
        echo -e "\e[32m Success \e[0m"
    else
        echo -e "\e[32m Failure \e[0m"
        exit 2
    fi    
}

echo -n "Download $COMPONENT component"
curl -s -o /etc/yum.repos.d/$COMPONENT.repo https://raw.githubusercontent.com/stans-robot-project/$COMPONENT/main/mongo.repo
stat $?

echo -n "Installing the $COMPONENT component"
yum install -y mongodb-org &>> LOGFILE
stat $?
# systemctl enable mongod
# systemctl start mongod
