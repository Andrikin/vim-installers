:: DEPENDENCIA: git e curl
@echo off

@setlocal

if "%~d0" == "C:" (
    set "USERPROFILE=%USERPROFILE%\Documents"
) else (
    set "USERPROFILE=%~d0"
)

set GITVERSION=2.54.0
set GVIMVERSION=9.2.0612

REM GIT
set "GITDIR=%USERPROFILE%\git"
set "GITLINK=https://github.com/git-for-windows/git/releases/download/v%GITVERSION%.windows.1/MinGit-%GITVERSION%-64-bit.zip"
set "GITZIP=MinGit-%GITVERSION%-64-bit.zip"
set "GIT=%GITDIR%\cmd\git.exe"

if exist "%GIT%" (
    goto notinstallgit
)

REM install git
if not exist "%GITDIR%" mkdir "%GITDIR%"
curl "%GITLINK%" --fail --location --silent --remote-name --output-dir "%GITDIR%"
if exist "%GITDIR%\%GITZIP%" (
    cd "%GITDIR%"
    tar -xf "%GITZIP%"
    del "%GITZIP%"
) else (
    echo "Não foi possível realizar o download do git!"
    exit /B 0 
)

:notinstallgit

REM install gvim
set "GVIMDIR=%USERPROFILE%\gvim"
set "GVIMLINK=https://github.com/vim/vim-win32-installer/releases/download/v%GVIMVERSION%/gvim_%GVIMVERSION%_x64.zip"
set "GVIMZIP=gvim_%GVIMVERSION%_x64.zip"

if not exist "%GVIMDIR%" mkdir "%GVIMDIR%"

curl "%GVIMLINK%" --fail --location --silent --remote-name --output-dir "%GVIMDIR%"

if "%ERRORLEVEL%" == 0 ( echo "GVIM baixado!" ) else (
    echo "Não foi possível realizar o download do GVIM!"
    exit /B 0
)

if exist "%GVIMDIR%\%GVIMZIP%" (
    cd "%GVIMDIR%"
    tar -xf "%GVIMZIP%"
    cd "%GVIMDIR%\vim"
    "%GIT%" init .
    "%GIT%" remote add nvimrc https://github.com/Andrikin/nvimrc
    REM %GIT% remote add nvimrc git@github.com:Andrikin/nvimrc
    "%GIT%" pull nvimrc gvim
    if exist "%GVIMDIR%\%GVIMZIP%" ( del "%GVIMDIR%\%GVIMZIP%" )
)

echo "executando gvim!"
REM Open gvim
cmd.exe /s /c start "%GVIMDIR%\vim\vim92\gvim.exe"

@endlocal

