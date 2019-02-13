mkdir build
cd build

:: get gtk+ bundle
curl -O -L http://ftp.gnome.org/pub/gnome/binaries/win64/gtk+/2.22/gtk+-bundle_2.22.1-20101229_win64.zip
unzip -n gtk+-bundle_2.22.1-20101229_win64.zip -d %LIBRARY_PREFIX%
rm gtk+-bundle_2.22.1-20101229_win64.zip
set GTK=%LIBRARY_PREFIX%
set PATH=%PATH%;%GTK%\bin;%GTK%\lib

set INCLUDE=%INCLUDE%;%GTK%\include
set INCLUDE=%INCLUDE%;%GTK%\include\cairo
set INCLUDE=%INCLUDE%;%GTK%\include\glib-2.0;%GTK%\lib\glib-2.0\include

set CFLAGS=
set CXXFLAGS=

cmake -G "NMake Makefiles" ^
      -D CMAKE_INSTALL_PREFIX=%LIBRARY_PREFIX% ^
      -D CMAKE_BUILD_TYPE=Release ^
      -D ENABLE_FORTRAN=0 ^
      -D GTK_PATH=%GTK% ^
      ..
if errorlevel 1 exit 1

nmake
if errorlevel 1 exit 1

:: so tests can find the magics dlls
set PATH=%PATH%;%SRC_DIR%\build\bin

ctest --output-on-failure
if errorlevel 1 exit 1

nmake install
if errorlevel 1 exit 1

:: install activate/deactive scripts
set ACTIVATE_DIR=%PREFIX%\etc\conda\activate.d
set DEACTIVATE_DIR=%PREFIX%\etc\conda\deactivate.d
mkdir %ACTIVATE_DIR%
mkdir %DEACTIVATE_DIR%

copy %RECIPE_DIR%\scripts\activate.bat %ACTIVATE_DIR%\magics-activate.bat
if errorlevel 1 exit 1

copy %RECIPE_DIR%\scripts\deactivate.bat %DEACTIVATE_DIR%\magics-deactivate.bat
if errorlevel 1 exit 1
