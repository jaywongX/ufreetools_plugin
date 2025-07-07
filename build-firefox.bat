@echo off
:: Get version from manifest.json
for /f "tokens=2 delims=:" %%a in ('findstr "version" manifest.json') do (
  set VERSION=%%a
)
:: Remove quotes and comma
set VERSION=%VERSION:"=%
set VERSION=%VERSION:,=%
:: Trim spaces
set VERSION=%VERSION: =%

set PACKAGE_NAME=ufreetools-v%VERSION%-firefox

echo Building UFreeTools for Firefox...

:: Create build directory
if not exist "build\firefox" mkdir build\firefox

:: Clean previous build
if exist "build\%PACKAGE_NAME%.zip" del /f /q "build\%PACKAGE_NAME%.zip"

:: Create temp directory
if exist "build\firefox" rd /s /q "build\firefox"
mkdir "build\firefox"

:: Copy files
echo Copying files...
xcopy /y /i /e "node_modules\@simonwep\pickr\dist" "build\firefox\node_modules\@simonwep\pickr\dist\"
xcopy /y /i /e "_locales\*" "build\firefox\_locales\"
xcopy /y /i /e icons "build\firefox\icons\"
copy /y background.js "build\firefox\"
copy /y LICENSE "build\firefox\"
copy /y manifest.firefox.json "build\firefox\manifest.json"
copy /y README.md "build\chrome\README.md"

:: Create zip
cd build\firefox
"C:\Program Files\7-Zip\7z.exe" a -tzip "%PACKAGE_NAME%.zip" * -mx=9 -mmt=on
copy "%PACKAGE_NAME%.zip" ..\
cd ..\..\

:: Clean up
@REM rd /s /q "build\firefox"

echo Build completed: build\%PACKAGE_NAME%.zip