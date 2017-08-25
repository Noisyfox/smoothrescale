#!/bin/bash

#NDK=$HOME/Desktop/adt/android-ndk-r9
NDK=${ANDROID_NDK}
PREFIX=$(pwd)/build/android

function build_one
{
cd ffmpeg

./configure\
    --prefix=${PREFIX}/${CPU}\
    --disable-everything\
    --disable-all\
    --disable-static\
    --disable-asm\
    --enable-shared\
    --enable-avutil\
    --enable-swscale\
    --cross-prefix=${TOOLCHAIN_PREFIX}\
    --target-os=linux\
    --arch=${ARCH}\
    --enable-cross-compile\
    --sysroot=${SYSROOT}\
    --extra-cflags="-Os -fpic ${ADDI_CFLAGS}"\
    --extra-ldflags="${ADDI_LDFLAGS}"\
    ${ADDITIONAL_CONFIGURE_FLAG}

make clean
make
make install

cd ../
}

CPU=arm
ARCH=arm
SYSROOT=$NDK/platforms/android-23/arch-${CPU}/
TOOLCHAIN=arm-linux-androideabi
TOOLCHAIN_EXEC=arm-linux-androideabi

HOST=darwin-x86_64
TOOLCHAIN_PREFIX=${NDK}/toolchains/${TOOLCHAIN}-4.9/prebuilt/${HOST}/bin/${TOOLCHAIN_EXEC}-
ADDI_CFLAGS="-marm"

build_one
