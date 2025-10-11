# escape=`

ARG IMAGE_TAG
FROM webkitdev/msbuild-2022:$IMAGE_TAG

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

#--------------------------------------------------------------------
# Install buildbot
#--------------------------------------------------------------------

ENV BUILDBOT_VERSION 4.3.0

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
# Set AutoCRLF to false for git
#--------------------------------------------------------------------
RUN git config --system core.autocrlf false

#----------------------------------------------------------------------
# Unset credential.helper for git due to issues for EWS to apple/WebKit
#----------------------------------------------------------------------
RUN git config --system --unset credential.helper

#--------------------------------------------------------------------
# Entrypoint
#--------------------------------------------------------------------

WORKDIR C:\\BW
CMD powershell .\\Run-BuildbotWorker.ps1
