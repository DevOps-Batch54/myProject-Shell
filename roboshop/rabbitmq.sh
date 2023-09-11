#!/bin/bash
COMPONENT=rabbitmq
source common.sh

echo -e " ******* \e[35m $COMPONENT installation has started \e[0m *******"
echo -n "Configuration the $COMPONENT repo"
curl -s https://packagecloud.io/install/repositories/$COMOPONENT/erlang/script.rpm.sh | sudo bash &>> $LOGFILE
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | sudo bash &>> $LOGFILE
stat $?

echo -n "Installing $COMPONENT :"
yum install rabbitmq-server -y &>> $LOGFILE
stat $?

echo -n "Starting the $COMPONENT :"
systemctl enable rabbitmq-server &>> $LOGFILE 
systemctl start rabbitmq-server &>> $LOGFILE
stat $?

sudo rabbitmqctl list_users | grep roboshop
if [ $? -ne 0 ] ; then 
echo -n "Creating the $COMPONENT $APPUSER"
rabbitmqctl add_user roboshop roboshop123 &>> $LOGFILE
stat $?
fi
echo -n "Configuring the $COMPONENT $APPUSER privileges"
rabbitmqctl set_user_tags roboshop administrator &>> $LOGFILE
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>> $LOGFILE
stat $?