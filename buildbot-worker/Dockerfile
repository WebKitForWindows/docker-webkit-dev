# escape=`

ARG IMAGE_TAG
FROM webkitdev/msbuild-2022:$IMAGE_TAG

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
# Make git sh available in path for branch cleanup
#--------------------------------------------------------------------

RUN Register-SystemPath -path 'C:\program files\git\bin'; `
    sh --version

#--------------------------------------------------------------------
# Entrypoint
#--------------------------------------------------------------------

WORKDIR C:\\BW
CMD powershell .\\Run-BuildbotWorker.ps1
