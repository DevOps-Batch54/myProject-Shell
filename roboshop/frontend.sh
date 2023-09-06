
echo -n "Install the nginx: "
if ( $? -ne 0 ) ; then
        echo -n "
fi
yum install nginx -y &>> /tmp/frontend.log


# yum install nginx -y
# systemctl enable nginx
# systemctl start nginx