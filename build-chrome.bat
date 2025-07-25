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

set PACKAGE_NAME=ufreetools-v%VERSION%-chrome

echo Building UFreeTools for Chrome...

:: Create build directory
if not exist "build\chrome" mkdir build\chrome

:: Clean previous build
if exist "build\%PACKAGE_NAME%.zip" del /f /q "build\%PACKAGE_NAME%.zip"

:: Create temp directory
if exist "build\chrome" rd /s /q "build\chrome"
mkdir "build\chrome"

:: Copy files
echo Copying files...
xcopy /y /i /e "node_modules\@simonwep\pickr\dist" "build\chrome\node_modules\@simonwep\pickr\dist\"
xcopy /y /i /e _locales "build\chrome\_locales\"
xcopy /y /i /e icons "build\chrome\icons\"
copy /y background.js "build\chrome\"
copy /y LICENSE "build\chrome\"
copy /y manifest.json "build\chrome\manifest.json"
copy /y README.md "build\chrome\README.md"

:: Create zip
cd build\chrome
powershell Compress-Archive -Path * -DestinationPath ..\%PACKAGE_NAME%.zip -Force
copy "%PACKAGE_NAME%.zip" ..\
cd ..\..\

:: Clean up
@REM rd /s /q "build\chrome"

echo Build completed: build\%PACKAGE_NAME%.zip 