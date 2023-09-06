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

echo -n "Installing the $COMPONENT component :"
yum install -y mongodb-org &>> LOGFILE
stat $?

echo -n "Enable the mongodb :"
systemctl enable mongod &>> LOGFILE
    
stat $?
echo -n "Update the $COMPONENT IP adress :"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf
stat $?
echo -n "Stating the $COMPONENT service"
systemctl daemon-reload &>> LOGFILE
systemctl enable mongod &>> LOGFILE
systemctl start mongod &>> LOGFILE
stat $?

echo -n "Download the schema of $COMPONENT :"
curl -s -L -o /tmp/$COMPONENT.zip "https://github.com/stans-robot-project/$COMPONENT/archive/main.zip"
stat $?
echo -n "Extracting the $COMPONENT schema :"
cd /tmp
unzip $COMPONENT.zip
stat $?
echo -n "Injecting the schema"
cd $COMPONENT-main
mongo < catalogue.js &>>LOGFILE
mongo < users.js &>>LOGFILE
stat $?