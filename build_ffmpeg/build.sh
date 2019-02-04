#!/bin/bash

NDK=${ANDROID_NDK}
PREFIX=$(pwd)/../smoothrescale/src/main/jni/ffmpeg
TOOLCHAIN_STANDALONE_BASE=$(pwd)/toolchain

function build_one
{
TOOLCHAIN_DIR=${TOOLCHAIN_STANDALONE_BASE}/${TOOLCHAIN}-${TOOLCHAIN_VERSION}
TOOLCHAIN_PREFIX=${TOOLCHAIN_DIR}/bin/${TOOLCHAIN_EXEC}-
SYSROOT=${TOOLCHAIN_DIR}/sysroot

# Create standalone toolchain
${NDK}/build/tools/make-standalone-toolchain.sh \
    --platform=android-${PLATFORM} \
    --toolchain=${TOOLCHAIN}-${TOOLCHAIN_VERSION} \
    --install-dir=${TOOLCHAIN_DIR} \
    --stl=stlport \
    --force

cd ffmpeg

rm compat/strtod.o
rm compat/strtod.d

./configure\
    --prefix=${PREFIX}/${OUT}\
    --disable-everything\
    --disable-all\
    --disable-static\
    --enable-shared\
    --enable-avutil\
    --enable-swscale\
    --cross-prefix=${TOOLCHAIN_PREFIX}\
    --target-os=android\
    --arch=${ARCH}\
    --enable-cross-compile\
    --yasmexe=${TOOLCHAIN_DIR}/bin/yasm \
    --sysroot=${SYSROOT}\
    --extra-cflags="-I${SYSROOT}/usr/include -Os ${ADDI_CFLAGS}"\
    --extra-cxxflags="-I${SYSROOT}/usr/include ${ADDI_CXXFLAGS}"\
    --extra-ldflags="-L${SYSROOT}/usr/lib ${ADDI_LDFLAGS}"\
    ${ADDITIONAL_CONFIGURE_FLAG}

make clean
make -j24
make install

cd ../
}

