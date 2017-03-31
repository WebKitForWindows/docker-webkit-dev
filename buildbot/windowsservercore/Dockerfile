FROM webkitdev/msbuild

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

#--------------------------------------------------------------------
# Install pywin32
#--------------------------------------------------------------------

ENV PYWIN32_VERSION 219

RUN Write-Host Write-Host 'Installing pywin32 ...'; \
    Start-Process pip -Wait \
        -ArgumentList @( \
            'install', '-q', \
            ('pypiwin32=={0}' -f $env:PYWIN32_VERSION) \
        );

#--------------------------------------------------------------------
# Install twisted
#--------------------------------------------------------------------

ENV TWISTED_VERSION 17.1.0

RUN Write-Host 'Installing twisted ...'; \
    Start-Process pip -Wait \
        -ArgumentList @( \
            'install', '-q', \
            ('Twisted=={0}' -f $env:TWISTED_VERSION) \
        );

#--------------------------------------------------------------------
# Install buildbot
#--------------------------------------------------------------------

ENV BUILDBOT_VERSION 0.8.12

RUN Write-Host 'Installing buildbot ...'; \
    Start-Process pip -Wait \
        -ArgumentList @( \
            'install', '-q', \
            ('buildbot=={0}' -f $env:BUILDBOT_VERSION) \
        ); \
    Start-Process pip -Wait \
        -ArgumentList @( \
            'install', '-q', \
            ('buildbot-slave=={0}' -f $env:BUILDBOT_VERSION) \
        );

#--------------------------------------------------------------------
# Copy files
#--------------------------------------------------------------------

COPY WebKit-BuildSlave C:\\WebKit-BuildSlave

#--------------------------------------------------------------------
# Entrypoint
#--------------------------------------------------------------------

WORKDIR C:\\WebKit-BuildSlave
CMD powershell .\\Run-BuildbotSlave.ps1
