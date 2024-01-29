# shellcheck shell=bash
# SPDX-License-Identifier: MIT
# Copyright (C) 2023-24 Utsav Balar

# Makefile for sm8250_pipa
# This file contains variables used for building sm8250_pipa kernel
# To disable build options, comment the line or set it to false

# Device specific
DEVICE_NAME="sm8250_pipa"
DEVICE_DTB_FILE="pipa-sm8250"
DEVICE_DEFCONFIG="vendor/kona-perf_defconfig"
DEVICE_CONFIG_FRAGMENT="sm8250_pipa.config"
DEVICE_ARCH="arm64"
DEVICE_KERNEL_IMAGE_FILE="${OUT_DIR}/arch/${DEVICE_ARCH}/boot/Image"
DEVICE_DTB_DIR="${OUT_DIR}/arch/${DEVICE_ARCH}/boot/dts/qcom"

# Build options
# To build kernel with performance configuration
PERF_BUILD=false
# To build kernel with clang
CLANG_BUILD=false
# Build modules along with kernel
MODULES_BUILD=false
# Build debian package
DEB_BUILD=false
# Pack kernel image using extlinux
PACK_KERNEL_BUILD=false
# Device specific clang version
CLANG_DIR=
DEVICE_CLANG_VERSION=
# Device specific gcc version
GCC64_DIR=${KERNEL_DIR}/../toolchains/arm-gcc64
GCC32_DIR=${KERNEL_DIR}/../toolchains/arm-gcc32
