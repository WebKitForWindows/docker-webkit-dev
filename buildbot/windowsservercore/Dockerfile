FROM webkitdev/msbuild

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

#--------------------------------------------------------------------
# Install MS Visual C++ Compiler for Python 2.7
#--------------------------------------------------------------------

RUN $cppUrl = 'https://download.microsoft.com/download/7/9/6/796EF2E4-801B-4FC4-AB28-B59FBF6D907B/VCForPython27.msi'; \
    Write-Host ('Downloading MS VC++ for Python 2.7 from {0} ...' -f $cppUrl); \
    (New-Object System.Net.WebClient).DownloadFile($cppUrl, 'vc-for-python-27.msi'); \
    Write-Host 'Installing MS VC++ for Python 2.7 ...'; \
    Start-Process msiexec -Wait \
        -ArgumentList @( \
            '/i', \
            'vc-for-python-27.msi', \
            '/quiet', \
            '/qn' \
        ); \
    Write-Host 'Removing MSBuild installer ...'; \
    Remove-Item vc-for-python-27.msi -Force;

#--------------------------------------------------------------------
# Set encoding for Python console
#
# This is necessary for the Python console to function properly
#--------------------------------------------------------------------

ENV PYTHONIOENCODING utf-8

#--------------------------------------------------------------------
# Install pywin32
#--------------------------------------------------------------------

ENV PYWIN32_VERSION 219

RUN Write-Host Write-Host 'Installing pywin32 ...'; \
    Start-Process pip -Wait \
        -ArgumentList @( \
            'install', \
            ('pypiwin32=={0}' -f $env:PYWIN32_VERSION) \

        );
#--------------------------------------------------------------------
# Install twisted
#--------------------------------------------------------------------

ENV TWISTED_VERSION 17.1.0

RUN Write-Host 'Installing twisted ...'; \
    Start-Process pip -Wait \
        -ArgumentList @( \
            'install', \
            ('Twisted=={0}' -f $env:TWISTED_VERSION) \
        );

#--------------------------------------------------------------------
# Install buildbot
#--------------------------------------------------------------------

ENV BUILDBOT_VERSION 0.8.12

RUN Write-Host 'Installing buildbot ...'; \
    Start-Process pip -Wait \
        -ArgumentList @( \
            'install', \
            ('buildbot=={0}' -f $env:BUILDBOT_VERSION) \
        ); \
    Start-Process pip -Wait \
        -ArgumentList @( \
            'install', \
            ('buildbot-slave=={0}' -f $env:BUILDBOT_VERSION) \
        );

COPY WebKit-BuildSlave C:\\WebKit-BuildSlave

#--------------------------------------------------------------------
# Entrypoint
#--------------------------------------------------------------------

WORKDIR C:\\WebKit-BuildSlave
CMD .\run.cmd
