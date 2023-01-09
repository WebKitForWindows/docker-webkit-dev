# escape=`

ARG IMAGE_TAG
FROM webkitdev/scripts:$IMAGE_TAG

ARG HTTP_PROXY
ENV HTTP_PROXY=$HTTP_PROXY
ARG HTTPS_PROXY
ENV HTTPS_PROXY=$HTTPS_PROXY

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

#--------------------------------------------------------------------
# Install Git for Windows x64 CLI
#--------------------------------------------------------------------

ENV GIT_VERSION 2.39.0.1

RUN Install-Git -Version $env:GIT_VERSION;

#--------------------------------------------------------------------
# Configure git for long filename support
#--------------------------------------------------------------------

RUN git config --system core.longpaths true
