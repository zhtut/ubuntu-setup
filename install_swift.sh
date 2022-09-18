swift_folder="swift-toolchain"
swift_path="/etc/${swift_folder}"

install_dependency() {
    sudo apt install \
        binutils \
        git \
        gnupg2 \
        libc6-dev \
        libcurl4 \
        libedit2 \
        libgcc-9-dev \
        libpython2.7 \
        libsqlite3-0 \
        libstdc++-9-dev \
        libxml2 \
        libz3-dev \
        pkg-config \
        tzdata \
        uuid-dev \
        zlib1g-dev
}

get_latest_swift_version() {
    html_content=$(curl https://github.com/apple/swift/releases)
    latest_version=$(echo "$html_content" | grep "/apple/swift/tree/swift-" | head -n1)
    latest_version=${latest_version#*/apple/swift/tree/swift-}
    latest_version=${latest_version%-RELEASE*}
    echo "${latest_version}"
}

download_swift_package() {
    swift_version="$1"
    if [[ ${swift_version} == "" ]]; then
        swift_version=$(get_latest_swift_version)
    fi
    echo "准备下载${swift_version}版本"
    folder_name=swift-$swift_version-RELEASE-ubuntu20.04
    tar_file_name=${folder_name}.tar.gz
    curl -O "https://download.swift.org/swift-$swift_version-release/ubuntu2004/swift-$swift_version-RELEASE/$tar_file_name"
    tar xvf ${tar_file_name}
    rm ${tar_file_name}
    sudo cp -rf $folder_name $swift_path
    rm -rf $folder_name

    swift --version
}

import_sign_key() {
    wget -q -O - https://swift.org/keys/all-keys.asc | gpg --import -
}

config_envrioment() {
    profile_path="/etc/profile"
    if [[ $(cat ${profile_path}) =~ "${swift_path}" ]]; then
        echo 'profile已有配置'
    else
        echo '开始配置环境变量'
        echo "
export PATH=\"${swift_path}/usr/bin:\$PATH\"" | sudo tee -a ${profile_path}
        sudo cat ${profile_path}
    fi
    source ${profile_path}
}

if [[ $(echo $PATH) =~ "${swift_path}" ]]; then
    echo "已配置好环境变量"
else
    config_envrioment
fi

echo "配置安装第三方依赖"
install_dependency

echo "配置签名key"
import_sign_key

latest_version="$1"
if [[ ${latest_version} == "" ]]; then
    latest_version=$(get_latest_swift_version)
fi
if [[ -e $swift_path ]]; then
    now_version=$(swift --version)
    version_str="Swift version ${latest_version} "
    if [[ ${now_version} =~ ${version_str} ]]; then
        echo "${now_version}当前版本已是最新版${latest_version}"
    else
        echo "Swift 版本${now_version}已存在，删除，下载版本${latest_version}"
        sudo rm -rf $swift_path
        download_swift_package ${latest_version}
    fi
else
    echo "swift路径不存在，第一次下载"
    download_swift_package ${latest_version}
fi
