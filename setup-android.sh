#!/usr/bin/env bash
# Setup environment for Android building

# This script only for CI
if [[ -z $CI ]]; then
	echo -e "\nThis script only for CI!\n"
	exit 1
fi

# Install packages
DEBIAN_FRONTEND=noninteractive apt-get install -y \
	bison build-essential curl flex \
        git gnupg gperf liblz4-tool \
        libncurses5-dev libsdl1.2-dev \
        libxml2 libxml2-utils lzop \
        pngcrush schedtool squashfs-tools \
        xsltproc zip zlib1g-dev \
        build-essential kernel-package \
        libncurses5-dev \
        bzip2 git python wget \
        gcc-aarch64-linux-gnu g++-aarch64-linux-gnu

# Setup Git identity
GIT_USERNAME=$(git config --global --get user.name)
GIT_EMAIL=$(git config --global --get user.email)
GIT_COLORUI=$(git config --global --get color.ui)


if [[ -z $GIT_USERNAME ]]; then
	git config --global user.name "Hendra Manudinata"
elif [[ -z $GIT_EMAIL ]]; then
	git config --global user.email "aku.hendramanu@gmail.com"
elif [[ -z $GIT_COLORUI ]]; then
	git config --global color.ui false
fi

# Clone compiler
# AOSP Clang 4639204
wget https://android.googlesource.com/platform/prebuilts/clang/host/linux-x86/+archive/android-9.0.0_r6/clang-4639204.tar.gz && mkdir ${HOME}/clang-4639204 && tar -zxvf clang-4639204.tar.gz -C ${HOME}/clang-4639204 && rm clang-4639204.tar.gz

# AOSP gcc 4.9
git clone --depth=1 https://github.com/LineageOS/android_prebuilts_gcc_linux-x86_aarch64_aarch64-linux-android-4.9 ${HOME}/gcc49-64
git clone --depth=1 https://github.com/LineageOS/android_prebuilts_gcc_linux-x86_arm_arm-linux-androideabi-4.9 ${HOME}/gcc49-32

# Setup environment variables
export KBUILD_BUILD_USER=hendramanu
export KBUILD_BUILD_HOST=CircleCI
