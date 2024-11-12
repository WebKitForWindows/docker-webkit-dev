# escape=`

ARG IMAGE_TAG
FROM webkitdev/scripts:$IMAGE_TAG

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

#--------------------------------------------------------------------
# Install Git for Windows x64 CLI
#--------------------------------------------------------------------

ENV GIT_VERSION 2.47.0.2

RUN Install-Git -Version $env:GIT_VERSION;

#--------------------------------------------------------------------
# Configure git for long filename support
#--------------------------------------------------------------------

RUN git config --system core.longpaths true
