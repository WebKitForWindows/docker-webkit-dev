# escape=`

ARG IMAGE_TAG
FROM webkitdev/base:$IMAGE_TAG

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

#--------------------------------------------------------------------
# Install NuGet
#--------------------------------------------------------------------

ENV NUGET_VERSION 2.8.5.208

RUN Install-PackageProvider NuGet `
    -Scope AllUsers `
    -RequiredVersion $env:NUGET_VERSION `
    -Force;

#--------------------------------------------------------------------
# Install WebKitDev Module
#--------------------------------------------------------------------

ENV WEBKIT_DEV_VERSION 0.1.17

RUN Install-Module WebKitDev `
    -Scope AllUsers `
    -RequiredVersion $env:WEBKIT_DEV_VERSION `
    -Force;