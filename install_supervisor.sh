status=$(supervisorctl status)
if [[ $status =~ "Command 'supervisorctl' not found" ]]; then
    sudo apt-get install supervisor
else
    echo "supervisor已安装"
fi
