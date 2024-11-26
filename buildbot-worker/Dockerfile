# escape=`

ARG IMAGE_TAG
FROM webkitdev/msbuild-2022:$IMAGE_TAG

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

#--------------------------------------------------------------------
# Install vcpkg
#
# Remove if Microsoft Visual Studio Build Tools adds in a vcpkg
# workload. At this time the workload isn't present for Build Tools
#--------------------------------------------------------------------

ENV VCPKG_VERSION 2024.11.16
ENV VCPKG_ROOT C:\vcpkg

RUN Install-FromArchive -Name 'vcpkg' -url ('https://github.com/microsoft/vcpkg/archive/refs/tags/{0}.zip' -f $env:VCPKG_VERSION) -archiveRoot ('vcpkg-{0}' -f $env:VCPKG_VERSION) -installationPath $env:VCPKG_ROOT -NoVerify; `
    & ('{0}/scripts/bootstrap.ps1' -f $env:VCPKG_ROOT) -disableMetrics; `
    Remove-Item -Recurse -Force (Join-Path $env:VCPKG_ROOT docs); `
    Remove-Item -Recurse -Force (Join-Path $env:VCPKG_ROOT ports); `
    Remove-Item -Recurse -Force (Join-Path $env:VCPKG_ROOT toolsrc); `
    Remove-Item -Recurse -Force (Join-Path $env:VCPKG_ROOT versions); `
    Register-SystemPath $env:VCPKG_ROOT; `
    vcpkg version;

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
