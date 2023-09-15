#!/usr/bin/env bash
# shellcheck disable=SC1090,SC1091
#
# SPDX-License-Identifier: MIT
# Copyright (C) 2020-23 Utsav Balar <utsavbalar1231@gmail.com>
# Copyright (C) 2023 Vicharak Computers LLP
# Version: 5.0

# Set bash shell options
set -eE

# Set locale to C to avoid issues with some build scripts
export LC_ALL=C

# Command used for this script
CMD=$(realpath "${0}")
# Kernel directory path
SCRIPT_DIR=$(dirname "${CMD}")/..

if [ ! -d "${SCRIPT_DIR}"/vicharak ]; then
	echo "${SCRIPT_DIR}"/vicharak does not exist
	exit 1
fi

source "${SCRIPT_DIR}"/vicharak/variables
source "${SCRIPT_DIR}"/vicharak/utils
source "${SCRIPT_DIR}"/vicharak/functions
if [ -f "${SCRIPT_DIR}"/vicharak/.device.mk ]; then
	source "${SCRIPT_DIR}"/vicharak/.device.mk
fi

# Usage function for this script to show help
function usage() {
	print "--------------------------------------------------------------------------------"
	print "Build script for Vicharak kernel"
	print "Usage: ${0} [OPTIONS]"
	print "Options:"
	print "  lunch            | -l   \tLunch device to setup environment"
	print "  info             | -i   \tShow current kernel setup information"
	print "  clean            | -c   \tCleanup the kernel build files"
	print "  kernel           | -k   \tBuild linux kernel image"
	print "  kerneldeb        | -K   \tBuild linux kernel debian package"
	print "  update_defconfig | -u   \tUpdate defconfig with latest changes"
	print "  help             | -h   \tShow this help"
	print ""
	print "--------------------------------------------------------------------------------"
}

if echo "${@}" | grep -wqE "help|-h"; then
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
	print "Processing Option: $option"
	case ${option} in
	*.mk)
		if [ -f "${option}" ]; then
			config=${option}
		else
			config=$(find "${CFG_DIR}" -name "${option}")
			print "Switching to board: ${config}"
			if [ ! -f "${config}" ]; then
				exit_with_error "Invalid board: ${option}"
			fi
		fi
		DEVICE_MAKEFILE="${config}"
		export DEVICE_MAKEFILE

		ln -f "${DEVICE_MAKEFILE}" "${SCRIPT_DIR}"/vicharak/.device.mk
		source "${SCRIPT_DIR}"/.device.mk

		print_info
		;;
	lunch|-l) lunch_device ;;
	info|-i) print_info ;;
	clean|-c) cleanup ;;
	kernel|-k) check_lunch_device; build_kernel ;;
	dtbs|-d)
		if ! is_set "${DEVICE_ARCH}"; then
			exit_with_error "Device architecture not set!"
		fi
		if [ "${DEVICE_ARCH}" == "arm64" ]; then
			build_dtbs
		else
			exit_with_error "DTB build not supported for ${DEVICE_ARCH}"
		fi
		;;
	kerneldeb|-K) build_kerneldeb ;;
	update_defconfig|-u) update_defconfig ;;
	*)
		usage
		exit_with_error "Invalid option: ${option}"
		;;
	esac
done
