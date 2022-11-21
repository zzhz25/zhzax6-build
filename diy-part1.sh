#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part1.sh
# Description: OpenWrt DIY script part 1 (Before Update feeds)
#

# Uncomment a feed source
#sed -i 's/^#\(.*helloworld\)/\1/' feeds.conf.default

# Add a feed source
#echo 'src-git helloworld https://github.com/fw876/helloworld' >>feeds.conf.default
#echo 'src-git passwall https://github.com/xiaorouji/openwrt-passwall' >>feeds.conf.default
#echo '首页增加CPU频率动态显示'
#cp -f ../diy/mod-index.htm ./feeds/luci/modules/luci-mod-admin-full/luasrc/view/admin_status/index.htm

#echo 'enable magic'
#echo 'src-git helloworld https://github.com/fw876/helloworld'>>./feeds.conf.default
#git clone https://github.com/robbyrussell/oh-my-zsh package/base-files/files/root/.oh-my-zsh

# Install extra plugins
#git clone https://github.com/zsh-users/zsh-autosuggestions package/base-files/files/root/.oh-my-zsh/custom/plugins/zsh-autosuggestions
#git clone https://github.com/zsh-users/zsh-syntax-highlighting.git package/base-files/files/root/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
#git clone https://github.com/zsh-users/zsh-completions package/base-files/files/root/.oh-my-zsh/custom/plugins/zsh-completions

git clone git://git.netfilter.org/libnftnl
cd libnftnl
sh autogen.sh
./configure
make
make install
