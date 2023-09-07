#!bin/bash
COMPONENT=catalogue
APPUSER=roboshop
LOGFILE="/tmp/$COMPONENT.log"
ID=$(id -u)
if [ $ID -ne 0 ] ; then
        echo -e "\e[32m The script is executed run as a root user or with a sudo previlege user \e[0m]"
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


echo -n "Download the nodejs :"
curl --silent --location https://rpm.nodesource.com/setup_16.x | sudo bash - &>>  LOGFILE
yum install nodejs -y &>> LOGFILE
stat $?

id $APPUSER &>> LOGFILE
if [ $? -ne 0 ] ; then
echo -n "Creating the service account :"
        useradd $APPUSER &>> LOGFILE
        stat $?
fi

echo -n "Downloading the $COMPONENT component :"
curl -s -L -o /tmp/$COMPONENT.zip "https://github.com/stans-robot-project/$COMPONENT/archive/main.zip"
stat $?

echo -n "Copying the $COMPONENT to $APPUSER home directory :"
cd /home/$APPUSER
unzip /tmp/$COMPONENT.zip &>> LOGFILE
stat $?

# $ mv catalogue-main catalogue
# $ cd /home/roboshop/catalogue
# $ npm install