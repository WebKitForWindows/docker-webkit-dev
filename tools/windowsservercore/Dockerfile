FROM webkitdev/scm

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

#--------------------------------------------------------------------
# Install Strawberry Perl x64
#
# ActivePerl is recommended in the WebKit documentation but won't
# install into a docker container. Also its not free so can't
# technically use it for a build-bot.
#--------------------------------------------------------------------

ENV PERL_VERSION 5.26.0.1

RUN Install-Perl -Version $env:PERL_VERSION -InstallationPath C:\tools\perl;

#--------------------------------------------------------------------
# Install Python
#--------------------------------------------------------------------

ENV PYTHON_VERSION 2.7.14
ENV PYTHONIOENCODING utf-8
ENV PYTHON_PIP_VERSION 9.0.1

RUN Install-Python \
    -Version $env:PYTHON_VERSION \
    -PipVersion $env:PYTHON_PIP_VERSION \
    -InstallationPath C:\tools\python;

#--------------------------------------------------------------------
# Install Ruby
#--------------------------------------------------------------------

ENV RUBY_VERSION 2.3.3

RUN Install-Ruby -Version $env:RUBY_VERSION -InstallationPath C:\tools\ruby

#--------------------------------------------------------------------
# Install CMake
#--------------------------------------------------------------------

ENV CMAKE_VERSION 3.9.3

RUN Install-CMake -Version $env:CMAKE_VERSION -InstallationPath C:\tools\cmake;

#--------------------------------------------------------------------
# Install Ninja build system
#--------------------------------------------------------------------

ENV NINJA_VERSION 1.8.2

RUN Register-SystemPath -Path C:\tools\ninja; \
    Install-Ninja -Version $env:NINJA_VERSION -InstallationPath C:\tools\ninja;

#--------------------------------------------------------------------
# Install NASM
#--------------------------------------------------------------------

RUN Register-SystemPath -Path C:\tools\nasm; \
    Install-Nasm -Version 2.13.01 -InstallationPath C:\tools\nasm;

#--------------------------------------------------------------------
# Install GNU tools
#--------------------------------------------------------------------

ENV GPERF_VERSION 3.0.1

RUN Register-SystemPath -Path C:\tools\gperf\bin; \
    Install-Gperf -Version $env:GPERF_VERSION -InstallationPath C:\tools\gperf;

ENV FLEX_VERSION 2.5.4a-1

RUN Register-SystemPath -Path C:\tools\flex\bin; \
    Install-Flex -Version $env:FLEX_VERSION -InstallationPath C:\tools\flex;

ENV BISON_VERSION 2.4.1

RUN Register-SystemPath -Path C:\tools\gnuwin32\bison; \
    Install-Bison -Version $env:BISON_VERSION -InstallationPath C:\tools\bison;
