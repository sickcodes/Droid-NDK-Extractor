#!/bin/bash
# Author:       sickcodes
# Contact:      https://twitter.com/sickcodes
# Repo:         https://github.com/sickcodes/Droid-NDK-Extractor
# Copyright:    sickcodes (C) 2021
# License:      GPLv3+

ARCH="${1}"
ARCH="${ARCH:="x86_64"}"

mkdir ./working

cd ./working

git clone https://gitlab.com/android-generic/android_vendor_google_emu-x86.git

yes | ./android_vendor_google_emu-x86/download-files.sh "${ARCH}"

yes | unzip "${ARCH}-*-linux.zip"

7z e x86_64/system.img

binwalk -e \
    --depth 1 \
    --count 1 \
    -y 'filesystem' \
    super.img # only search for filesystem signatures

# 1048576       0x100000        \
# Linux EXT filesystem, blocks count: 234701, \
# image size: 240333824, rev 1.0, ext2 filesystem data, \
# UUID=31e7cd0f-5577-515b-bea5-c836952b952b, volume name "/"

mkdir extracted
cd extracted

yes | 7z x ../_super.img.extracted/100000.ext

find system \( -name 'libndk_translation*' -o -name '*arm*' -o -name 'ndk_translation*' \) | tar -cf native-bridge.tar -T -

pwd

stat native-bridge.tar || exit 1

mv native-bridge.tar ..

rm -rf ./working

stat native-bridge.tar || exit 1

echo "${PWD}/native-bridge.tar"

# move native-bridge.tar somewhere, and remove the ./working folder as it is no longer required.
