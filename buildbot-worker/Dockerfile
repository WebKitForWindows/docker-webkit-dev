# escape=`

ARG IMAGE_TAG
FROM webkitdev/msbuild:$IMAGE_TAG

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

#--------------------------------------------------------------------
# Install twisted
#
# REMOVE after version 21.2.0 is released
#--------------------------------------------------------------------

ENV TWISTED_VERSION 21.2.0rc1

RUN Write-Host 'Installing twisted ...'; `
    pip3 install -q ('twisted=={0}' -f $env:TWISTED_VERSION); `
    pip3 show twisted;

#--------------------------------------------------------------------
# Install buildbot
#--------------------------------------------------------------------

ENV BUILDBOT_VERSION 2.10.1

RUN Write-Host 'Installing buildbot ...'; `
    pip3 install -q ('buildbot-worker=={0}' -f $env:BUILDBOT_VERSION); `
    pip3 show buildbot; `
    buildbot-worker --version;

#--------------------------------------------------------------------
# Copy files
#--------------------------------------------------------------------

COPY BuildbotWorker C:/BW

#--------------------------------------------------------------------
# Entrypoint
#--------------------------------------------------------------------

WORKDIR C:\\BW
CMD powershell .\\Run-BuildbotWorker.ps1
