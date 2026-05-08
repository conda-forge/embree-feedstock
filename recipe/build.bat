@echo on
setlocal EnableDelayedExpansion

:: Specify location of TBB
set "TBBROOT=%LIBRARY_PREFIX%"

if "%target_platform%"=="win-64" (
    set "max_isa=AVX2"
) else if "%target_platform%"=="win-arm64" (
    set "max_isa=NEON"
)

:: Configure
cmake -S . -B build -G Ninja ^
      %CMAKE_ARGS% ^
      -DBUILD_SHARED_LIBS=ON ^
      -DEMBREE_TUTORIALS=OFF ^
      -DEMBREE_MAX_ISA=%max_isa% ^
      -DEMBREE_ISPC_SUPPORT=ON
if %ERRORLEVEL% neq 0 exit /b 1

:: Compile
cmake --build build --parallel %CPU_COUNT%
if %ERRORLEVEL% neq 0 exit /b 1

if not "%CONDA_BUILD_SKIP_TESTS%"=="1" (
    ctest -V --test-dir build --parallel %CPU_COUNT%
)
if %ERRORLEVEL% neq 0 exit /b 1

cmake --install build --parallel %CPU_COUNT%
if %ERRORLEVEL% neq 0 exit /b 1

:: remove tutorial models (which embree installed even when EMBREE_TUTORIALS=off)
:: this is easier than patching embree's cmake
rd /s /q %LIBRARY_PREFIX%/bin/models
if %ERRORLEVEL% neq 0 exit /b 1
