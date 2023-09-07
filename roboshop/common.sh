#!bin/bash

LOGFILE="/tmp/$COMPONENT.log"


ID=$(id -u)
if [ $ID -ne 0 ] ; then
    echo -e "\e[31m This script is expected to be run as a root user or with sudo previlege \e[0m"
    exit 1
fi


stat(){
    if [ $? -eq 0 ] ; then
            echo -e "\e[35m Success \e[0m"
        else
            echo -e "\e[35m Failure \e[0m"
            exit 2
    fi
}