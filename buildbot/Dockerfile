# escape=`

ARG IMAGE_TAG
FROM webkitdev/msbuild:$IMAGE_TAG

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

#--------------------------------------------------------------------
# Install buildbot
#--------------------------------------------------------------------

ENV BUILDBOT_VERSION 0.8.14

RUN Write-Host 'Installing buildbot ...'; `
    pip2 install -q ('buildbot=={0}' -f $env:BUILDBOT_VERSION); `
    pip2 show buildbot; `
    buildbot --version; `
    `
    pip2 install -q ('buildbot-slave=={0}' -f $env:BUILDBOT_VERSION); `
    pip2 show buildbot-slave; `
    buildslave --version;

#--------------------------------------------------------------------
# Copy files
#--------------------------------------------------------------------

COPY WebKit-BuildWorker C:/BW

#--------------------------------------------------------------------
# Entrypoint
#--------------------------------------------------------------------

WORKDIR C:\\BW
CMD powershell .\\Run-BuildbotWorker.ps1
