FROM microsoft/windowsservercore

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

#--------------------------------------------------------------------
# Install TortoiseSVN x64 CLI
#--------------------------------------------------------------------

ENV SVN_VERSION 1.9.5

RUN $svnUrl = ('https://downloads.sourceforge.net/project/tortoisesvn/{0}/Application/TortoiseSVN-{0}.27581-x64-svn-1.9.5.msi' -f $env:SVN_VERSION); \
    Write-Host ('Downloading SVN installer from {0} ..' -f $svnUrl); \
    (New-Object System.Net.WebClient).DownloadFile($svnUrl, 'svn-install.msi'); \
    Write-Host 'Installing SVN ...'; \
    Start-Process msiexec -Wait \
        -ArgumentList @( \
            '/i', \
            'svn-install.msi', \
            '/quiet', \
            '/qn', \
            'ADDLOCAL=CLI' \
        ); \
    Write-Host 'Removing SVN installer ...'; \
    Remove-Item svn-install.msi -Force;

#--------------------------------------------------------------------
# Install Git for Windows x64 CLI
#--------------------------------------------------------------------

ENV GIT_VERSION 2.11.0

RUN $gitUrl = ('https://github.com/git-for-windows/git/releases/download/v{0}.windows.3/Git-{0}.3-64-bit.exe' -f $env:GIT_VERSION); \
    Write-Host ('Downloading Git installer from {0} ..' -f $gitUrl); \
    (New-Object System.Net.WebClient).DownloadFile($gitUrl, 'git-install.exe'); \
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
    Write-Host 'Removing Git installer ...'; \
    Remove-Item git-install.exe -Force;
