ARG IMAGE_TAG
FROM webkitdev/msbuild:$IMAGE_TAG

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

#--------------------------------------------------------------------
# Copy files
#--------------------------------------------------------------------

COPY WebKit-EWS C:/WebKit-EWS

#--------------------------------------------------------------------
# Entrypoint
#--------------------------------------------------------------------

WORKDIR C:\\WebKit-EWS
CMD powershell .\\Run-EWS.ps1
