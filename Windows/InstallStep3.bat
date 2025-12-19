@echo off

REM --- For Windows only ---
REM This script automates Step 3 of https://github.com/MrNeRF/LichtFeld-Studio/wiki/Build-Instructions-%E2%80%90-Windows
REM Manually perform Step 1 and Step 2, then place this script inside your repos folder and run it.
REM Important note: everything inside the directories "vcpkg" and "Lichtfeld-Studio" will be deleted!

if exist "LichtFeld-Studio" rmdir "LichtFeld-Studio" /S /Q
if exist "vcpkg" rmdir "vcpkg" /S /Q

call "C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\vcvarsall.bat" x64
echo Started x64 Visual Studio 2022 environment
cmake --version
nvcc --version
git --version
python --version

@echo on

git clone https://github.com/microsoft/vcpkg.git
cd vcpkg && call bootstrap-vcpkg.bat -disableMetrics && cd..

if exist "LichtFeld-Studio" rmdir "LichtFeld-Studio" /S /Q
git clone https://github.com/MrNeRF/LichtFeld-Studio

cd LichtFeld-Studio
git checkout v0.3.0
REM for the latest dev branch use:
REM git checkout -b dev origin/dev

REM for the latest master branch use:
REM git checkout -b master origin/master

REM @echo off
REM if not exist external mkdir external
REM if not exist external\debug mkdir external\debug
REM if not exist external\release mkdir external\release
REM @echo on

REM setlocal
REM start "" /wait curl -# -L -o libtorch-debug.zip "https://download.pytorch.org/libtorch/cu128/libtorch-win-shared-with-deps-debug-2.7.0%%2Bcu128.zip"
REM tar -xf libtorch-debug.zip -C external\debug
REM del libtorch-debug.zip

REM start "" /wait curl -# -L -o libtorch-release.zip "https://download.pytorch.org/libtorch/cu128/libtorch-win-shared-with-deps-2.7.0%%2Bcu128.zip"
REM tar -xf libtorch-release.zip -C external\release
REM del libtorch-release.zip
REM endlocal

cmake -B build -DCMAKE_BUILD_TYPE=Release -G Ninja -DCMAKE_TOOLCHAIN_FILE="../vcpkg/scripts/buildsystems/vcpkg.cmake"
cmake --build build -j

@echo off
echo COMPLETED!

@pause