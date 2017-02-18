FROM webkitdev/scm

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

#--------------------------------------------------------------------
# Install Strawberry Perl x64
#
# ActivePerl is recommended in the WebKit documentation but won't
# install into a docker container. Also its not free so can't
# technically use it for a build-bot.
#--------------------------------------------------------------------

ENV PERL_VERSION 5.24.1.1

RUN $perlUrl = ('http://strawberryperl.com/download/{0}/strawberry-perl-{0}-64bit.msi' -f $env:PERL_VERSION); \
    Write-Host ('Downloading Perl installer from {0} ...' -f $perlUrl); \
    (New-Object System.Net.WebClient).DownloadFile($perlUrl, 'perl-install.msi'); \
    Write-Host 'Installing Perl ...'; \
    Start-Process msiexec -Wait \
        -ArgumentList @( \
            '/i', \
            'perl-install.msi', \
            '/quiet', \
            '/qn' \
        ); \
    Write-Host 'Removing Perl installer ...'; \
    Remove-Item perl-install.msi -Force;

#--------------------------------------------------------------------
# Install Python
#
# Taken from https://github.com/docker-library/python/blob/master/2.7/windows/windowsservercore/Dockerfile
#--------------------------------------------------------------------

ENV PYTHON_VERSION 2.7.13
ENV PYTHON_RELEASE 2.7.13

# if this is called "PIP_VERSION", pip explodes with "ValueError: invalid truth value '<VERSION>'"
ENV PYTHON_PIP_VERSION 9.0.1

RUN $pythonUrl = ('https://www.python.org/ftp/python/{0}/python-{1}.amd64.msi' -f $env:PYTHON_RELEASE, $env:PYTHON_VERSION); \
    Write-Host ('Downloading Python from {0} ...' -f $pythonUrl); \
    (New-Object System.Net.WebClient).DownloadFile($pythonUrl, 'python.msi'); \
    \
    Write-Host 'Installing Python ...'; \
    # https://www.python.org/download/releases/2.4/msi/
    Start-Process msiexec -Wait \
        -ArgumentList @( \
            '/i', \
            'python.msi', \
            '/quiet', \
            '/qn', \
            'TARGETDIR=C:\Python', \
            'ALLUSERS=1', \
            'ADDLOCAL=DefaultFeature,Extensions,TclTk,Tools,PrependPath' \
        ); \
    \
    # the installer updated PATH, so we should refresh our local value
    $env:PATH = [Environment]::GetEnvironmentVariable('PATH', [EnvironmentVariableTarget]::Machine); \
    \
    Write-Host 'Verifying install ...'; \
    Write-Host '  python --version'; python --version; \
    \
    Write-Host 'Removing ...'; \
    Remove-Item python.msi -Force; \
    \
    $pipInstall = ('pip=={0}' -f $env:PYTHON_PIP_VERSION); \
    Write-Host ('Installing {0} ...' -f $pipInstall); \
    (New-Object System.Net.WebClient).DownloadFile('https://bootstrap.pypa.io/get-pip.py', 'get-pip.py'); \
    python get-pip.py $pipInstall; \
    Remove-Item get-pip.py -Force; \
    \
    Write-Host 'Verifying pip install ...'; \
    pip --version; \
    \
    Write-Host 'Complete.';

#--------------------------------------------------------------------
# Install Ruby
#--------------------------------------------------------------------

ENV RUBY_VERSION 2.3.3

RUN $rubyUrl = ('https://dl.bintray.com/oneclick/rubyinstaller/rubyinstaller-{0}-x64.exe' -f $env:RUBY_VERSION); \
    Write-Host ('Downloading Ruby installer from {0} ..' -f $rubyUrl); \
    (New-Object System.Net.WebClient).DownloadFile($rubyUrl, 'ruby-install.exe'); \
    Write-Host 'Installing Ruby ...'; \
    Start-Process ruby-install.exe -Wait \
        -ArgumentList @( \
            '/verysilent', \
            '/tasks="assocfiles,modpath"' \
        ); \
    Write-Host 'Removing Ruby installer ...'; \
    Remove-Item ruby-install.exe -Force

#--------------------------------------------------------------------
# Install CMake
#--------------------------------------------------------------------

ENV CMAKE_RELEASE 3.7
ENV CMAKE_VERSION 3.7.2

RUN $cmakeUrl = ('https://cmake.org/files/v{0}/cmake-{1}-win64-x64.msi' -f $env:CMAKE_RELEASE, $env:CMAKE_VERSION); \
    Write-Host ('Downloading CMake installer from {0} ...' -f $cmakeUrl); \
    (New-Object System.Net.WebClient).DownloadFile($cmakeUrl, 'cmake-install.msi'); \
    Write-Host 'Installing CMake ...'; \
    Start-Process msiexec -Wait \
        -ArgumentList @( \
            '/i', \
            'cmake-install.msi', \
            '/quiet', \
            '/qn', \
            'ADD_CMAKE_TO_PATH="User"' \
        ); \
    Write-Host 'Removing CMake installer ...'; \
    Remove-Item cmake-install.msi -Force

#--------------------------------------------------------------------
# Install GNU tools
#--------------------------------------------------------------------

ENV GPERF_VERSION 3.0.1

RUN $gperfUrl = ('https://downloads.sourceforge.net/project/gnuwin32/gperf/{0}/gperf-{0}-bin.zip' -f $env:GPERF_VERSION); \
    Write-Host ('Downloading gperf binaires from {0} ...' -f $gperfUrl); \
    (New-Object System.Net.WebClient).DownloadFile($gperfUrl, 'gperf-binaries.zip'); \
    Write-Host 'Unzipping gperf binaries ...'; \
    Expand-Archive -Path gperf-binaries.zip -DestinationPath C:\gnuwin32 -Force; \
    Write-Host 'Removing gperf binaries ...'; \
    Remove-Item gperf-binaries.zip -Force;

ENV FLEX_VERSION 2.5.4a-1

RUN $flexUrl = ('https://downloads.sourceforge.net/project/gnuwin32/flex/{0}/flex-{0}-bin.zip' -f $env:FLEX_VERSION); \
    Write-Host ('Downloading Flex binaires from {0} ...' -f $flexUrl); \
    (New-Object System.Net.WebClient).DownloadFile($flexUrl, 'flex-binaries.zip'); \
    Write-Host 'Unzipping Flex binaries ...'; \
    Expand-Archive -Path flex-binaries.zip -DestinationPath C:\gnuwin32 -Force; \
    Write-Host 'Removing Flex binaries ...'; \
    Remove-Item flex-binaries.zip -Force;

ENV BISON_VERSION 2.4.1

RUN $bisonUrl = ('https://downloads.sourceforge.net/project/gnuwin32/bison/{0}/bison-{0}-bin.zip' -f $env:BISON_VERSION); \
    Write-Host ('Downloading Bison binaires from {0} ...' -f $bisonUrl); \
    (New-Object System.Net.WebClient).DownloadFile($bisonUrl, 'bison-binaries.zip'); \
    Write-Host 'Unzipping Bison binaries ...'; \
    Expand-Archive -Path bison-binaries.zip -DestinationPath C:\gnuwin32 -Force; \
    Write-Host 'Removing Bison binaries ...'; \
    Remove-Item bison-binaries.zip -Force;

RUN $systemPathKey = 'Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment'; \
    $systemPath = (Get-ItemProperty -Path $systemPathKey -Name PATH).path; \
	$updatedPath = ('{0};C:\gnuwin32\bin' -f $systemPath); \
	Set-ItemProperty -Path $systemPathKey -Name PATH –Value $updatedPath;
