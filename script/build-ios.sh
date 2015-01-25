#!/bin/bash
set -e

pushd macos
# ./build-all.sh "macosx-i386 macosx-x86_64 iphonesimulator-i386 iphoneos-armv6 iphoneos-armv7"
./build-all.sh "iphonesimulator-i386 iphoneos-armv6 iphoneos-armv7" "8.1-8.1" "cross"
popd