#!bin/bash

ID=$(id -u)
if [ $ID -ne 0 ] ; then
    echo -e "\e[31m This script is expected to be run as a root user or with sudo previlege \e[0m"
    exit 1
fi

echo -n "Install the nginx: "
yum install nginx -y &>> /tmp/frontend.log


# yum install nginx -y
# systemctl enable nginx
# systemctl start nginx