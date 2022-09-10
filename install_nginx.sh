ssl_path="/etc/nginx/ssl"
need_reboot=0

if [[ $(sudo service nginx status) =~ "Unit nginx.service could not be found." ]]; then
    sudo apt install nginx
    need_reboot=1
else
    echo "已安装nginx"
fi

if [[ ! -e ${ssl_path} ]]; then
    echo "文件夹${ssl_path}不存在，需要创建"
    sudo mkdir -p ${ssl_path}
    need_reboot=1
else
    echo "文件夹${ssl_path}存在"
fi

if [[ $(sudo ls ${ssl_path}) == "" ]]; then
    echo "拷贝证书到${ssl_path}"
    sudo cp v2ray_press_nginx_certs/* ${ssl_path}
    need_reboot=1
else
    echo "${ssl_path}目录下已有证书"
fi

config_path="/etc/nginx/sites-available/default"
if [[ $(cat ${config_path}) =~ "ssl/v2ray.press.key" ]]; then
    echo "已有配置文件"
else
    echo "拷贝配置文件"
    sudo cp -f nginx.conf ${config_path}
    need_reboot=1
fi

if [[ ${need_reboot} == 1 ]]; then
    echo "重启nginx"
    sudo service nginx restart
else
   echo '不需要重启nginx'
fi
