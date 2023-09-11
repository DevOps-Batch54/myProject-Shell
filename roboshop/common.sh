#!bin/bash

LOGFILE="/tmp/$COMPONENT.log"
APPUSER=roboshop

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

echo -e " ******* \e[35m $COMPONENT installation has started \e[0m *******"

UNZIPFILE(){
    echo -n "Downloading the $COMPONENT component :"
    curl -s -L -o /tmp/$COMPONENT.zip "https://github.com/stans-robot-project/$COMPONENT/archive/main.zip"
    stat $?

    echo -n "Copying the $COMPONENT to $APPUSER home directory :"
    cd /home/$APPUSER
    rm -rf $COMPONENT &>> $LOGFILE
    unzip -o /tmp/$COMPONENT.zip &>> $LOGFILE
    stat $?
    
    echo -n "Modifing the ownership :"
    mv $COMPONENT-main $COMPONENT
    chown -R $APPUSER:$APPUSER /home/$APPUSER/$COMPONENT
    stat $? 
}

NPM-Install(){
        echo -n "Generating npm $COMPONENT artifactory :"
        cd /home/$APPUSER/$COMPONENT
        npm install -y &>> $LOGFILE
        stat $?
}

CONFIGURE-SERVICE(){
    echo -n "Update the $COMPONENT systemd services :"
    sed -i -e 's/AMQPHOST/rabbitmq.roboshop.internal/' -e 's/USERHOST/user.roboshop.internal/' -e 's/CARTHOST/cart.roboshop.internal/' -e 's/DBHOST/mysql.roboshop.internal/' -e 's/CARTENDPOINT/cart.roboshop.internal/' -e 's/MONGO_DNSNAME/mongodb.roboshop.internal/' -e 's/REDIS_ENDPOINT/redis.roboshop.internal/' -e 's/MONGO_ENDPOINT/mongodb.roboshop.internal/' -e 's/CATALOGUE_ENDPOINT/catalogue.roboshop.internal/' /home/$APPUSER/$COMPONENT/systemd.service

    mv /home/$APPUSER/$COMPONENT/systemd.service /etc/systemd/system/$COMPONENT.service
    stat $?

    echo -n "Start the $COMPONENT service :"
    systemctl daemon-reload
    systemctl start $COMPONENT &>> $LOGFILE
    systemctl enable $COMPONENT &>> $LOGFILE
    systemctl restart $COMPONENT &>> $LOGFILE
    stat $?

    echo -e " ******* \e[35m $COMPONENT installation has completed \e[0m *******"

}

CREATE-USER() {
    id $APPUSER &>> $LOGFILE
    if [ $? -ne 0 ] ; then
    echo -n "Creating the service account :"
            useradd $APPUSER &>> $LOGFILE
            stat $?
    fi
}


NODEJS(){
    echo -n "Download the nodejs :"
    curl --silent --location https://rpm.nodesource.com/setup_16.x | sudo bash - &>>  $LOGFILE
    yum install nodejs -y &>> $LOGFILE
    stat $?
    CREATE-USER
    UNZIPFILE
    NPM-Install
    CONFIGURE-SERVICE
}
MVN_PAVKAGE() {
    echo -n "Preparing $COMOPONENT artifacts"
    cd /home/$APPUSER/$COMPONENT
    mvn clean package &>> $LOGFILE
    mv target/shipping-1.0.jar shipping.jar
    stat $?
}

JAVA() {
    echo -e " ******* \e[35m $COMPONENT installation has started \e[0m *******"
    echo -n "Installing Maven"
    yum install maven -y  &>> $LOGFILE
    stat $?
    CREATE-USER
    UNZIPFILE
    MVN_PAVKAGE
    CONFIGURE-SERVICE
}

PN_PAVKAGE() {
    echo -n "Preparing $COMOPONENT artifacts"
    cd /home/$APPUSER/$COMPONENT &>> $LOGFILE
    pip3 install -r requirements.txt &>> $LOGFILE
    stat $?
    USERID=$( id -u roboshop)
    GROUPID=$( id -g roboshop)
    echo -n "Updating the uid and gid in the $COMPONENT.ini file"
    sed -i -e 's/^uid/ c uid=$USERID/' -e 's/^gid/ c gid=$GROUPID/' /home/$APPUSER/$COMPONENT/$COMPONENT.ini
    stat $?
}

PYTHON() {
    echo -e " ******* \e[35m $COMPONENT installation has started \e[0m *******"
    echo -n "Installing Python"
    yum install python36 gcc python3-devel -y  &>> $LOGFILE
    stat $?
    CREATE-USER
    UNZIPFILE
    PN_PAVKAGE
    CONFIGURE-SERVICE
}