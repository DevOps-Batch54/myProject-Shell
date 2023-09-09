#!/bin/bash

COMPONENT=mysql
source=common.sh
echo -n "Configure the $COMPONENT repo :"
curl -s -L -o /etc/yum.repos.d/mysql.repo https://raw.githubusercontent.com/stans-robot-project/mysql/main/mysql.repo
stat $?

echo -n "Installing $COMPONENT :"
yum install mysql-community-server -y &>> LOGFILE
stat $?
echo -n "Starting the $COMPONENT"
systemctl enable mysqld &>> LOGFILE
systemctl start mysqld &>> LOGFILE
stat $?