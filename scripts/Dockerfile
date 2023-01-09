# escape=`

ARG IMAGE_TAG
FROM webkitdev/base:$IMAGE_TAG

ARG HTTP_PROXY
ENV HTTP_PROXY=$HTTP_PROXY
ARG HTTPS_PROXY
ENV HTTPS_PROXY=$HTTPS_PROXY

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

#--------------------------------------------------------------------
# Install NuGet
#--------------------------------------------------------------------

ENV NUGET_VERSION 2.8.5.208

RUN $scriptArgs = @{ `
        Name = 'NuGet'; `
        Scope = 'AllUsers'; `
        RequiredVersion = $env:NUGET_VERSION; `
        Force = $true; `
    }; `
    `
    if (Test-Path env:HTTPS_PROXY) { `
        $scriptArgs['Proxy'] = $env:HTTPS_PROXY; `
    } `
    `
    Install-PackageProvider @scriptArgs;

#--------------------------------------------------------------------
# Trust Powershell Gallery
#--------------------------------------------------------------------

RUN $scriptArgs = @{ `
        Name = 'PSGallery'; `
        InstallationPolicy = 'Trusted'; `
    }; `
    `
    if (Test-Path env:HTTPS_PROXY) { `
        $scriptArgs['Proxy'] = $env:HTTPS_PROXY; `
    } `
    `
    Set-PSRepository @scriptArgs;

#--------------------------------------------------------------------
# Install WebKitDev Module
#--------------------------------------------------------------------

ENV WEBKIT_DEV_VERSION 0.5.1

RUN $scriptArgs = @{ `
        Name = 'WebKitDev'; `
        Scope = 'AllUsers'; `
        RequiredVersion = $env:WEBKIT_DEV_VERSION; `
        Force = $true; `
    }; `
    `
    if (Test-Path env:HTTPS_PROXY) { `
        $scriptArgs['Proxy'] = $env:HTTPS_PROXY; `
    } `
    `
    Install-Module @scriptArgs;
