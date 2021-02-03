# escape=`

ARG IMAGE_TAG
FROM webkitdev/msbuild:$IMAGE_TAG

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

#--------------------------------------------------------------------
# Install buildbot
#--------------------------------------------------------------------

ENV BUILDBOT_VERSION 1.8.2

RUN Write-Host 'Installing buildbot ...'; `
    pip install -q ('buildbot-worker=={0}' -f $env:BUILDBOT_VERSION); `
    pip show buildbot; `
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
