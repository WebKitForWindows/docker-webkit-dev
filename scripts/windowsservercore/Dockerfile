FROM microsoft/windowsservercore

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

RUN [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12;

#--------------------------------------------------------------------
# Install NuGet
#--------------------------------------------------------------------

ENV NUGET_VERSION 2.8.5.208

RUN Install-PackageProvider NuGet \
    -Scope AllUsers \
    -RequiredVersion $env:NUGET_VERSION \
    -Force
#--------------------------------------------------------------------
# Install WebKitDev Module
#--------------------------------------------------------------------

ENV WEBKIT_DEV_VERSION 0.1.6

RUN Install-Module WebKitDev \
    -Scope AllUsers \
    -RequiredVersion $env:WEBKIT_DEV_VERSION \
    -Force
