#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#

# Modify default IP
#sed -i 's/192.168.1.1/192.168.50.5/g' package/base-files/files/bin/config_generate
#!/bin/bash
shopt -s extglob

SHELL_FOLDER=$(dirname $(readlink -f "$0"))

rm -rf target/linux package/kernel package/boot package/firmware/linux-firmware include/{kernel-*,netfilter.mk}
latest="$(curl -sfL https://github.com/openwrt/openwrt/commits/master/include | grep -o 'href=".*>kernel: bump 5.15' | head -1 | cut -d / -f 5 | cut -d '"' -f 1)"
latest=""
mkdir new; cp -rf .git new/.git
cd new
[ "$latest" ] && git reset --hard $latest || git reset --hard origin/master
git checkout HEAD^
[ "$(echo $(git log -1 --pretty=short) | grep "kernel: bump 5.15")" ] && git checkout $latest

cp -rf --parents target/linux package/kernel package/boot package/firmware/linux-firmware include/{kernel-*,netfilter.mk} ../
cd -

kernel_v="$(cat include/kernel-5.15 | grep LINUX_KERNEL_HASH-* | cut -f 2 -d - | cut -f 1 -d ' ')"
echo "KERNEL=${kernel_v}" >> $GITHUB_ENV || true
sed -i "s?targets/%S/.*'?targets/%S/$kernel_v'?" include/feeds.mk

svn export --force https://github.com/openwrt/packages/trunk/kernel feeds/packages/kernel
svn export --force  https://github.com/openwrt/packages/trunk/net/xtables-addons feeds/packages/net/xtables-addons

svn co https://github.com/coolsnowwolf/lede/trunk/target/linux/generic/hack-5.15 target/linux/generic/hack-5.15

sed -i "s/tty\(0\|1\)::askfirst/tty\1::respawn/g" target/linux/*/base-files/etc/inittab


rm -rf package/boot/uboot-envtools package/firmware/ipq-wifi package/firmware/ath11k* package/kernel/mac80211 target/linux/generic
svn export --force https://github.com/robimarko/openwrt/branches/ipq807x-5.15-pr/package/boot/uboot-envtools package/boot/uboot-envtools
svn export --force https://github.com/robimarko/openwrt/branches/ipq807x-5.15-pr/package/firmware/ipq-wifi package/firmware/ipq-wifi
svn export --force https://github.com/robimarko/openwrt/branches/ipq807x-5.15-pr/package/firmware/ath11k-firmware package/firmware/ath11k-firmware
svn export --force https://github.com/robimarko/openwrt/branches/ipq807x-5.15-pr/package/kernel/mac80211 package/kernel/mac80211
svn export --force https://github.com/robimarko/openwrt/branches/ipq807x-5.15-pr/package/kernel/qca-nss-dp package/kernel/qca-nss-dp
svn export --force https://github.com/robimarko/openwrt/branches/ipq807x-5.15-pr/package/kernel/qca-ssdk package/kernel/qca-ssdk

svn co https://github.com/robimarko/openwrt/branches/ipq807x-5.15-pr/target/linux/generic target/linux/generic
rm -rf target/linux/generic/.svn
svn co https://github.com/coolsnowwolf/lede/trunk/target/linux/generic/hack-5.15 target/linux/generic/hack-5.15

svn co https://github.com/robimarko/openwrt/branches/ipq807x-5.15-pr/target/linux/ipq807x target/linux/ipq807x

git clone https://github.com/robimarko/nss-packages --depth 1 package/nss-packages

rm -rf package/network

svn co https://github.com/robimarko/openwrt/branches/ipq807x-5.15-pr/package/network package/network

curl -sfL https://raw.githubusercontent.com/robimarko/openwrt/ipq807x-5.15-pr/include/kernel-5.15 -o include/kernel-5.15
kernel_v="$(cat include/kernel-5.15 | grep LINUX_KERNEL_HASH-* | cut -f 2 -d - | cut -f 1 -d ' ')"
echo "KERNEL=${kernel_v}" >> $GITHUB_ENV || true
sed -i "s?targets/%S/.*'?targets/%S/$kernel_v'?" include/feeds.mk

curl -sfL https://raw.githubusercontent.com/robimarko/openwrt/ipq807x-5.15-pr/package/kernel/linux/modules/netsupport.mk -o package/kernel/linux/modules/netsupport.mk

curl -sfL https://raw.githubusercontent.com/Boos4721/openwrt/master/target/linux/ipq807x/patches-5.15/700-ipq8074-overclock-cpu-2.2ghz.patch -o target/linux/ipq807x/patches-5.15/700-ipq8074-overclock-cpu-2.2ghz.patch

rm -rf package/kernel/mt76

sed -i "s/tty\(0\|1\)::askfirst/tty\1::respawn/g" target/linux/*/base-files/etc/inittab

sed -i '$a  \
CONFIG_CPU_FREQ_GOV_POWERSAVE=y \
CONFIG_CPU_FREQ_GOV_USERSPACE=y \
CONFIG_CPU_FREQ_GOV_ONDEMAND=y \
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=y \
CONFIG_SHORTCUT_FE=y \
' target/linux/ipq807x/config-5.15

echo '??????????????????'
sed -i 's/OpenWrt/RedmiAX6/g' package/base-files/files/bin/config_generate

echo '??????????????????'
sed -i 's/192.168.1.1/192.168.31.1/g' package/base-files/files/bin/config_generate

#echo '??????????????????'
#sed -i '/uci commit system/i\uci set system.@system[0].hostname="Redmi_AX6"' package/lean/default-settings/files/zzz-default-settings

echo '???????????????'
sed -i '/customized in this file/a net.netfilter.nf_conntrack_max=165535' package/base-files/files/etc/sysctl.conf

echo '????????????'
sed -i "s/'UTC'/'CST-8'\n        set system.@system[-1].zonename='Asia\/Shanghai'/g" package/base-files/files/bin/config_generate

#echo '??????????????????'
#sed -i 's/config internal themes/config internal themes\n    option Argon  \"\/luci-static\/argon\"/g' feeds/luci/modules/luci-base/root/etc/config/luci

echo '????????????wifi??????ssid'
sed -i 's/ssid=OpenWrt/ssid="Redmi AX6"/g' package/kernel/mac80211/files/lib/wifi/mac80211.sh

echo '????????????wifi?????????????????????'
sed -i 's/encryption=none/encryption=sae-mixed/g' package/kernel/mac80211/files/lib/wifi/mac80211.sh
sed -i '/set wireless.default_radio${devidx}.encryption=sae-mixed/a\set wireless.default_radio${devidx}.key=password' package/kernel/mac80211/files/lib/wifi/mac80211.sh

#echo '??????schedutil?????????'
#sed -i '/CONFIG_CPU_FREQ_GOV_ONDEMAND=y/a\CONFIG_CPU_FREQ_GOV_SCHEDUTIL=y' target/linux/ipq807x/config-5.15
#sed -i 's/# CONFIG_CPU_FREQ_GOV_SCHEDUTIL is not set/CONFIG_CPU_FREQ_GOV_SCHEDUTIL=y/g' target/linux/ipq807x/config-5.15
#sed -i 's/# CONFIG_CPU_FREQ_GOV_POWERSAVE is not set/CONFIG_CPU_FREQ_GOV_POWERSAVE=y/g' target/linux/ipq807x/config-5.15
#sed -i 's/# CONFIG_CPU_FREQ_STAT is not set/CONFIG_CPU_FREQ_STAT=y/g' target/linux/ipq807x/config-5.15
#sed -i '/CONFIG_CPU_FREQ_GOV_ONDEMAND=y/a\CONFIG_CPU_FREQ_GOV_SCHEDUTIL=y' target/linux/ipq807x/Makefile
sed -i 's/mu_beamformer=0/mu_beamformer=1/g' package/kernel/mac80211/files/lib/wifi/mac80211.sh

