#!/bin/bash
#NDK=$HOME/Desktop/adt/android-ndk-r9
NDK=$ANDROID_NDK
SYSROOT=$NDK/platforms/android-23/arch-arm/
TOOLCHAIN=$NDK/toolchains/arm-linux-androideabi-4.9/prebuilt/darwin-x86_64
function build_one
{
./configure\
    --prefix=$PREFIX\
    --enable-shared\
    --disable-static\
    --disable-doc\
    --disable-ffmpeg\
    --disable-ffplay\
    --disable-ffprobe\
    --disable-ffserver\
    --disable-avdevice\
    --disable-doc\
    --disable-symver\
    --disable-avcodec\
    --disable-avdevice\
    --disable-avfilter\
    --disable-avformat\
    --disable-postproc\
    --disable-swresample\
    --cross-prefix=$TOOLCHAIN/bin/arm-linux-androideabi-\
    --target-os=linux\
    --arch=arm\
    --enable-cross-compile\
    --sysroot=$SYSROOT\
    --extra-cflags="-Os -fpic $ADDI_CFLAGS"\
    --extra-ldflags="$ADDI_LDFLAGS"\
    $ADDITIONAL_CONFIGURE_FLAG

make clean
make
make install
}
CPU=arm
PREFIX=$(pwd)/build/android/$CPU
ADDI_CFLAGS="-marm"
cd ffmpeg
build_one