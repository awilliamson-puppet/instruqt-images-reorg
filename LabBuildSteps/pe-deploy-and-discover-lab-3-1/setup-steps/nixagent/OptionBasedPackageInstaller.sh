if [ $OPTIONVAR == "httpd" ]
then
    sudo yum install -y httpd
elif [ $OPTIONVAR == "nginx" ]
then
    sudo yum install -y nginx
else
    echo $OPTIONVAR
    echo "No OPTIONVAR valid options set"
fi
