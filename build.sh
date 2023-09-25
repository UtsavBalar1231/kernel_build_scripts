#!/usr/bin/env bash
# shellcheck disable=SC1090,SC1091
#
# SPDX-License-Identifier: MIT
# Copyright (C) 2020-23 Utsav Balar <utsavbalar1231@gmail.com>
# Copyright (C) 2023 Vicharak Computers LLP
# Version: 5.1

# Set bash shell options
set -eE

# Set locale to C to avoid issues with some build scripts
export LC_ALL=C

# Command used for this script
CMD=$(realpath "${0}")
# Kernel directory path
SCRIPT_DIR=$(dirname "${CMD}")
export SCRIPT_DIR

echo "script called from ${SCRIPT_DIR}"

if [ ! -d "${SCRIPT_DIR}" ]; then
	echo "${SCRIPT_DIR} does not exist"
	exit 1
fi

source "${SCRIPT_DIR}"/variables
source "${SCRIPT_DIR}"/utils
source "${SCRIPT_DIR}"/functions
if [ -f "${SCRIPT_DIR}"/.device.mk ]; then
	source "${SCRIPT_DIR}"/.device.mk
fi

# Usage function to provide help on script options
function usage() {
	print "─────────────────────────────────────────────────────────────────────"
	print "          Vicharak Kernel Build Script - Usage Guide"
	print "─────────────────────────────────────────────────────────────────────"
	print " Usage: ${0} [OPTIONS]"
	print ""
	print " Available Options:"
	print "  lunch            | -l    : Prepare the environment for the chosen device"
	print "  info             | -i    : Display current kernel setup details"
	print "  clean            | -c    : Remove kernel build artifacts"
	print "  kernel           | -k    : Compile the Linux kernel image"
	print "  kerneldeb        | -K    : Generate a Debian package for the Linux kernel"
	print "  update_defconfig | -u    : Update the kernel configuration with the latest changes"
	print "  help             | -h    : Display this usage guide"
	print "─────────────────────────────────────────────────────────────────────"
}

if [ "$1" == "-h" ] || [ "$1" == "help" ]; then
	if [ -n "${2}" ] && [ "$(type -t usage"${2}")" == function ]; then
		print "----------------------------------------------------------------"
		print "--- ${2} Build Command ---"
		print "----------------------------------------------------------------"
		eval usage "${2}"
	else
		usage
	fi
	exit 0
fi

OPTIONS=("${@:-kernel}")
for option in "${OPTIONS[@]}"; do
	print "Processing option: $option"
	case ${option} in
	*.mk)
		if [ -f "${option}" ]; then
			selected_config_file=${option}
		else
			selected_config_file=$(find "${CFG_DIR}" -name "${option}")
			print "Switching to board: ${selected_config_file}"
			if [ ! -f "${selected_config_file}" ]; then
				exit_with_error "Invalid board: ${option}"
			fi
		fi
		DEVICE_MAKEFILE="${selected_config_file}"
		export DEVICE_MAKEFILE

		ln -f "${DEVICE_MAKEFILE}" "${SCRIPT_DIR}"/.device.mk
		source "${SCRIPT_DIR}"/.device.mk

		print_info
		;;
	lunch | -l) lunch_device ;;
	info | -i) print_info ;;
	clean | -c) cleanup ;;
	kernel | -k)
		check_lunch_device
		build_kernel
		;;
	dtbs | -d)
		if ! is_set "${DEVICE_ARCH}"; then
			exit_with_error "Device architecture not set!"
		fi
		if [ "${DEVICE_ARCH}" == "arm64" ]; then
			build_dtbs
		else
			exit_with_error "DTB build not supported for ${DEVICE_ARCH}"
		fi
		;;
	kerneldeb | -K) build_kerneldeb ;;
	update_defconfig | -u) update_defconfig ;;
	*)
		usage
		exit_with_error "Invalid option: ${option}"
		;;
	esac
done
