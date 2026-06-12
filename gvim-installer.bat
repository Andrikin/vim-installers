:: DEPENDENCIA: git e curl
@echo off

setlocal

where git > NUL 2> NUL

if %ERRORLEVEL% EQU 0 (
    echo "Encontrado executável git"
) else (
    REM install git
    set GITDIR=%USERPROFILE%\Documents\git\
    set GITZIP=MinGit-2.54.0-64-bit.zip
    set GITLINK=https://github.com/git-for-windows/git/releases/download/v2.54.0.windows.1/MinGit-2.54.0-64-bit.zip
    if not exist %GITDIR% (
        mkdir %GITDIR%
    )
    curl --fail --location --silent -O --output-dir %GITDIR% %GITLINK%
    if exist %GITDIR%%GITZIP% (
        cd %GITDIR%
        tar -xf %GITZIP%
        del %GITZIP%
    )
    REM Add git to PATH
    setx PATH %PATH%;%GITDIR%cmd
)

set GVIMDIR=%USERPROFILE%\Documents\gvim\
set GVIMLINK=https://github.com/vim/vim-win32-installer/releases/download/v9.2.0612/gvim_9.2.0612_x64.zip
set GVIMZIP=gvim_9.2.0612_x64.zip

if not exist %GVIMDIR% (
    mkdir %GVIMDIR%
)

curl --fail --location --silent -O --output-dir %GVIMDIR% %GVIMLINK%

if exist %GVIMDIR%%GVIMZIP% (
    cd %GVIMDIR%
    tar -xf %GVIMZIP%
    cd %GVIMDIR%vim
    git init .
    REM git remote add nvimrc https://github.com/Andrikin/nvimrc
    git remote add nvimrc git@github.com:Andrikin/nvimrc
    git pull nvimrc gvim
    if exist %GVIMDIR%%GVIMZIP% ( del %GVIMDIR%%GVIMZIP% )
)

REM Open gvim
%GVIMDIR%vim\vim92\gvim.exe

endlocal

