#!bin/bash
COMPONENT=redis
source common.sh

echo -e " ******* \e[35m $COMPONENT installation has Started \e[0m *******"
echo -n "Download the $COMPONENT repo components :"
curl -L https://raw.githubusercontent.com/stans-robot-project/redis/main/redis.repo -o /etc/yum.repos.d/redis.repo
stat $?
echo -n "Install the redis file for $COMPONENT :"
yum install redis-6.2.11 -y &>> LOGFILE
stat $?


echo -e " ******* \e[35m $COMPONENT installation has Completed \e[0m *******"