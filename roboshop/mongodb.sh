#!bin/bash
COMPONENT=mongodb

ID=$(id -u)
if [ $ID -ne 0 ] ; then
        echo -e "e\[35m This script is expected by a root user or with a sudo previlege user \e[0m"
        exit1
fi

start (){
    if [ $? -eq 0 ] ; then
        echo -e "\e[32m Success \e[0m"
    else
        echo -e "\e[32m Failure \e[0m"
        exit2
}

echo -n "Download $COMPONENT component"
curl -s -o /etc/yum.repos.d/$COMPONENT.repo https://raw.githubusercontent.com/stans-robot-project/$COMPONENT/main/mongo.repo
stat $?