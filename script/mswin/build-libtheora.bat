
set project=libtheora_static

if %variant%==release (
	set configure_libstr=%configure_str%_SSE2
) else (
	set configure_libstr=%configure_str%
)

set config="%configure_libstr%|%platform_str%"


if "%toolset%"=="msvc-8.0" (
	set keydir=VS2005
) else if "%toolset%"=="msvc-9.0" (
	set keydir=VS2008
) else if "%toolset%"=="msvc-10.0" (
	set keydir=VS2010
)  else if "%toolset%"=="msvc-11.0" (
	set keydir=VS2012
)

set solution=win32\%keydir%\libtheora_static.sln

echo . solution='%solution%' project='%project%' config=%config%
%compiler% %solution% /%command% %config% /project "%project%" /out %liblog% /useenv 
goto %command%

:build
:rebuild
	:: lib
	echo . copy lib files:
	copy win32\%keydir%\%platform_str%\%configure_libstr%\libtheora_static.lib "%target-lib%"
	
	:: include
	echo . copy include files:
	xcopy include\theora\* "%target-include%\theora\" /Q /Y /S
	
	goto end

:clean
	goto end

:end