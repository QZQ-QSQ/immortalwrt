#!/bin/bash
# diy-part2.sh - 在更新feeds后，编译前执行

# 1. 调整 overlay 分区大小为 3GB (3072MB)
TARGET_PROFILE="Generic"
DEVICE_NAME="x86_64"
# 查找并修改 target/linux/x86/image/Makefile 中的 rootfs 大小定义
ROOTFS_SIZE_MB=3072
sed -i "s/\(CONFIG_TARGET_ROOTFS_PARTSIZE\)=.*/\1=$ROOTFS_SIZE_MB/" .config
# 对于 x86_64，通常还需要调整镜像中 ext4 分区的大小
if [ -f "target/linux/x86/image/Makefile" ]; then
    sed -i "s/\(--rootfs-part-size \)65536/\1$(($ROOTFS_SIZE_MB*1024))/" target/linux/x86/image/Makefile
fi
echo "已设置 overlay 分区大小为 ${ROOTFS_SIZE_MB}MB"

# 2. 设置编译环境以优化空间使用，避免磁盘不足
# 启用并配置 ccache 以加速二次编译并节省空间[citation:5]
sed -i 's/# CONFIG_CCACHE=y/CONFIG_CCACHE=y/' .config
# 可选：增大ccache缓存目录大小，默认为5G[citation:5]
# echo "CONFIG_CCACHE_SIZE=\"10G\"" >> .config

# 3. 确保默认语言包包含简体中文
# 此操作通常在 .config 中通过选择 luci-i18n-base-zh-cn 等包完成

# 4. (可选) 为防编译错误，可默认禁用某些有问题的包
# DISABLE_PKGS="some-problem-package"
# for pkg in $DISABLE_PKGS; do
#     sed -i "/CONFIG_PACKAGE_${pkg}=y/d" .config
# done

echo "DIY part 2 配置完成。"
