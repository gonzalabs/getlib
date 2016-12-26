::
:: build libraries
::
	
::call "%buildlib%" CFG library-name library-version [library-directory]
:: CFG could be [dll, lib or all]
	
::call "%buildlib%" all bzip2 1.0.6
set debug_build=yes

if "%debug_build%"=="yes" (
	call "%buildlib%" lib zlib 1.2.8
) else (
	call "%buildlib%" lib expat 2.2.0
	call "%buildlib%" lib freetype 2.7.0

	call "%buildlib%" lib zlib 1.2.8
	call "%buildlib%" lib libpng 1.6.26 lpng-1.6.26
	call "%buildlib%" lib jpeg 9b

	call "%buildlib%" lib libogg 1.3.2
	call "%buildlib%" lib libvorbis 1.3.5
	call "%buildlib%" lib libtheora 1.1.1

	call "%buildlib%" lib bullet 2.85.1 bullet3-2.85.1
)


rem call "%buildlib%" lib fbxsdk 2014.1 "C:\Program Files\Autodesk\FBX\FBX SDK\2014.1"
	
