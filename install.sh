#!/bin/bash
echo "--->>>更新系统组件"
sudo apt update

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
