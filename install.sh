#!/bin/bash
echo "切换成zsh"
if [[ $(echo $0) =~ "zsh" ]]; then
    echo "当前是zsh"
else
    sudo apt install zsh
    exec zsh
fi

echo "--->>>更新系统组件"
sudo apt update

echo "添加公钥"
echo "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFPr9sQ7fdrZTVF0Q+EKok8LeqJbl0smiC57YOXtRUz+ zhtg@icloud.com" | sudo tee -a ~/.ssh/authorized_keys
sudo service sshd restart

echo "--->>>安装Swift工具链"
sh install_swift.sh

echo "--->>>安装nginx"
sh install_nginx.sh

echo "--->>>开启swap交换"
sh open_swap.sh

echo "--->>>安装supervisor"
sh install_supervisor.sh

echo "--->>>clone repos"
sh clone_repo.sh

echo "--->>>安装postgres"
sh install_postgres.sh
