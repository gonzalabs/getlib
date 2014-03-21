#!/bin/bash
set -e

# script: external libraries build script
# author: gonzale$$
#
# based on the following scripts:
#   build-all.sh			by Pierre-Olivier Latour
#   http://code.google.com/p/ios-static-libraries/
#
#   build_dependencies.sh	by Ângelo Suzuki
#   http://tinsuke.wordpress.com/2011/02/17/how-to-cross-compiling-libraries-for-ios-armv6armv7i386/
#
#   build_for_iphoneos.sh   by Christopher J. Stawarz
#   http://pseudogreen.org/blog/build_autoconfed_libs_for_iphone.html
#
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


OPTION_SDK_VERSION="7.1"
OPTION_IOS_VERSION_MIN="7.0"
#OPTION_PLATFORMS="iPhoneSimulator-i386 iPhoneOS-armv6 iPhoneOS-armv7"
OPTION_PLATFORMS="iPhoneSimulator-i386"

OPTION_LIBSRC_LOCATION="`pwd`/../../libs"
OPTION_OUTDIR_LOCATION="`pwd`/../../build"
OPTION_DEVDIR_LOCATION="`xcode-select --print-path`"

OPTION_OUTPUT_PLATFORMS=${OPTION_OUTDIR_LOCATION}/Platforms
OPTION_DEVDIR_PLATFORMS=${OPTION_DEVDIR_LOCATION}/Platforms

OPTION_LOG_SEPARATEFILE="yes"
OPTION_CLEAN_OUTPUT=0


SCRIPT_DIR=`pwd`
COL_HEADER1="\x1b[32;01m"
COL_HEADER2="\x1b[31;01m"
COL_HEADER3="\x1b[33;01m"
COL_STYLE_W="\x1b[36;01m"
COL_STYLE_R="\x1b[36;01m"
COL_STYLE_B="\x1b[36;01m"
COL_ERR_MSG="\x1b[31;01m"
COL_RESET="\x1b[39;49;00m"


logcfg_general()
{
	echo -e $COL_HEADER1"GENERAL CONFIG:"$COL_RESET" SDK ${OPTION_SDK_VERSION}"
	echo "     xcode sdk platforms: $OPTION_DEVDIR_PLATFORMS"
	echo "    output platforms dir: $OPTION_OUTPUT_PLATFORMS"
	echo "    libraries source dir: $OPTION_LIBSRC_LOCATION"
	echo -e $COL_STYLE_B"available SDKs:"$COL_RESET
	xcodebuild -showsdks
	echo -e $COL_STYLE_B"demanded platforms:"$COL_RESET
	echo "    $OPTION_PLATFORMS"
}

default_config()
{
	IOSVERMIN=${OPTION_IOS_VERSION_MIN}

	# default parameters
#	export    CPP="${DEVROOT}/Toolchains/XcodeDefault.xctoolchain/usr/bin/cpp"
#	export CXXCPP="${CPP}"
	export     CC="${DEVROOT}/usr/bin/gcc"
	export    CXX="${DEVROOT}/usr/bin/g++"
	export     LD="${DEVROOT}/usr/bin/ld"
	unset AR
	unset AS
	#export AR="${BUILD_DEVROOT}/usr/bin/ar"
	#export AS="${BUILD_DEVROOT}/usr/bin/as"
	export NM="${TOOLCHAINDIR}/usr/bin/nm"
	export STRIP="${TOOLCHAINDIR}/usr/bin/strip"
	export RANLIB="${TOOLCHAINDIR}/usr/bin/ranlib"

    export CPPFLAGS="-I${ROOTDIR}/include -I${SDKROOT}/usr/include -I${DEVROOT}/usr/include"
    export CXXCPPFLAGS=$CPPFLAGS
	export   CFLAGS="-arch ${HOSTARCH} -pipe -no-cpp-precomp -miphoneos-version-min=${IOSVERMIN} -isysroot ${SDKROOT} ${CPPFLAGS}"
	export CXXFLAGS=$CFLAGS
	export  LDFLAGS="-arch ${HOSTARCH} -pipe -no-cpp-precomp -miphoneos-version-min=${IOSVERMIN} -isysroot ${SDKROOT} -L${ROOTDIR}/lib -L${SDKROOT}/usr/lib -L${DEVROOT}/usr/lib"
}

create_output_rootdir()
{
	echo -e $COL_STYLE_B"creating output directories"$COL_RESET" at $OPTION_OUTPUT_PLATFORMS"

	if [ $OPTION_CLEAN_OUTPUT != 0 ]
	then
		rm -rf $OPTION_OUTPUT_PLATFORMS
	fi

	mkdir -p $OPTION_OUTPUT_PLATFORMS
	
	echo -e $COL_STYLE_B"output directories created"$COL_RESET
}

build_library()
{
	libname=$1
	version=$2
	builder=${SCRIPT_DIR}/build-${libname}.sh
	
	default_config
	
	echo -e $COL_HEADER3"LIBRARY: "$COL_STYLE_R"${libname} v${version}"$COL_RESET" for "$COL_STYLE_R"${PLATFORM}-${HOSTARCH}"$COL_RESET
	cd "${LIBROOT}"
	
	if [ "$OPTION_LOG_SEPARATEFILE" = "yes" ]
	then
		${builder} ${version} > "${ROOTDIR}/${libname}.log"
	else
		${builder} ${version}
	fi
	
	echo -e $COL_HEADER3"LIBRARY "$COL_STYLE_R"${libname} v${version}"$COL_RESET" for "$COL_STYLE_R"${PLATFORM}-${HOSTARCH}"$COL_HEADER3" - build complete"$COL_RESET
}

build_all_platforms()
{
	for PLATFORM_FULL_NAME in ${OPTION_PLATFORMS}
	do
		# configure
		PLATFORM=${PLATFORM_FULL_NAME%%-*}
		HOSTARCH=${PLATFORM_FULL_NAME##*-}
		
		export PLATFORM="${PLATFORM}"
		export HOSTARCH="${HOSTARCH}"
		export SDK="${OPTION_SDK_VERSION}"

		export PLATFORMDIR="${OPTION_DEVDIR_PLATFORMS}/${PLATFORM}.platform"
        export TOOLCHAINDIR="${OPTION_DEVDIR_LOCATION}/Toolchains/XcodeDefault.xctoolchain"

		export DEVROOT="${PLATFORMDIR}/Developer"
		export SDKROOT="${DEVROOT}/SDKs/${PLATFORM}${SDK}.sdk"
		export ROOTDIR="${OPTION_OUTPUT_PLATFORMS}/${PLATFORM}${SDK}-${HOSTARCH}"
		export LIBROOT="${OPTION_LIBSRC_LOCATION}"

		# log config		
		echo -e $COL_HEADER2"BUILD FOR PLATFORM: "$COL_STYLE_R"$PLATFORM_FULL_NAME"$COL_RESET
		echo "    base platform name: $PLATFORM"
		echo "     host architecture: $HOSTARCH"
		echo "     platform SDK root: $SDKROOT"
		echo "       output root dir: $ROOTDIR"

		# check dirs
		if [ ! -d "$PLATFORMDIR" ]
		then
			echo -e $COL_ERR_MSG"ERROR: Platform dir does not exist: "$COL_RESET"${PLATFORMDIR}"
			exit
		fi

		if [ ! -d "$SDKROOT" ]
		then
			echo -e $COL_ERR_MSG"ERROR: platform SDK dir does not exist: "$COL_RESET"${SDKROOT}"
			exit
		fi

		# create dirs
		mkdir -p $ROOTDIR
		mkdir -p $LIBROOT

		# libraries
#		build_library "expat" "2.0.1"
		build_library "zlib" "1.2.8"
		build_library "libpng" "1.6.10"
#		build_library "jpeg" "9a"
#		build_library "freetype" "2.5.3"

		#build_library "libogg" "1.3.0"
		#build_library "libvorbis" "1.3.2"
		#build_library "libtheora" "1.1.1"
	done
}


####################################################################################################
# MAIN SCRIPT SEQUENCE
####################################################################################################
echo -e $COL_HEADER1"GSL EXTERNAL LIBS CROSSCOMPILING SCRIPT"$COL_RESET


logcfg_general
create_output_rootdir
build_all_platforms


echo -e $COL_HEADER1"SCRIPT FINISHED"$COL_RESET
cd $SCRIPT_DIR
####################################################################################################
