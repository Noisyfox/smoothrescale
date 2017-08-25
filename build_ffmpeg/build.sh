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

