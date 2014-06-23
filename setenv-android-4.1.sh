#!/bin/sh
# Cross-compile environment for Android on ARMv7
#
# This script assumes the Android NDK and the OpenSSL FIPS
# tarballs have been unpacked in the same directory

#android-sdk-linux/platforms Edit this to wherever you unpacked the NDK
function environment_setup {
	if [ -d android-ndk-r9d ]; then
	  export ANDROID_NDK=$PWD/android-ndk-r9d
	fi

	# Edit to reference the incore script (usually in ./util/)
	export FIPS_SIG=$PWD/openssl-fips-2.0.5/util/incore

	#
	# Shouldn't need to edit anything past here.
	#

	export RELEASE=2.6.37
	export SYSTEM=android
	export HOSTCC=gcc

	TOOLCHAIN=4.6
	ANDROID_ABI=android-9 # Minimum supported version for x86
			      # check the NDK platform folder for supported versions.

	local OPTIND
	while getopts "a:t:x:" opt; do
		case $opt in
		a)
			echo "Using ARCH $OPTARG" >&2
			ARG_ARCH=$OPTARG
			;;

		t)
			echo "Using TOOLCHAIN $OPTARG" >&2
			TOOLCHAIN=$OPTARG
			;;

		x)
			echo "Using ANDROID_ABI $OPTARG" >&2
			ANDROID_ABI=$OPTARG
			;;

		\?)
			echo "Invalid option: -$OPTARG" >&2
			;;
		esac
	done
	shift $((OPTIND-1))

	if [ "x86" = "$ARG_ARCH" ]; then
		export CROSS_COMPILE="i686-linux-android-"
		export CROSS_PREFIX="x86-"
		export ARCH="x86"
		export MACHINE="i686"
		export ARCH_ABI="x86"
	elif [ "arm" = "$ARG_ARCH" ]; then
		export CROSS_COMPILE="arm-linux-androideabi-"
		export CROSS_PREFIX=$CROSS_COMPILE
		export ARCH="arm"
		export MACHINE="armv7l"
		export ARCH_ABI="armeabi"
	elif [ "arm-v7a" = "$ARG_ARCH" ]; then
		export CROSS_COMPILE="arm-linux-androideabi-"
		export CROSS_PREFIX=$CROSS_COMPILE
		export ARCH="arm"
		export MACHINE="armv7a"
		export ARCH_ABI="armeabi-v7a"
	else
		echo "Invalid ARCH=$ARG_ARCH"
		exit 1
	fi
	export ANDROID_DEV=$(readlink -f "$ANDROID_NDK/platforms/$ANDROID_ABI/arch-$ARCH/usr")
	export CC=$CROSS_COMPILEgcc
	export CXX=$CROSS_COMPILEg++
	export LD=$CROSS_COMPILEld
	export AR=$CROSS_COMPILEar
	export RANLIB=$CROSS_COMPILEranlib
	export STRIP=$CROSS_COMPILEstrip

	HOST_ARCH=`uname -m`
	for i in linux darwin
	do
	  TOOL_ORG="$ANDROID_NDK/toolchains/$CROSS_PREFIX$TOOLCHAIN/prebuilt/$i-$HOST_ARCH/bin/"
	  TOOL=$(readlink -f "$TOOL_ORG")
	  if [ -d $TOOL ]; then
		export PATH=$TOOL:$PATH
	  fi
	done
}
