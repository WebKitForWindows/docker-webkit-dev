FROM webkitdev/msbuild

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

#--------------------------------------------------------------------
# Install ninja
#--------------------------------------------------------------------

ENV NINJA_BUILD_VERSION 1.7.2

RUN $ninjaUrl = ('https://github.com/ninja-build/ninja/releases/download/v{0}/ninja-win.zip' -f $env:NINJA_BUILD_VERSION); \
    Write-Host ('Downloading Ninja binaries from {0} ...' -f $ninjaUrl); \
    (New-Object System.Net.WebClient).DownloadFile($ninjaUrl, 'ninja-binaries.zip'); \
    Write-Host 'Unzipping Ninja binaries ...'; \
    Expand-Archive -Path ninja-binaries.zip -DestinationPath C:\ninja -Force; \
    Write-Host 'Removing Ninja binaries ...'; \
    Remove-Item ninja-binaries.zip -Force; \
    $systemPathKey = 'Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment'; \
    $systemPath = (Get-ItemProperty -Path $systemPathKey -Name PATH).path; \
	$updatedPath = ('{0};C:\ninja' -f $systemPath); \
	Set-ItemProperty -Path $systemPathKey -Name PATH –Value $updatedPath;

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

#--------------------------------------------------------------------
# Copy files
#--------------------------------------------------------------------
	
COPY WebKit-BuildSlave C:\\WebKit-BuildSlave

#--------------------------------------------------------------------
# Entrypoint
#--------------------------------------------------------------------

WORKDIR C:\\WebKit-BuildSlave
CMD .\run.cmd
