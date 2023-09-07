#!bin/bash
COMPONENT=user
APPUSER=roboshop
source common.sh

echo -e " ******* \e[35m $COMPONENT installation has started \e[0m *******"
 
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
rm -rf $COMPONENT &>> LOGFILE
unzip -o /tmp/$COMPONENT.zip &>> LOGFILE
stat $?

echo -n "Modifing the ownership :"
mv $COMPONENT-main $COMPONENT
chown -R $APPUSER:$APPUSER /home/$APPUSER/$COMPONENT
stat $? 

echo -n "Generating npm $COMPONENT artifactory :"
cd /home/$APPUSER/$COMPONENT
npm install -y &>> LOGFILE
stat $?

# echo -n "Update the $COMPONENT systemd services :"
# sed -i -e 's/MONGO_DNSNAME/mongodb.roboshop.internal/' /home/$APPUSER/$COMPONENT/systemd.service
# mv /home/$APPUSER/$COMPONENT/systemd.service /etc/systemd/system/$COMPONENT.service
# stat $?

echo -n "Start the $COMPONENT service :"
systemctl daemon-reload
systemctl enable $COMPONENT &>> LOGFILE
systemctl restart $COMPONENT &>> LOGFILE
# systemctl status catalogue -l
stat $?

echo -e " ******* \e[35m $COMPONENT installation has completed \e[0m *******"
