# escape=`

ARG IMAGE_TAG
FROM webkitdev/msbuild:$IMAGE_TAG

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

#--------------------------------------------------------------------
# Install buildbot
#--------------------------------------------------------------------

ENV BUILDBOT_VERSION 2.10.5

RUN Write-Host 'Installing buildbot ...'; `
    pip3 install -q ('buildbot-worker=={0}' -f $env:BUILDBOT_VERSION); `
    pip3 show buildbot-worker; `
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
