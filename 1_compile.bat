@echo off
echo.
echo ===========================================================================
echo Compiling graphics
echo ===========================================================================
..\..\php5\php.exe -c ..\..\php5\ -f convert_spr.php
if %ERRORLEVEL% NEQ 0 ( exit /b )
..\..\php5\php.exe -c ..\..\php5\ -f convert_bgr.php
if %ERRORLEVEL% NEQ 0 ( exit /b )

echo.
echo ===========================================================================
echo Compiling CPU.MAC
echo ===========================================================================
..\..\php5\php.exe -c ..\..\php5\ -f preprocess.php cpu.mac
if %ERRORLEVEL% NEQ 0 ( exit /b )
..\..\macro11\macro11.exe -ysl 32 -yus -m ..\..\macro11\sysmac.sml -l _cpu.lst _cpu.mac
if %ERRORLEVEL% NEQ 0 ( exit /b )

echo.
echo ===========================================================================
echo Linking and cleanup
echo ===========================================================================
..\..\php5\php.exe -c ..\..\php5\ -f lst2bin.php _cpu.lst ./release/column.bin bbk
del _cpu_bgr.dat
del _cpu_bgr_lz.dat
copy .\release\column.bin C:\Games\Emulators\Bk0010\Bk41_64\Bin
echo.