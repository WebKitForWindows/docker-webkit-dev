# escape=`

ARG IMAGE_TAG

#--------------------------------------------------------------------
# Intermediate build image for GNU tools
#--------------------------------------------------------------------

FROM webkitdev/scm:$IMAGE_TAG as msys2

#--------------------------------------------------------------------
# Install GNU tools from MSYS2 into build image
#
# Currently the tools are just copied but in the future MSYS2 should
# be installed into the container and then those files can be copied
# directly
#--------------------------------------------------------------------

COPY msys2 C:/msys2

RUN Register-SystemPath -Path C:\msys2\usr\bin; `
    make --version; `
    patch --version;

#--------------------------------------------------------------------
# Tools image
#--------------------------------------------------------------------

FROM webkitdev/scm:$IMAGE_TAG

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

#--------------------------------------------------------------------
# Copy GNU tools from MSYS2 from build image
#--------------------------------------------------------------------

COPY --from=msys2 C:/msys2 C:/tools/msys2

RUN Register-SystemPath -Path C:\tools\msys2\usr\bin; `
    make --version; `
    patch --version;

#--------------------------------------------------------------------
# Copy GNU tools from GnuWin32 from build image
#--------------------------------------------------------------------

COPY diffutils C:/tools/diffutils
RUN Register-SystemPath -Path C:\Tools\diffutils\bin; `
    diff3 --version;

COPY gperf C:/tools/gperf
RUN Register-SystemPath -Path C:\Tools\gperf\bin; `
    gperf --version;

#--------------------------------------------------------------------
# Install Strawberry Perl x64
#
# ActivePerl is recommended in the WebKit documentation but won't
# install into a docker container. Also its not free so can't
# technically use it for a build-bot.
#--------------------------------------------------------------------

ENV PERL_VERSION 5.32.1.1

RUN Install-Perl -Version $env:PERL_VERSION -InstallationPath C:\tools\perl;

#--------------------------------------------------------------------
# Install Python 3
#--------------------------------------------------------------------

ENV PYTHON3_VERSION 3.9.6
ENV PYTHON3_PIP_VERSION 21.1.3

RUN Install-Python `
    -Version $env:PYTHON3_VERSION `
    -PipVersion $env:PYTHON3_PIP_VERSION `
    -InstallationPath C:\tools\python3;
RUN copy-item C:\tools\python3\python.exe C:\tools\python3\python3.exe

#--------------------------------------------------------------------
# Install pywin32 for Python 3
#--------------------------------------------------------------------

ENV PYWIN32_VERSION 301

RUN Write-Host Write-Host 'Installing pywin32 ...'; `
    pip3 install -q ('pywin32=={0}' -f $env:PYWIN32_VERSION); `
    pip3 show pywin32;

#--------------------------------------------------------------------
# Install Python2
#--------------------------------------------------------------------

ENV PYTHON2_VERSION 2.7.18
ENV PYTHONIOENCODING utf-8
ENV PYTHON2_PIP_VERSION 20.3.4

RUN Install-Python `
    -Version $env:PYTHON2_VERSION `
    -PipVersion $env:PYTHON2_PIP_VERSION `
    -InstallationPath C:\tools\python;
RUN copy-item C:\tools\python\python.exe C:\tools\python\python2.exe

#--------------------------------------------------------------------
# Install pywin32 for python 2
#--------------------------------------------------------------------

# Python 2 support removed with 300
ENV PYWIN32_VERSION 228

RUN Write-Host Write-Host 'Installing pywin32 for python 2...'; `
    pip2 install -q ('pywin32=={0}' -f $env:PYWIN32_VERSION); `
    pip2 show pywin32;

#--------------------------------------------------------------------
# Install Ruby
#--------------------------------------------------------------------

ENV RUBY_VERSION 3.0.0-1

RUN Install-Ruby -Version $env:RUBY_VERSION -InstallationPath C:\tools\ruby;

#--------------------------------------------------------------------
# Install CMake
#--------------------------------------------------------------------

ENV CMAKE_VERSION 3.21.0

RUN Install-CMake -Version $env:CMAKE_VERSION -InstallationPath C:\tools\cmake;

#--------------------------------------------------------------------
# Install Ninja build system
#--------------------------------------------------------------------

ENV NINJA_VERSION 1.10.2

RUN Install-Ninja -Version $env:NINJA_VERSION -InstallationPath C:\tools\ninja;

#--------------------------------------------------------------------
# Install XAMPP
#--------------------------------------------------------------------

ENV XAMPP_VERSION 7.4.21.0

RUN Install-Xampp -Version $env:XAMPP_VERSION; `
    Update-XamppPerlLocation -perlPath C:\tools\perl; `
    Update-XamppPythonLocation -pythonPath C:\tools\python3;

#--------------------------------------------------------------------
# Install Fonts
#--------------------------------------------------------------------

RUN Install-AhemFont;
