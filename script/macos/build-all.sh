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


# build configuration
OPTION_PLATFORMS=$1
OPTION_SDKVER="${2%%-*}"
OPTION_SDKVERMIN="${2##*:}"
OPTION_XCOMPILE=$([ "$3" == "cross" ] && echo "1" || echo "0")

# source/output files locations
OPTION_LIBSRC_LOCATION="`pwd`/../../libs"
OPTION_OUTDIR_LOCATION="`pwd`/../../build"

# build options
OPTION_LOG_SEPARATEFILE="yes"
OPTION_CLEAN_OUTPUT=0


# current dir
SCRIPT_DIR=`pwd`


# text styles
COL_HEADER1="\x1b[32;01m"
COL_HEADER2="\x1b[31;01m"
COL_HEADER3="\x1b[33;01m"
COL_STYLE_W="\x1b[36;01m"
COL_STYLE_R="\x1b[36;01m"
COL_STYLE_B="\x1b[36;01m"
COL_ERR_MSG="\x1b[31;01m"
COL_RESET="\x1b[39;49;00m"


print_help()
{
	echo "build-all usage:"
	echo "	build-all.sh <list of target platforms> [sdkver-sdkvermin] [cross]"
}

print_base_config()
{
	echo -e $COL_HEADER1"COMMON CONFIG:"$COL_RESET
	echo "     xcode developer dir: `xcode-select --print-path`"
	echo "    libraries source dir: $OPTION_LIBSRC_LOCATION"
	echo "    output platforms dir: $OPTION_OUTDIR_LOCATION"
	echo -e $COL_STYLE_B"available SDKs:"$COL_RESET
	xcodebuild -showsdks
	echo -e $COL_STYLE_B"demanded platforms:"$COL_RESET
	echo "    $OPTION_PLATFORMS"
}

create_output_rootdir()
{
	echo -e $COL_STYLE_B"creating output directories"$COL_RESET" at $OPTION_OUTDIR_LOCATION"

	if [ $OPTION_CLEAN_OUTPUT != 0 ]
	then
		rm -rf $OPTION_OUTDIR_LOCATION
	fi

	mkdir -p $OPTION_OUTDIR_LOCATION

	echo -e $COL_STYLE_B"output directories created"$COL_RESET
}

reset_config()
{
    # there are not separate C/C++ preprocessors
	unset CPP
	unset CXXCPP

	# toolchain parts
	export     CC="${TOOLCC}"
	export    CXX="${TOOLCXX}"
	export     LD="${TOOLLD}"
	export     AR="${TOOLAR}"
	export     AS="${TOOLAS}"
	export     NM="${TOOLNM}"
	export  STRIP="${TOOLSTRIP}"
	export RANLIB="${TOOLRANLIB}"

	# -target ${CFGHOST}
	SHARED_FLAGS="-pipe -isysroot ${SDKROOT}"
	
	if [ $OPTION_XCOMPILE ] 
	then
		SHARED_FLAGS+=" -target ${HOSTARCH}-apple-darwin"
	else
		SHARED_FLAGS+=" -arch ${HOSTARCH}"
	fi
	
	if [ "${SDKVERMIN}" != "" ] 
	then
		SHARED_FLAGS+=" -m${PLATFORM}-version-min=${SDKVERMIN}"
	fi

    export CPPFLAGS="${SHARED_FLAGS} -I${OUTDIR}/include"	# c/c++ preprocessor	-I${SDKROOT}/usr/include
	export   CFLAGS=$CPPFLAGS								# c compiler
	export CXXFLAGS=$CFLAGS									# c++ compiler
	export  LDFLAGS="${SHARED_FLAGS} -L${OUTDIR}/lib"		# linker				-L${SDKROOT}/usr/lib
}

build_library()
{
	libname=$1
	version=$2
	builder=${SCRIPT_DIR}/build-${libname}.sh
	
	reset_config
	
	echo -e $COL_HEADER3"LIBRARY: "$COL_STYLE_R"${libname} v${version}"$COL_RESET" for "$COL_STYLE_R"${PLATFORM}-${HOSTARCH}"$COL_RESET
	cd "${LIBSRC}"
	
	if [ "$OPTION_LOG_SEPARATEFILE" = "yes" ]
	then
		${builder} ${version} > "${OUTDIR}/${libname}.log"
	else
		${builder} ${version}
	fi
	
	echo -e $COL_HEADER3"LIBRARY "$COL_STYLE_R"${libname} v${version}"$COL_RESET" for "$COL_STYLE_R"${PLATFORM}-${HOSTARCH}"$COL_HEADER3" - build complete"$COL_RESET
}

build_all_platforms()
{
	for PLATFORM_FULL_NAME in ${OPTION_PLATFORMS}
	do
		# exptract host platform and architecture
		PLATFORM=${PLATFORM_FULL_NAME%%-*}
		HOSTARCH=${PLATFORM_FULL_NAME##*-}

		# configure environment
		export   PLATFORM="${PLATFORM}"
		export   HOSTARCH="${HOSTARCH}"
		export   XCOMPILE=$CONFIGURE_OPTIONS

		export     SDKVER="$OPTION_SDKVER"
		export  SDKVERMIN="$OPTION_SDKVERMIN"

		export    SDKROOT="`xcrun --sdk ${PLATFORM}${SDKVER} -show-sdk-path`"

		export    TOOLCPP=`xcrun --find --sdk ${PLATFORM}${SDKVER} cpp`
		export     TOOLCC=`xcrun --find --sdk ${PLATFORM}${SDKVER} clang`
		export    TOOLCXX=`xcrun --find --sdk ${PLATFORM}${SDKVER} clang++`
		export     TOOLLD=`xcrun --find --sdk ${PLATFORM}${SDKVER} ld`
		export     TOOLAR=`xcrun --find --sdk ${PLATFORM}${SDKVER} ar`
		export     TOOLAS=`xcrun --find --sdk ${PLATFORM}${SDKVER} as`
		export     TOOLNM=`xcrun --find --sdk ${PLATFORM}${SDKVER} nm`
		export  TOOLSTRIP=`xcrun --find --sdk ${PLATFORM}${SDKVER} strip`
		export TOOLRANLIB=`xcrun --find --sdk ${PLATFORM}${SDKVER} ranlib`

		export     OUTDIR="${OPTION_OUTDIR_LOCATION}/${PLATFORM}${SDKVER}-${HOSTARCH}"
		export     LIBSRC="${OPTION_LIBSRC_LOCATION}"

		export    CFGHOST="${HOSTARCH}-apple-darwin"
		export    CFGPRFX="${OUTDIR}"

		# log config
		echo -e $COL_HEADER2"BUILD FOR PLATFORM: "$COL_STYLE_R"$PLATFORM_FULL_NAME"$COL_RESET
		echo "    base platform name: $PLATFORM"
		echo "     host architecture: $HOSTARCH"
		echo "     host type spcfctn: $CFGHOST"
		echo "     platform SDK vers: $SDKVER-$SDKVERMIN"
		echo "     platform SDK root: $SDKROOT"
		echo "          sdk tool cpp: $TOOLCPP"
		echo "          sdk tool  cc: $TOOLCC"
		echo "          sdk tool cxx: $TOOLCXX"
		echo "          sdk tool  ld: $TOOLLD"
		echo "       output root dir: $OUTDIR"

		# check sdk root
		if [ ! -d "$SDKROOT" ]
		then
			echo -e $COL_ERR_MSG"ERROR: platform SDK dir does not exist: "$COL_RESET"${SDKROOT}"
			exit
		fi

		# create out dirs
		mkdir -p $OUTDIR
		mkdir -p $LIBSRC

		# libraries
#		build_library "expat" "2.0.1"
#		build_library "zlib" "1.2.8"
#		build_library "libpng" "1.6.10"
#		build_library "jpeg" "9a"

		build_library "freetype" "2.5.5"

		#build_library "libogg" "1.3.0"
		#build_library "libvorbis" "1.3.2"
		#build_library "libtheora" "1.1.1"
	done
}


####################################################################################################
# COMMAND LINE PARAMS VALIDATION
####################################################################################################
if [ "$OPTION_PLATFORMS" == "" ]
then
	echo "error: target platforms list is missing"
	print_help
	exit 0
fi


####################################################################################################
# MAIN SCRIPT SEQUENCE
####################################################################################################
echo -e $COL_HEADER1"GSL EXTERNAL LIBS CROSSCOMPILING SCRIPT"$COL_RESET


print_base_config
create_output_rootdir
build_all_platforms


echo -e $COL_HEADER1"SCRIPT FINISHED"$COL_RESET
cd $SCRIPT_DIR
####################################################################################################
