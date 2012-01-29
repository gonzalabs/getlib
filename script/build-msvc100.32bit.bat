@echo off

set cdstore_top_level__=%CD%
set cdstore_build_dir__=%~dp0\mswin

:: configure
cd %~dp0\..
set logout=%CD%\logs
set output=%CD%\build
set source=%CD%\libs

set toolset=msvc-10.0
set msvc-express=yes
set address-model=32
set clean-output=yes

:: debug
cd %cdstore_build_dir__%
set variant=debug
call build-all.bat %*

:: release
cd %cdstore_build_dir__%
set variant=release
call build-all.bat %*

cd %cdstore_top_level__%
