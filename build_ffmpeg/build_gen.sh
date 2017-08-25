#!/bin/bash

NDK=${ANDROID_NDK}
PREFIX=$(pwd)/../smoothrescale/src/main/jni/ffmpeg

function build_one
{
SYSROOT=$NDK/platforms/android-${PLATFORM}/arch-${CPU}/
TOOLCHAIN_PREFIX=${NDK}/toolchains/${TOOLCHAIN}-${TOOLCHAIN_VERSION}/prebuilt/${HOST}/bin/${TOOLCHAIN_EXEC}-

cd ffmpeg

rm compat/strtod.o
rm compat/strtod.d

./configure\
    --prefix=${PREFIX}/${OUT}\
    --disable-everything\
    --disable-all\
    --disable-yasm\
    --disable-static\
    --enable-shared\
    --enable-avutil\
    --enable-swscale\
    --cross-prefix=${TOOLCHAIN_PREFIX}\
    --target-os=android\
    --arch=${ARCH}\
    --enable-cross-compile\
    --sysroot=${SYSROOT}\
    --extra-cflags="-Os -fpic ${ADDI_CFLAGS}"\
    --extra-cxxflags="${ADDI_CXXFLAGS}"\
    --extra-ldflags="${ADDI_LDFLAGS}"\
    ${ADDITIONAL_CONFIGURE_FLAG}

make clean
make -j4
make install

cd ../
}

HOST=darwin-x86_64
TOOLCHAIN_VERSION=4.9
PLATFORM=23

OUT=armeabi-v7a
CPU=arm
ARCH=arm
TOOLCHAIN=arm-linux-androideabi
TOOLCHAIN_EXEC=arm-linux-androideabi
ADDI_CFLAGS=-marm
build_one

OUT=arm64-v8a
CPU=arm64
ARCH=aarch64
TOOLCHAIN=aarch64-linux-android
TOOLCHAIN_EXEC=aarch64-linux-android
ADDI_CFLAGS=
build_one

OUT=x86
CPU=x86
ARCH=x86
TOOLCHAIN=x86
TOOLCHAIN_EXEC=i686-linux-android
ADDI_CFLAGS=
build_one

OUT=x86_64
CPU=x86_64
ARCH=x86_64
TOOLCHAIN=x86_64
TOOLCHAIN_EXEC=x86_64-linux-android
ADDI_CFLAGS=
build_one

