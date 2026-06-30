:: DEPENDENCIA: git e curl
@echo off

@setlocal

if "%~d0" == "C:" (
    set "USERPROFILE=%USERPROFILE%\Documents"
) else (
    set "USERPROFILE=%~d0"
)

set GITVERSION=2.54.0
set NVIMVERSION=0.12.3

REM GIT
set "GITDIR=%USERPROFILE%\git\"
set "GITLINK=https://github.com/git-for-windows/git/releases/download/v%GITVERSION%.windows.1/MinGit-%GITVERSION%-64-bit.zip"
set "GITZIP=MinGit-%GITVERSION%-64-bit.zip"

for %%i in (git.exe) do set "GIT=%%~$PATH:i"

if not "%GIT%" == "" (
    echo "Encontrado executável git"
    echo "%GIT%"
) else (
    REM install git
    if not exist "%GITDIR%" mkdir "%GITDIR%"
    curl --fail --location --silent -O --output-dir "%GITDIR%" "%GITLINK%"
    if exist "%GITDIR%%GITZIP%" (
        cd "%GITDIR%"
        tar -xf "%GITZIP%"
        del "%GITZIP%"
    ) else (
        echo "Não foi possível realizar o download do git!"
        exit /B 0 
    )
    if exist "%GITDIR%cmd\git.exe" ( setx PATH "%PATH%;%GITDIR%cmd" )
    set "GIT=%GITDIR%cmd\git.exe"
)

REM neovim
set "NVIMDIR=%USERPROFILE%\nvim\"
set "NVIMLINK=https://github.com/neovim/neovim/releases/download/v%NVIMVERSION%/nvim-win64.zip"
set "NVIMZIP=nvim-win64.zip"
set "WINPORTABLENEOVIM=%NVIMDIR%win-portable-neovim\"

if not exist "%NVIMDIR%" (
    mkdir "%NVIMDIR%"
    if not exist "%WINPORTABLENEOVIM%" mkdir "%WINPORTABLENEOVIM%" 
)

curl --fail --location --silent -O --output-dir "%NVIMDIR%" "%NVIMLINK%"

if "%ERRORLEVEL%" == 0 echo "nvim baixado!"

if exist "%NVIMDIR%%NVIMZIP%" (
    cd "%NVIMDIR%"
    tar -xf "%NVIMZIP%" -C "%WINPORTABLENEOVIM%"
    cd "%WINPORTABLENEOVIM%"
    ren nvim-win64 nvim
    "%GIT%" init .
    REM %GIT% remote add nvimrc git@github.com:Andrikin/win-portable-neovim
    "%GIT%" remote add nvimrc https://github.com/Andrikin/win-portable-neovim
    "%GIT%" pull nvimrc main
    if "%ERRORLEVEL%" == 0 echo "win-portable-neovim instalado com sucesso!"
    if exist "%NVIMDIR%%NVIMZIP%" ( del "%NVIMDIR%%NVIMZIP%" )
)

echo "executando nvim!"
REM Open gvim
cmd.exe /s /c start "%WINPORTABLENEOVIM%nvim\bin\nvim.exe" --headless --listen \\.\pipe\andrikin

@endlocal

