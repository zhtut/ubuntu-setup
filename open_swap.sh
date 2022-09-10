enable_swap() {
    echo "开启虚拟内存交换 6G"
    sudo dd if=/dev/zero of=/swapfile count=6144 bs=1M

    echo "可以使用以下命令查看一下，确保交换文件存在，创建成功。"
    ls / | grep swapfile

    echo "激活 Swap 文件"
    sudo chmod 600 /swapfile
    sudo mkswap /swapfile

    echo "开启 Swap"
    sudo swapon /swapfile

    echo "设置系统启动时自动开启 Swap"
    #使用编辑器编辑 /etc/fstab 文件，添加 Swap 自动开启的配置，这里使用 Vim进行编辑，也可以使用其他文本编辑工具，例如 nano
    fstab_filr="/etc/fstab"
    swapfile_config="/swapfile none swap sw 0 0"
    echo "${swapfile_config}" | sudo tee -a ${fstab_filr}
    cat ${fstab_filr}
}

swap_info=$(free -m | grep "Swap")
swap_info=${swap_info// /}
if [[ $(echo ${swap_info} | grep "010") != "" ]]; then
    enable_swap
else
    echo '已开启swap_info'
fi
