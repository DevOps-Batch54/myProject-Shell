#!bin/bash

COMPONENT=frontend

source common.sh

echo -e " ******* \e[35m $COMPONENT installation has Started \e[0m *******"

echo -n "Install the nginx: "
yum install nginx -y &>> $LOGFILE
stat $?

echo -n "Download the $COMPONENT component"
curl -s -L -o /tmp/$COMPONENT.zip "https://github.com/stans-robot-project/$COMPONENT/archive/main.zip"
stat $?

echo -n "Performing Cleanup"
cd /usr/share/nginx/html
rm -rf * &>> $LOGFILE
stat $?

echo -n "Extracting the $COMPONENT component: "
rm -rf $COMPONENT &>> LOGFILE
unzip -o /tmp/$COMPONENT.zip &>> $LOGFILE
mv $COMPONENT-main/* . &>> $LOGFILE
mv static/* . &>> $LOGFILE
rm -rf $COMPONENT-main README.md $LOGFILE
mv localhost.conf /etc/nginx/default.d/roboshop.conf &>> $LOGFILE
stat $?

echo -n "Updating the $COMPONENT reverse proxy details :"
for content in catalogue user cart shipping payment ; do
    sed -i -e "/$content/s/localhost/$content.roboshop.internal/" /etc/nginx/default.d/roboshop.conf
done


echo -n "Starting the $COMPONENT service"
systemctl daemon-reload
systemctl enable nginx &>> LOGFILE
systemctl start nginx &>> LOGFILE
stat $?


echo -e " ******* \e[35m $COMPONENT installation has completed \e[0m *******"