ssl_path="/etc/nginx/ssl"
need_reboot=0

status=$(sudo service nginx status)
if [[ $(echo ${status} | grep "Unit nginx.service could not be found.") != "" ]]; then
    sudo apt install nginx
    need_reboot=1
else
    echo "已安装nginx"
fi

if [[ ! -e ${ssl_path} ]]; then
    sudo mkdir -p ssl_path
    need_reboot=1
fi

if [[ $(ls ${ssl_path}) == "" ]]; then
    sudo cp v2ray_press_nginx_certs/* ${ssl_path}
    need_reboot=1
fi

config_path="/etc/nginx/sites-available/default"
if [[ $(cat ${config_path} | grep "ssl/v2ray.press.key") != "" ]]; then
    echo "已有配置文件"
else
    echo "拷贝配置文件"
    sudo cp -f nginx.conf ${config_path}
    need_reboot=1
fi

if [[ ${need_reboot} == 1 ]]; then
    echo "重启nginx"
    sudo service nginx restart
fi
