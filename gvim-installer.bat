:: DEPENDENCIA: git e curl
@echo off

SETLOCAL

where git > NUL 2> NUL

IF %ERRORLEVEL% EQU 0 (
    echo "Encontrado executável git"
) ELSE (
    REM install git
    SET GITDIR=%HOMEDRIVE%%HOMEPATH%\Documents\git\
    SET GITZIP=MinGit-2.54.0-64-bit.zip
    SET GITLINK=https://github.com/git-for-windows/git/releases/download/v2.54.0.windows.1/MinGit-2.54.0-64-bit.zip
    IF NOT EXIST %GITDIR% (
        mkdir %GITDIR%
    )
    curl --fail --location --silent -O --output-dir %GITDIR% %GITLINK%
    IF EXIST %GITDIR%%GITZIP% (
        cd %GITDIR%
        tar -xf %GITZIP%
        del %GITZIP%
    )
    REM Add git to PATH
    SETX PATH %PATH%;%GITDIR%cmd
)

SET GVIMDIR=%HOMEDRIVE%%HOMEPATH%\Documents\gvim\
SET GVIMLINK=https://github.com/vim/vim-win32-installer/releases/download/v9.2.0612/gvim_9.2.0612_x64.zip
SET GVIMZIP=gvim_9.2.0612_x64.zip

IF NOT EXIST %GVIMDIR% (
    mkdir %GVIMDIR%
)

curl --fail --location --silent -O --output-dir %GVIMDIR% %GVIMLINK%

IF EXIST %GVIMDIR%%GVIMZIP% (
    cd %GVIMDIR%
    tar -xf %GVIMZIP%
    cd %GVIMDIR%vim
    git init .
    REM git remote add nvimrc https://github.com/Andrikin/nvimrc
    git remote add nvimrc git@github.com:Andrikin/nvimrc
    git pull nvimrc gvim
    IF EXIST %GVIMDIR%%GVIMZIP% ( del %GVIMDIR%%GVIMZIP% )
)

REM Open gvim
%GVIMDIR%vim\vim92\gvim.exe

ENDLOCAL

