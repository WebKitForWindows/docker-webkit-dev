# escape=`

ARG IMAGE_TAG
FROM webkitdev/scripts:$IMAGE_TAG

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

#--------------------------------------------------------------------
# Install TortoiseSVN x64 CLI
#--------------------------------------------------------------------

ENV SVN_VERSION 1.14.0.28885

RUN Install-SVN -Version $env:SVN_VERSION;

#--------------------------------------------------------------------
# Install Git for Windows x64 CLI
#--------------------------------------------------------------------

ENV GIT_VERSION 2.30.0.1

RUN Install-Git -Version $env:GIT_VERSION;

#--------------------------------------------------------------------
# Configure git for long filename support
#--------------------------------------------------------------------

RUN git config --system core.longpaths true
