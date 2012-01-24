#!/bin/sh
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
libname="libtheora-${libver}"

libdir="${libname}"
libtar="${libname}.tar.bz2"
liburl="http://downloads.xiph.org/releases/theora/${libtar}"

if [ ! -d "${libdir}" ]
then
	if [ ! -e "${libtar}" ]
	then
	  curl -O "${liburl}"
	fi

	tar zxvf "${libtar}"
fi

cd $libdir

if [ -e "Makefile" ]
then
	make clean
fi

./configure --host=${HOSTARCH}-appale-darwin --prefix=${ROOTDIR} --disable-shared --enable-static --disable-spec --disable-oggtest --disable-vorbistest --disable-examples
#  --enable-valgrind-testing     enable running of tests inside Valgrind
#  --disable-asm           disable assembly optimizations
#  --disable-sdltest       Do not try to compile and run a test SDL program
#  --enable-telemetry      enable debugging output controls
#  --disable-float         disable use of floating point code
#  --disable-encode        disable encoding support
    
make
make install --ignore-errors  # Ignore errors due to share libraries missing

