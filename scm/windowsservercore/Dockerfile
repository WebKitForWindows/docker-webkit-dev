FROM microsoft/windowsservercore

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

#--------------------------------------------------------------------
# Install TortoiseSVN x64 CLI
#--------------------------------------------------------------------

ENV SVN_VERSION 1.9.5
ENV SVN_BUILD_NUMBER 27581

RUN $svnUrl = ('https://downloads.sourceforge.net/project/tortoisesvn/{0}/Application/TortoiseSVN-{0}.{1}-x64-svn-1.9.5.msi' -f $env:SVN_VERSION, $env:SVN_BUILD_NUMBER); \
    Write-Host ('Downloading SVN installer from {0} ..' -f $svnUrl); \
    (New-Object System.Net.WebClient).DownloadFile($svnUrl, 'svn-install.msi'); \
    Write-Host ('Downloaded {0} bytes' -f (Get-Item 'svn-install.msi').length); \
    \
    Write-Host 'Installing SVN ...'; \
    Start-Process msiexec -Wait \
        -ArgumentList @( \
            '/i', \
            'svn-install.msi', \
            '/quiet', \
            '/qn', \
            'ADDLOCAL=CLI' \
        ); \
    \
    # the installer updated PATH, so we should refresh our local value
    $env:PATH = [Environment]::GetEnvironmentVariable('PATH', [EnvironmentVariableTarget]::Machine); \
    \
    Write-Host 'Verifying SVN install ...'; \
    Write-Host '  svn --version'; svn --version; \
    \
    Write-Host 'Removing SVN installer ...'; \
    Remove-Item svn-install.msi -Force; \
    \
    Write-Host 'SVN install complete.';

#--------------------------------------------------------------------
# Install Git for Windows x64 CLI
#--------------------------------------------------------------------

ENV GIT_VERSION 2.12.0
ENV GIT_BUILD_NUMBER 1

RUN $gitUrl = ('https://github.com/git-for-windows/git/releases/download/v{0}.windows.{1}/Git-{0}-64-bit.exe' -f $env:GIT_VERSION, $env:GIT_BUILD_NUMBER); \
    Write-Host ('Downloading Git installer from {0} ..' -f $gitUrl); \
    (New-Object System.Net.WebClient).DownloadFile($gitUrl, 'git-install.exe'); \
    Write-Host ('Downloaded {0} bytes' -f (Get-Item 'git-install.exe').length); \
    \
    Write-Host 'Installing Git ...'; \
    Start-Process git-install.exe -Wait \
        -ArgumentList @( \
            '/VERYSILENT', \
            '/SUPPRESSMSGBOXES', \
            '/NORESTART', \
            '/NOCANCEL', \
            '/SP-', \
            '/COMPONENTS=Cmd' \
        ); \
    \
    # the installer updated PATH, so we should refresh our local value
    $env:PATH = [Environment]::GetEnvironmentVariable('PATH', [EnvironmentVariableTarget]::Machine); \
    \
    Write-Host 'Verifying Git install ...'; \
    Write-Host '  git --version'; git --version; \
    \
    Write-Host 'Removing Git installer ...'; \
    Remove-Item git-install.exe -Force; \
    \
    Write-Host 'Git install complete.';
