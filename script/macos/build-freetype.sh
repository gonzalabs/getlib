#!/bin/bash
set -e


# Permission is hereby granted, free of charge, to any person
# obtaining a copy of this software and associated documentation files
# (the "Software"), to deal in the Software without restriction,
# including without limitation the rights to use, copy, modify, merge,
# publish, distribute, sublicense, and/or sell copies of the Software,
# and to permit persons to whom the Software is furnished to do so,
# subject to the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT.  IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
# BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
# ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
# CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

libver=$1
libname="freetype-${libver}"
libdir="${libname}"
libtar="${libname}.tar.gz"

liburl="http://download.savannah.gnu.org/releases/freetype/${libtar}"


if [ ! -d "${libdir}" ]
then
	if [ ! -e "${libtar}" ]
	then
	  curl -O "${liburl}"
	fi

	tar zxvf "${libtar}"
fi

cd $libdir

if [ -e "Makefile" ]						# Makefile stub exists before ./configure has been run
then
	obj_count=$(ls ./objs/*.o | wc -l)		# count object files
	obj_count=${obj_count//[[:space:]]}		# trim spaces from the variable
	
	if [ "$obj_count" != "0" ]
	then
		make clean
	fi
fi

echo "CONFIGURE..."
./configure --prefix=${CFGPRFX} --host=${CFGHOST} --with-sysroot=${SDKROOT} --disable-shared --enable-static --without-bzip2 --without-harfbuzz --without-png --without-zlib
echo "MAKE..."
make
echo "MAKE INSTALL..."
make install

if [ 0 != 0 ]
then
--host=${CFGHOST}
--host=i686-apple-darwin10
	#building freetytpe for iphone
	# for iPhone
	./configure --prefix=/usr/local/iphone --host=arm-apple-darwin --enable-static=yes --enable-shared=no
	CC=/Developer/Platforms/iPhoneOS.platform/Developer/usr/bin/arm-apple-darwin9-gcc-4.0.1
	CFLAGS="-arch armv6 -pipe -mdynamic-no-pic -std=c99 -Wno-trigraphs -fpascal-strings -fasm-blocks -O0 -Wreturn-type -Wunused-variable -fmessage-length=0 -fvisibility=hidden -miphoneos-version-min=2.0 -gdwarf-2 -mthumb -I/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS2.0.sdk/usr/include/libxml2 -isysroot /Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS2.0.sdk"
	CPP=/Developer/Platforms/iPhoneOS.platform/Developer/usr/bin/cpp AR=/Developer/Platforms/iPhoneOS.platform/Developer/usr/bin/ar
	LDFLAGS="-arch armv6 -isysroot /Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS2.0.sdk -Wl,-dead_strip -miphoneos-version-min=2.0"

	# for iPhone simulator
	./configure --prefix=/usr/local/iphone --enable-static=yes --enable-shared=no
	CC=/Developer/Platforms/iPhoneSimulator.platform/Developer/usr/bin/gcc-4.0
	CFLAGS="-arch i686 -pipe -mdynamic-no-pic -std=c99 -Wno-trigraphs -fpascal-strings -fasm-blocks -O0 -Wreturn-type -Wunused-variable -fmessage-length=0 -fvisibility=hidden -mmacosx-version-min=10.5  -I/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator2.0.sdk/usr/include/ -isysroot /Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator2.0.sdk"
	CPP=/Developer/Platforms/iPhoneSimulator.platform/Developer/usr/bin/cpp AR=/Developer/Platforms/iPhoneSimulator.platform/Developer/usr/bin/ar
	LDFLAGS="-arch i686 -isysroot /Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator2.0.sdk -Wl,-dead_strip -mmacosx-version-min=10.5"
fi