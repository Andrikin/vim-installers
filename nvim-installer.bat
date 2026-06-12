:: DEPENDENCIA: git e curl
@echo off

@setlocal EnableDelayedExpansion

set GITVERSION=2.54.0
set NVIMVERSION=0.12.3

REM git variables
set GITDIR=%USERPROFILE%\Documents\git\
set GITLINK=https://github.com/git-for-windows/git/releases/download/v%GITVERSION%.windows.1/MinGit-%GITVERSION%-64-bit.zip
for /F "delims=" %%i in ("%GITLINK%") do set GITZIP=%%~nxi
set GIT=%GITDIR%cmd\git.exe

REM nvim variables
set NVIMDIR=%USERPROFILE%\Documents\nvim-teste\
set NVIMLINK=https://github.com/neovim/neovim/releases/download/v%NVIMVERSION%/nvim-win64.zip
for /F "delims=" %%i in ("%NVIMLINK%") do set NVIMZIP=%%~nxi
set WINPORTABLENEOVIM=%NVIMDIR%win-portable-neovim\

where git > nul 2>&1

if "%ERRORLEVEL%" EQU 0 (
    echo "Encontrado executável git"
) else (
    REM install git
    if not exist "%GITDIR%" mkdir %GITDIR%
    curl --fail --location --silent -O --output-dir %GITDIR% %GITLINK%
    if "%ERRORLEVEL%" EQU 0 echo "git baixado!"
    if exist "%GITDIR%%GITZIP%" (
        cd %GITDIR%
        tar -xf %GITZIP%
        del %GITZIP%
    )
)

if not exist "%NVIMDIR%" (
    mkdir %NVIMDIR%
    if not exist "%WINPORTABLENEOVIM%" mkdir %WINPORTABLENEOVIM% 
)

curl --fail --location --silent -O --output-dir %NVIMDIR% %NVIMLINK%
if "%ERRORLEVEL%" EQU 0 echo "nvim baixado!"

if exist "%NVIMDIR%%NVIMZIP%" (
    cd %NVIMDIR%
    tar -xf %NVIMZIP% -C %WINPORTABLENEOVIM%
    cd %WINPORTABLENEOVIM%
    ren nvim-win64 nvim
    %GIT% init .
    %GIT% remote add nvimrc git@github.com:Andrikin/win-portable-neovim
    %GIT% pull nvimrc main
    if "%ERRORLEVEL%" EQU 0 echo "win-portable-neovim instalado com sucesso!"
    if exist "%NVIMDIR%%NVIMZIP%" ( del %NVIMDIR%%NVIMZIP% )
)

echo "executando nvim!"
REM Open gvim
cmd.exe /c start %WINPORTABLENEOVIM%nvim\bin\nvim.exe --server \\.\pipe\andrikin --remote-ui

@endlocal

