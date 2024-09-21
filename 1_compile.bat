@echo off
echo.
echo ===========================================================================
echo Compiling graphics
echo ===========================================================================
php -f convert_spr.php
if %ERRORLEVEL% NEQ 0 ( exit /b )
php -f convert_bgr.php
if %ERRORLEVEL% NEQ 0 ( exit /b )
php -f convert_onoff.php
if %ERRORLEVEL% NEQ 0 ( exit /b )

echo.
echo ===========================================================================
echo Compiling code
echo ===========================================================================
php -f ../scripts/preprocess.php cpu.mac
if %ERRORLEVEL% NEQ 0 ( exit /b )
..\scripts\macro11 -ysl 32 -yus -l _cpu.lst _cpu.mac
if %ERRORLEVEL% NEQ 0 ( exit /b )
php -f ../scripts/lst2bin.php _cpu.lst _cpu.bin bin 1000
if %ERRORLEVEL% NEQ 0 ( exit /b )
..\scripts\zx0 -f -q _cpu.bin _cpu_lz.bin

php -f ../scripts/preprocess.php column.mac
if %ERRORLEVEL% NEQ 0 ( exit /b )
..\scripts\macro11.exe -ysl 32 -yus -l _column.lst _column.mac
if %ERRORLEVEL% NEQ 0 ( exit /b )
php -f ../scripts/lst2bin.php _column.lst ./release/column.bin bbk 2000
if %ERRORLEVEL% NEQ 0 ( exit /b )
php -f ../scripts/bin2wav.php ./release/column.bin
if %ERRORLEVEL% NEQ 0 ( exit /b )

del _cpu_lz.bin
del _cpu.bin
del _cpu_bgr_lz.dat
del _cpu_bgr.dat
del _column.lst
del _column.mac
del _cpu.mac

echo.
start ..\..\bkemu\BK_x64.exe /C BK-0010-01 /B .\release\column.bin
