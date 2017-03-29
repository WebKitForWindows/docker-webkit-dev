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

RUN Install-Perl -Version $env:PERL_VERSION;

#--------------------------------------------------------------------
# Install Python
#--------------------------------------------------------------------

ENV PYTHON_VERSION 2.7.13
ENV PYTHONIOENCODING utf-8
ENV PYTHON_PIP_VERSION 9.0.1

RUN Install-Python -Version $env:PYTHON_VERSION -PipVersion $env:PYTHON_PIP_VERSION;

#--------------------------------------------------------------------
# Install Ruby
#--------------------------------------------------------------------

ENV RUBY_VERSION 2.3.3

RUN Install-Ruby -Version $env:RUBY_VERSION;

#--------------------------------------------------------------------
# Install CMake
#--------------------------------------------------------------------

ENV CMAKE_VERSION 3.7.2

RUN Install-CMake -Version $env:CMAKE_VERSION;

#--------------------------------------------------------------------
# Install Ninja build system
#--------------------------------------------------------------------

RUN Register-SystemPath -Path C:\ninja

ENV NINJA_VERSION 1.7.2

RUN Install-Ninja -Version $env:NINJA_VERSION -InstallPath C:\ninja;

#--------------------------------------------------------------------
# Install GNU tools
#--------------------------------------------------------------------

RUN Register-SystemPath -Path C:\gnuwin32\bin;

ENV GPERF_VERSION 3.0.1

RUN Install-Gperf -Version $env:GPERF_VERSION -InstallPath C:\gnuwin32;

ENV FLEX_VERSION 2.5.4a-1

RUN Install-Flex -Version $env:FLEX_VERSION -InstallPath C:\gnuwin32;

ENV BISON_VERSION 2.4.1

RUN Install-Bison -Version $env:BISON_VERSION -InstallPath C:\gnuwin32;
