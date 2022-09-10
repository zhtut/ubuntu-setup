#!/bin/bash
#install_swift.sh

new_folder_name="$HOME/swift-RELEASE-ubuntu20.04"

install_dependency() {
  sudo apt-get update
  sudo apt-get install \
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
    zlib1g-dev \
    libmysqlclient-dev
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
  folder_name=$HOME/swift-$swift_version-RELEASE-ubuntu20.04
  tar_file_name=${folder_name}.tar.gz
  tar_file_path=$HOME/${tar_file_name}
  curl -O "https://download.swift.org/swift-$swift_version-release/ubuntu2004/swift-$swift_version-RELEASE/$tar_file_name" ${tar_file_path}
  tar xvf ${tar_file_path}
  rm ${tar_file_path}
  mv $tar_file_path $new_folder_name
}

import_sign_key() {
  wget -q -O - https://swift.org/keys/all-keys.asc |
    gpg --import -
}

config_envrioment() {
  profile_content=$(cat .profile)
  echo "$profile_content\n  PATH=\"\$HOME/$new_folder_name/usr/bin:\$PATH\"" >$HOME/.profile
  source .profile
}

if [ -e $new_folder_name ]; then
  now_version=$(swift --version)
  latest_version=$(get_latest_swift_version)
  version_str="Apple Swift version ${latest_version} "
  if [[ ${now_version} =~ ${version_str} ]]; then
    echo "${now_version}当前版本已是最新版${latest_version}"
  else
    rm -rf $new_folder_name
    echo 'Swift 旧版本已存在，删除旧版，下载最新版本即可'
  fi
else
  install_dependency
  import_sign_key
  config_envrioment
fi
download_swift_package

swift --version
