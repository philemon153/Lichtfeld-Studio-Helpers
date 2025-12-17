@echo off

REM --- For Windows only ---

if exist "C:\msys64\" ren "C:\msys64" msys64_

call "C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\vcvarsall.bat" x64
echo Started x64 Visual Studio 2022 environment
cmake --version
nvcc --version
git --version
python --version

@echo on

cd Lichtfeld-Studio
git pull

cmake -B build -DCMAKE_BUILD_TYPE=Release -G Ninja -DCMAKE_TOOLCHAIN_FILE="../vcpkg/scripts/buildsystems/vcpkg.cmake"
cmake --build build -j

if exist "C:\msys64_\" ren "C:\msys64_" msys64

@pause