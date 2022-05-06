#!/bin/sh

if [[ $CONFIGURATION != "Release" ]]; then
    echo "Not Release."
    exit 0
fi

scripts="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

cd "${scripts}/SchnauzerLibrary/"
mkdir -p "${TARGETNAME}"
cd "${TARGETNAME}"
rm -rf *

# iOS
snz_iphoneos_build="${BUILD_DIR}/${CONFIGURATION}-iphoneos"
snz_iphonesimulator_build="${BUILD_DIR}/${CONFIGURATION}-iphonesimulator"

snz_iphoneos_library="${snz_iphoneos_build}"/lib"${TARGETNAME}".a
snz_iphonesimulator_library="${snz_iphonesimulator_build}"/lib"${TARGETNAME}".a
snz_universal_library=ios/lib"${TARGETNAME}".a

cp "${snz_iphoneos_build}/${TARGETNAME}"/* . 2>/dev/null

if [ -f "${snz_iphoneos_library}" ] && [ -f "${snz_iphonesimulator_library}" ] ; then
    mkdir ios
    lipo -create "${snz_iphoneos_library}" "${snz_iphonesimulator_library}" -output "${snz_universal_library}"
    libtool -static -D "${snz_universal_library}" -o "${snz_universal_library}" 2> /dev/null
fi

# macOS
snz_macos_build="${BUILD_DIR}/${CONFIGURATION}"
snz_macos_library="${snz_macos_build}"/lib"${TARGETNAME}".a
snz_universal_library=macos/lib"${TARGETNAME}".a

if [ -f "${snz_macos_library}" ] ; then
    mkdir macos
    cp "${snz_macos_library}" "${snz_universal_library}"
fi
