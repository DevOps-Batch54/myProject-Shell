#!/bin/bash

COMPONENT=mysql
source common.sh
echo -n "Configure the $COMPONENT repo :"
curl -s -L -o /etc/yum.repos.d/$COMPONENT.repo https://raw.githubusercontent.com/stans-robot-project/$COMPONENT/main/$COMPONENT.repo
stat $?

echo -n "Installing $COMPONENT :"
yum install $COMPONENT-community-server -y &>> LOGFILE
stat $?
echo -n "Starting the $COMPONENT"
systemctl enable mysqld &>> LOGFILE
systemctl start mysqld &>> LOGFILE
stat $?

echo -n "Fetching the default root password :"
Default_Root_Password=$(grep 'temporary password' /var/log/mysqld.log | awk '{print $NF}')
stat $?

echo "show databases;" | mysql -uroot -pRoboShop@1 &>> LOGFILE
if [ $? -ne 0 ] ; then    
    echo -n "Performing reset of root user :"
    echo "ALTER USER 'root'@'localhost' IDENTIFIED BY 'RoboShop@1';" | mysql --connect-expired-password -uroot -p${Default_Root_Password} &>> LOGFILE
    stat $?
fi

echo "show plugins;" | mysql -uroot -pRoboShop@1 | grep validate_password &>> LOGFILE
if [ $? -eq 0 ] ; then    
    echo -n "Uninstalling the validate_password plugin :"
    echo "UNINSTALL PLUGIN Validate_password;" | mysql -uroot -pRoboShop@1 &>> LOGFILE
    stat $?
fi

echo -n "Downloading the $COMPONENT schema :"
curl -s -L -o /tmp/$COMPONENT.zip "https://github.com/stans-robot-project/$COMPONENT/archive/main.zip"
stat $?
echo -n "Extracting the $COMPONENT schema :"
cd /tmp
unzip -o $COMPONENT.zip &>> LOGFILE
stat $?
echo -n "Injecting the schema :"
cd $COMPONENT-main
mysql -u root -pRoboShop@1 <shipping.sql &>>LOGFILE
stat $?


