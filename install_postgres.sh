if [[ $(apt list | grep postgresql) =~ "postgresql" ]]; then
    echo '已安装postgresql'
else
    sudo apt install postgresql postgresql-contrib
fi

postgresql_conf="/etc/postgresql/*/main/postgresql.conf"
origin="#listen_addresses = 'localhost'"
replace="listen_addresses = '*'"

if [[ $(sudo cat ${postgresql_conf}) =~ "${replace}" ]]; then
    echo "不需要修改监听地址，已经是：${replace}"
else
    echo "修改监听地址"
    sudo sed -i "s|${origin}|${replace}|" ${postgresql_conf}
    echo $(sudo cat ${postgresql_conf} | grep "listen_addresses")
fi

pg_hba_conf="/etc/postgresql/*/main/pg_hba.conf"
host="host all all 0.0.0.0/0 md5"
if [[ $(sudo cat ${pg_hba_conf}) =~ "${host}" ]]; then
    echo "不需要修改可访问的ip段，已经包含：${host}"
else
    echo "修改可访问的ip段"
    echo "${host}" | sudo tee -a ${pg_hba_conf}
    echo $(sudo cat ${pg_hba_conf} | grep "host all")
fi

host_ipv6="host all all ::0/0 md5"
if [[ $(sudo cat ${pg_hba_conf}) =~ "${host_ipv6}" ]]; then
    echo "不需要修改可访问的ip段，已经包含：${host_ipv6}"
else
    echo "修改可访问的ip段"
    echo "${host_ipv6}" | sudo tee -a ${pg_hba_conf}
    echo $(sudo cat ${pg_hba_conf} | grep "host all")
fi

echo '需要设定密码'
sudo -u postgres psql
