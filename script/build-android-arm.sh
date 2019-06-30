#!/bin/bash


# 设置编译中临时文件目录，不然会报错 unable to create temporary file
export TMPDIR=F:/FFmpeg/temp
mkdir $TMPDIR

# NDK的路径，根据实际安装位置设置
NDK=F:/ndk/android-ndk-r14b

# 编译针对的平台，这里选择最低支持android-23, arm架构，生成的so库是放在libs/armeabi文件夹下的，若针对x86架构，要选择arch-x86
SYSROOT=$NDK/platforms/android-14/arch-arm

# 工具链的路径，arm-linux-androideabi-4.9与上面设置的PLATFORM对应，4.9为工具的版本号
TOOLCHAIN=$NDK/toolchains/arm-linux-androideabi-4.9/prebuilt/windows-x86_64

ARCH=arm

PREFIX=F:/FFmpeg/output/$ARCH
#-D__ANDROID_API__=23 
EXTRA_CFLAGS="-fdata-sections -ffunction-sections -fstack-protector-strong -ffast-math -fstrict-aliasing -marm -march=armv6 -isystem $NDK/sysroot/usr/include -isystem $NDK/sysroot/usr/include/arm-linux-androideabi"

EXTRA_LDFLAGS="-Wl,--gc-sections -Wl,-z,relro -Wl,-z,now"

function build_one
{
./configure \
--prefix=$PREFIX \
--disable-static \
--enable-shared \
--enable-small \
--enable-runtime-cpudetect \
--disable-programs \
--disable-ffmpeg \
--disable-ffplay \
--disable-ffprobe \
--disable-ffserver \
--disable-doc \
--enable-pthreads \
--disable-decoders \
--enable-decoder=h264_mediacodec \
--disable-encoders \
--disable-hwaccels \
--enable-hwaccel=h264_mediacodec \
--disable-parsers \
--enable-parser=h264 \
--disable-demuxers \
--disable-muxers \
--disable-protocols \
--disable-filters \
--disable-bsfs \
--disable-indevs \
--disable-outdevs \
--disable-v4l2_m2m \
--enable-jni \
--enable-mediacodec \
--arch=$ARCH \
--cross-prefix=$TOOLCHAIN/bin/arm-linux-androideabi- \
--enable-cross-compile \
--sysroot=$SYSROOT \
--target-os=android \
--disable-symver \
--enable-asm \
--enable-neon \
--extra-cflags="$EXTRA_CFLAGS" \
--extra-ldflags="$EXTRA_LDFLAGS" \
$ADDITIONAL_CONFIGURE_FLAG
}

build_one

make clean
make -j8
make install