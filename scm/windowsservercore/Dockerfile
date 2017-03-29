FROM webkitdev/scripts

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

#--------------------------------------------------------------------
# Install TortoiseSVN x64 CLI
#--------------------------------------------------------------------

ENV SVN_VERSION 1.9.5
ENV SVN_BUILD_NUMBER 27581

RUN Install-SVN -Version $env:SVN_VERSION -BuildNumber $env:SVN_BUILD_NUMBER;

#--------------------------------------------------------------------
# Install Git for Windows x64 CLI
#--------------------------------------------------------------------

ENV GIT_VERSION 2.12.2
ENV GIT_BUILD_NUMBER 1

RUN Install-Git -Version $env:GIT_VERSION -BuildNumber $env:GIT_BUILD_NUMBER;
