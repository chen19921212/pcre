@echo off

:: AH 20-12-06 modified for new PCRE-7.0 and VP/BCC

REM This file was contributed by Alexander Tokarev for building PCRE for use
REM with Virtual Pascal. It has not been tested with the latest PCRE release.

REM CHANGE THIS FOR YOUR BORLAND C++ COMPILER PATH

SET BORLAND=F:\bcc
SET PATH=%PATH%;%BORLAND%\bin;f:\tasm\bin
SET PCRE_VER=70

:: sh configure

bcc32 -DDFTABLES -DSTATIC -I%BORLAND%\include -L%BORLAND%\lib dftables.c
:: bcc32 -DDFTABLES -DSTATIC -DVPCOMPAT -I%BORLAND%\include -L%BORLAND%\lib dftables.c
IF ERRORLEVEL 1 EXIT

:: dftables > chartables.c
dftables pcre_chartables.c

REM compile and link the PCRE library into lib: option -B for ASM compile works too
bcc32 -a4 -c -RT- -y- -v- -u- -R- -Q- -X -d -fp -ff -P- -O2 -Oc -Ov -3 -w-8004 -w-8064 -w-8065 -w-8012 -DSTATIC -DVPCOMPAT -UDFTABLES -I%BORLAND%\include @!compile.txt
:: bcc32 -c -RT- -y- -v- -u- -P- -O2 -5 -DSTATIC -DVPCOMPAT -UDFTABLES -I%BORLAND%\include get.c maketables.c pcre.c study.c
IF ERRORLEVEL 1 EXIT

tlib %BORLAND%\lib\cw32.lib *calloc *del *strncmp *memcpy *memmove *memset *memcmp *strlen
:: tlib %BORLAND%\lib\cw32.lib *calloc *del *strncmp *memcpy *memmove *memset
IF ERRORLEVEL 1 EXIT
tlib pcre%PCRE_VER%.lib @!linklib.txt +calloc.obj +del.obj +strncmp.obj +memcpy.obj +memmove.obj +memset.obj +memcmp.obj +strlen.obj
:: tlib pcre.lib +get.obj +maketables.obj +pcre.obj +study.obj +calloc.obj +del.obj +strncmp.obj +memcpy.obj +memmove.obj +memset.obj
IF ERRORLEVEL 1 EXIT

del *.obj *.tds *.bak >nul 2>nul

echo ---
echo Now the library should be complete. Please check all messages above.
echo Don't care for warnings, it's OK.