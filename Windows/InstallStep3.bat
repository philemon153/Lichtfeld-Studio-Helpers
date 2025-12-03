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
REM default is v0.2.1
git checkout v0.2.1
REM for the latest dev branch use:
REM git checkout -b dev origin/dev

@echo off
if not exist external mkdir external
if not exist external\debug mkdir external\debug
if not exist external\release mkdir external\release
@echo on

setlocal
start "" /wait curl -# -L -o libtorch-debug.zip "https://download.pytorch.org/libtorch/cu128/libtorch-win-shared-with-deps-debug-2.7.0%%2Bcu128.zip"
tar -xf libtorch-debug.zip -C external\debug
del libtorch-debug.zip

start "" /wait curl -# -L -o libtorch-release.zip "https://download.pytorch.org/libtorch/cu128/libtorch-win-shared-with-deps-2.7.0%%2Bcu128.zip"
tar -xf libtorch-release.zip -C external\release
del libtorch-release.zip
endlocal

cmake -B build -DCMAKE_BUILD_TYPE=Release -G Ninja -DCMAKE_TOOLCHAIN_FILE="../vcpkg/scripts/buildsystems/vcpkg.cmake"
cmake --build build -j

@echo off
echo COMPLETED!

@pause