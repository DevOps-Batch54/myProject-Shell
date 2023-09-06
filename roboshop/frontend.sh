#!bin/bash

COMPONENT=frontend

ID=$(id -u)
if [ $ID -ne 0 ] ; then
    echo -e "\e[31m This script is expected to be run as a root user or with sudo previlege \e[0m"
    exit 1
fi

echo -n "Install the nginx: "
yum install nginx -y &>> "/tmp/$COMPONENT.log"
if [ $? -eq 0 ] ; then
        echo -e "\e[35m Success \e[0m"
    else
        echo -e "\e[35m Failure \e[0m"
fi

echo -n "Download the $COMPONENT component"
curl -s -L -o /tmp/$COMPONENT.zip "https://github.com/stans-robot-project/$COMPONENT/archive/main.zip"
if [ $? -eq 0 ] ; then
        echo -e "\e[35m Success \e[0m"
    else
        echo -e "\e[35m Failure \e[0m"
fi

# systemctl enable nginx
# systemctl start nginx