#!bin/bash
COMPONENT=redis
source common.sh

echo -e " ******* \e[35m $COMPONENT installation has Started \e[0m *******"
echo -n "Download the $COMPONENT repo components :"
curl -L https://raw.githubusercontent.com/stans-robot-project/$COMPONENT/main/$COMPONENT.repo -o /etc/yum.repos.d/$COMPONENT.repo
stat $?
echo -n "Install the $COMPONENT file :"
yum install redis-6.2.13 -y &>> LOGFILE
stat $?

echo -n "Update the $COMPONENT.conf file :"
sed -i -e 's/bind 127.0.0.1 -::1/bind 0.0.0.0 -::1/' /etc/redis.conf
stat $?

echo -n "Start the $COMPONENT service :"
systemctl enable redis
systemctl start redis
stat $?


echo -e " ******* \e[35m $COMPONENT installation has Completed \e[0m *******"