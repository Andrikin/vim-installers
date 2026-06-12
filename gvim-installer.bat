:: DEPENDENCIA: git e curl
@echo off

@setlocal

set GITVERSION=2.54.0
set GVIMVERSION=9.2.0612

where git > NUL 2> NUL

if "%ERRORLEVEL%" EQU 0 (
    echo "Encontrado executável git"
) else (
    REM install git
    set GITDIR=%USERPROFILE%\Documents\git\
    set GITLINK=https://github.com/git-for-windows/git/releases/download/v%GITVERSION%.windows.1/MinGit-%GITVERSION%-64-bit.zip
    for /F "delims=" %%i in ("%GITLINK%") do set GITZIP=%%~nxi
    if not exist "%GITDIR%" mkdir %GITDIR%

    curl --fail --location --silent -O --output-dir %GITDIR% %GITLINK%
    if "%ERRORLEVEL%" EQU 0 echo "git baixado!"
    if exist "%GITDIR%%GITZIP%" (
        cd %GITDIR%
        tar -xf %GITZIP%
        del %GITZIP%
    )
)

set GVIMDIR=%USERPROFILE%\Documents\gvim\
set GVIMLINK=https://github.com/vim/vim-win32-installer/releases/download/v%GVIMVERSION%/gvim_%GVIMVERSION%_x64.zip
for /F "delims=" %%i in ("%GVIMLINK%") do set GVIMZIP=%%~nxi

if not exist "%GVIMDIR%"  mkdir %GVIMDIR%

curl --fail --location --silent -O --output-dir %GVIMDIR% %GVIMLINK%
if "%ERRORLEVEL%" EQU 0 echo "gvim baixado!"

if exist "%GVIMDIR%%GVIMZIP%" (
    cd %GVIMDIR%
    tar -xf %GVIMZIP%
    cd %GVIMDIR%vim
    git init .
    REM git remote add nvimrc https://github.com/Andrikin/nvimrc
    git remote add nvimrc git@github.com:Andrikin/nvimrc
    git pull nvimrc gvim
    if exist "%GVIMDIR%%GVIMZIP%" ( del %GVIMDIR%%GVIMZIP% )
)

echo "executando gvim!"
REM Open gvim
cmd.exe /c start %GVIMDIR%vim\vim92\gvim.exe

@endlocal

