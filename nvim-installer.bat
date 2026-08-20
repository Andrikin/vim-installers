:: DEPENDENCIA: git e curl
REM TODO: observar a instalação de ssh. Buscar ativar uma chave com
REM ssh-add
@echo off

@setlocal

set "USERPROFILEBKP=%USERPROFILE%"

if "%~d0" == "C:" (
    set "USERPROFILE=%USERPROFILE%\Documents"
) else (
    set "USERPROFILE=%~d0"
)

set GITVERSION=2.54.0
REM set NVIMVERSION=0.12.3
set NVIMVERSION=nightly

REM GIT
set "GITDIR=%USERPROFILE%\git"
set "GITLINK=https://github.com/git-for-windows/git/releases/download/v%GITVERSION%.windows.1/MinGit-%GITVERSION%-64-bit.zip"
set "GITZIP=MinGit-%GITVERSION%-64-bit.zip"
set "GIT=%GITDIR%\cmd\git.exe"

REM neovim
set "NVIMDIR=%USERPROFILE%\nvim"
set "NVIMLINK=https://github.com/neovim/neovim/releases/download/v%NVIMVERSION%/nvim-win64.zip"
set "NVIMZIP=nvim-win64.zip"
set "WINPORTABLENEOVIM=%NVIMDIR%\win-portable-neovim\"

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
    exit /B 1 
)

:notinstallgit

if not exist "%NVIMDIR%" (
    mkdir "%NVIMDIR%"
    if not exist "%WINPORTABLENEOVIM%" mkdir "%WINPORTABLENEOVIM%" 
)

curl "%NVIMLINK%" --fail --location --silent --remote-name --output-dir "%NVIMDIR%"

if not exist "%NVIMDIR%\%NVIMZIP%" (
    echo "Não foi possível realizar o download do NVIM!"
    exit /B 1
)

if exist "%NVIMDIR%\%NVIMZIP%" (
    cd "%NVIMDIR%"
    tar -xf "%NVIMZIP%" -C "%WINPORTABLENEOVIM%"
    if "%ERRORLEVEL%" == 0 (
		echo "win-portable-neovim instalado com sucesso!"
		exit /B 1
	)
    cd "%WINPORTABLENEOVIM%"
    ren nvim-win64 nvim
    "%GIT%" init .
    "%GIT%" remote add nvimrc https://github.com/Andrikin/win-portable-neovim
    "%GIT%" pull nvimrc main
    if "%ERRORLEVEL%" == 0 echo "win-portable-neovim instalado com sucesso!"
    if exist "%NVIMDIR%\%NVIMZIP%" ( del "%NVIMDIR%\%NVIMZIP%" )
)

set "USERPROFILE=%USERPROFILEBKP%"
set "USERPROFILEBKP="

set "PATH=%PATH%;%GITDIR%\cmd"

echo "executando nvim!"
REM Open gvim
cmd.exe /s /c "%WINPORTABLENEOVIM%nvim\bin\nvim.exe" --headless --listen \\.\pipe\andrikin

@endlocal

