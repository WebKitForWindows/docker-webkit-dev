FROM microsoft/windowsservercore

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

#--------------------------------------------------------------------
# Install NuGet
#--------------------------------------------------------------------

ENV NUGET_VERSION 2.8.5.208

RUN Install-PackageProvider NuGet \
    -Scope AllUsers \
    -RequiredVersion $env:NUGET_VERSION \
    -Force

#--------------------------------------------------------------------
# Install 7Zip4Powershell Module 
#--------------------------------------------------------------------

ENV 7ZIP_POWERSHELL_VERSION 1.8

RUN Install-Module 7Zip4Powershell \
    -Scope AllUsers \
    -RequiredVersion $env:7ZIP_POWERSHELL_VERSION \
    -Force

#--------------------------------------------------------------------
# Install VSSetup Module
#--------------------------------------------------------------------

ENV VS_SETUP_VERSION 1.0.47.27524

RUN Install-Module VSSetup \
    -Scope AllUsers \
    -RequiredVersion $env:VS_SETUP_VERSION \
    -Force

#--------------------------------------------------------------------
# Install WebKitDev Module
#--------------------------------------------------------------------

ENV WEBKIT_DEV_VERSION 0.1.0

RUN Install-Module WebKitDev \
    -Scope AllUsers \
    -RequiredVersion $env:WEBKIT_DEV_VERSION \
    -Force
