ssl_path="/etc/nginx/ssl"
install_nginx() {
    echo "安装nginx"
    sudo apt install nginx

    sudo mkdir -p ssl_path
    echo "拷贝证书至${ssl_path}"
    sudo cp v2ray_press_nginx_certs/* ${ssl_path}

    echo "拷贝配置文件"
    sudo cp nginx.conf /etc/nginx/sites-available/default

    echo "重启nginx"
    sudo service nginx restart
}

if [[ -e ${ssl_path} ]]; then
    echo '已安装Nginx'
else
    install_nginx
fi
