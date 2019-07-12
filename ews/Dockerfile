# escape=`

ARG IMAGE_TAG
FROM webkitdev/msbuild:$IMAGE_TAG

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

#--------------------------------------------------------------------
# Install twisted
#--------------------------------------------------------------------

ENV TWISTED_VERSION 19.2.1

RUN Write-Host 'Installing twisted ...'; `
    pip install -q ('Twisted=={0}' -f $env:TWISTED_VERSION); `
    pip show Twisted;

#--------------------------------------------------------------------
# Install buildbot
#--------------------------------------------------------------------

ENV BUILDBOT_VERSION 1.8.2

RUN Write-Host 'Installing buildbot ...'; `
    pip install -q ('buildbot=={0}' -f $env:BUILDBOT_VERSION); `
    pip show buildbot; `
    buildbot --version; `
    buildbot-worker --version;

#--------------------------------------------------------------------
# Copy files
#--------------------------------------------------------------------

COPY Buildbot C:/Buildbot

#--------------------------------------------------------------------
# Entrypoint
#--------------------------------------------------------------------

WORKDIR C:\\Buildbot
CMD powershell .\\Run-BuildbotWorker.ps1
