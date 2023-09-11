#!/bin/bash
COMOPONENT=rabbitmq
source common.sh

echo -e " ******* \e[35m $COMPONENT installation has started \e[0m *******"
echo -n "Configuration the $COMPONENT repo"
curl -s https://packagecloud.io/install/repositories/$COMOPONENT/erlang/script.rpm.sh | sudo bash
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | sudo bash
stat $?

echo -n "Installing $COMPONENT :"
yum install rabbitmq-server -y &>> $LOGFILE
stat $?

echo -n "Starting the $COMPONENT :"
systemctl enable rabbitmq-server &>> $LOGFILE 
systemctl start rabbitmq-server &>> $LOGFILE
stat $?