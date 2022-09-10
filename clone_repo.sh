clone_url() {
    url="$1"
    git_name=${url##*/}
    git_name=${git_name%.*}
    if [[ -e ${git_name} ]]; then
        echo "${git_name}已存在"
    else
        git clone ${url}
    fi
}
curr=$(pwd)
cd $HOME
clone_url https://github.com/zhtut/SmartTrader.git
clone_url https://github.com/zhtut/RestAPI.git
clone_url https://github.com/zhtut/Server.git
cd ${curr}
