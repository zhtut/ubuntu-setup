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
    swift_version=$(get_latest_swift_version)
    folder_name=swift-$swift_version-RELEASE-ubuntu20.04
    tar_file_name=${folder_name}.tar.gz
    tar_file_path=${tar_file_name}
    curl -O "https://download.swift.org/swift-$swift_version-release/ubuntu2004/swift-$swift_version-RELEASE/$tar_file_name" ${tar_file_path}
    tar xvf ${tar_file_path}
    rm ${tar_file_path}
    sudo mv -r $folder_name $swift_path
}

import_sign_key() {
    wget -q -O - https://swift.org/keys/all-keys.asc | gpg --import -
}

config_envrioment() {
    profile_path="/etc/profile"
    profile_content=$(sudo cat ${profile_path})
    echo "$profile_content\n  PATH=\"${swift_path}/usr/bin:\$PATH\"" >${profile_path}
    sudo source ${profile_path}
}

if [ -e $swift_path ]; then
    now_version=$(swift --version)
    latest_version=$(get_latest_swift_version)
    version_str="Apple Swift version ${latest_version} "
    if [[ ${now_version} =~ ${version_str} ]]; then
        echo "${now_version}当前版本已是最新版${latest_version}"
    else
        echo 'Swift 旧版本已存在，删除旧版，下载最新版本'
        rm -rf $swift_path
        download_swift_package
    fi
else
    echo "swift路径不存在，第一次下载"
    download_swift_package
fi

if [[ $(sudo apt show uuid-dev) =~ "No packages found" ]]; then
    install_dependency
    import_sign_key
else
    echo "已配置安装第三方依赖"
fi

if [[ $(echo $PATH) =~ "swift" ]]; then
    echo "已配置好环境变量"
else
    config_envrioment
fi

swift --version
