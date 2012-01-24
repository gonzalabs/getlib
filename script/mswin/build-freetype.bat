
set project=freetype
:: set config="%configure_str%|%platform_str%"

if "%toolset%"=="msvc-8.0" (
	set keydir=vc2005
	set config="LIB %configure_str%|%platform_str%"
) else if "%toolset%"=="msvc-9.0" (
	set keydir=vc2008
	set config="LIB %configure_str%|%platform_str%"
) else if "%toolset%"=="msvc-10.0" (
	set keydir=vc2010
	set config="%configure_str%|%platform_str%"
)  else if "%toolset%"=="msvc-11.0" (
	set keydir=vc2012
	set config="%configure_str%|%platform_str%"
)

set solution=builds\win32\%keydir%\freetype.sln

echo . solution='%solution%' project='%project%' config=%config%
%compiler% %solution% /%command% %config% /project "%project%" /out %liblog% 
goto %command%

:build
:rebuild
	:: lib
	echo . copy lib files:
	if "%variant%"=="debug" (
		copy objs\win32\%keydir%\freetype248_D.lib "%target-lib%\freetype2.lib"
	) else (
		copy objs\win32\%keydir%\freetype248.lib "%target-lib%\freetype2.lib"
	)
	
	:: include
	echo . copy include files:
	xcopy include\* "%target-include%" /Q /S /Y
	
	goto end

:clean
	goto end

:end