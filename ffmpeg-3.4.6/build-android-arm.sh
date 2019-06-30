#!/bin/bash


# ���ñ�������ʱ�ļ�Ŀ¼����Ȼ�ᱨ�� unable to create temporary file
export TMPDIR=F:/FFmpeg/temp
mkdir $TMPDIR

# NDK��·��������ʵ�ʰ�װλ������
NDK=F:/ndk/android-ndk-r14b

# ������Ե�ƽ̨������ѡ�����֧��android-23, arm�ܹ������ɵ�so���Ƿ���libs/armeabi�ļ����µģ������x86�ܹ���Ҫѡ��arch-x86
SYSROOT=$NDK/platforms/android-14/arch-arm

# ��������·����arm-linux-androideabi-4.9���������õ�PLATFORM��Ӧ��4.9Ϊ���ߵİ汾��
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