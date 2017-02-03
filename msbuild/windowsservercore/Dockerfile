FROM webkitdev/tools

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

#--------------------------------------------------------------------
# Install MS Build Tools 2015
#--------------------------------------------------------------------

RUN $url = 'https://download.microsoft.com/download/5/f/7/5f7acaeb-8363-451f-9425-68a90f98b238/visualcppbuildtools_full.exe'; \
    Write-Host ('Downloading MSBuild installer from {0} ...' -f $url); \
    (New-Object System.Net.WebClient).DownloadFile($url, 'msbuild-install.exe'); \
    Write-Host 'Installing MSBuild ...'; \
    Start-Process msbuild-install.exe -Wait \
        -ArgumentList @( \
            '/NoRestart', \
            '/Silent' \
        ); \
    Write-Host 'Removing MSBuild installer ...'; \
    Remove-Item msbuild-install.exe -Force;
