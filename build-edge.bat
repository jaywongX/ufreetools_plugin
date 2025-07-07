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

set PACKAGE_NAME=ufreetools-v%VERSION%-edge

echo Building UFreeTools for edge...

:: Create build directory
if not exist "build\edge" mkdir build\edge

:: Clean previous build
if exist "build\%PACKAGE_NAME%.zip" del /f /q "build\%PACKAGE_NAME%.zip"

:: Create temp directory
if exist "build\edge" rd /s /q "build\edge"
mkdir "build\edge"

:: Copy files
echo Copying files...
xcopy /y /i /e "node_modules\@simonwep\pickr\dist" "build\edge\node_modules\@simonwep\pickr\dist\"
xcopy /y /i /e _locales "build\edge\_locales\"
xcopy /y /i /e icons "build\edge\icons\"
copy /y background.js "build\edge\"
copy /y LICENSE "build\edge\"
copy /y manifest.json "build\edge\manifest.json"
copy /y README.md "build\chrome\README.md"

:: Create zip
cd build\edge
powershell Compress-Archive -Path * -DestinationPath ..\%PACKAGE_NAME%.zip -Force
copy "%PACKAGE_NAME%.zip" ..\
cd ..\..\

:: Clean up
@REM rd /s /q "build\edge"

echo Build completed: build\%PACKAGE_NAME%.zip 