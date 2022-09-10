if [[ $(apt list | grep supervisor) =~ "supervisor" ]]; then
    echo "supervisor已安装"
else
    sudo apt-get install supervisor
fi
