#!/bin/sh
# Cross-compile environment for Android on ARMv7
#
# This script assumes the Android NDK and the OpenSSL FIPS
# tarballs have been unpacked in the same directory

#android-sdk-linux/platforms Edit this to wherever you unpacked the NDK

for NDK in "android-ndk-r8b" "android-ndk-r8c" "android-ndk-r9c" "android-ndk-r9d"
do
  if [ -d $NDK ]; then
    export ANDROID_NDK=$PWD/$NDK
  fi
done

# Edit to reference the incore script (usually in ./util/)
export FIPS_SIG=$PWD/openssl-fips-2.0.7/util/incore

for i in linux darwin
do
  ARCH="$(echo $ANDROID_NDK/prebuilt/$i-x86* | sed "s:$ANDROID_NDK/prebuilt/$i-::")"
  if [ -d $ANDROID_NDK/toolchains/x86-4.8/prebuilt/$i-$ARCH/bin ]; then
    PATH=$ANDROID_NDK/toolchains/x86-4.8/prebuilt/$i-$ARCH/bin:$PATH
    break;
  fi
done

export PATH

#
# Shouldn't need to edit anything past here.
#

export MACHINE=i686
export RELEASE=2.6.37
export SYSTEM=android
export ARCH=x86
export CROSS_COMPILE="i686-linux-android-"
export ANDROID_DEV="$ANDROID_NDK/platforms/android-9/arch-x86/usr"
export HOSTCC=gcc


