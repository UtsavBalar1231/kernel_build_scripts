# shellcheck shell=bash
# SPDX-License-Identifier: MIT
# Copyright (C) 2023 Utsav Balar
# Copyright (C) 2023 Vicharak Computers LLP

# Makefile for rk3399_vaaman
# This file contains variables used for building rk3399_vaaman kernel
# To disable build options, comment the line or set it to false

# Device specific
DEVICE_NAME="rk3399_vaaman"
DEVICE_DTB_FILE="rk3399-vaaman-linux"
DEVICE_DEFCONFIG="rockchip_linux_defconfig"
DEVICE_CONFIG_FRAGMENT="rk3399_vaaman.config"
DEVICE_ARCH="arm64"
DEVICE_KERNEL_IMAGE_FILE="${OUT_DIR}/arch/${DEVICE_ARCH}/boot/Image"
DEVICE_DTB_DIR="${OUT_DIR}/arch/${DEVICE_ARCH}/boot/dts/rockchip"

# Build options
# To build kernel with performance configuration
PERF_BUILD=false
# To build kernel with clang
CLANG_BUILD=true
# Build modules along with kernel
MODULES_BUILD=true
# Build debian package
DEB_BUILD=true
# Pack kernel image using extlinux
PACK_KERNEL_BUILD=true
# Device specific clang version
CLANG_DIR="/home/utsav/dev/toolchains/clang-18.0.0"
DEVICE_CLANG_VERSION="18"
# Set cmdline (mainline)
DEVICE_CMDLINE="root=/dev/mmcblk1p2 rootwait rootfstype=ext4 splash plymouth.ignore-serial-consoles console=ttyS2,1500000 console=tty1 consoleblank=0 loglevel=7 cgroup_enable=cpuset cgroup_memory=1 cgroup_enable=memory swapaccount=1"
