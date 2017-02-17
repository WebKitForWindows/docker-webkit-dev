:: Get SVN version
:: Also creates any SVN directories
svn --version

:: Set proxy if required
python proxy.py

set HTTP_PROXY=

:: WebKit looks for files on disk to identify the IDE. It is currently
:: unable to determine when MS Build Tools are installed. So to get
:: around this we pretend that we have Visual Studio Professional
:: installed on the machine by doing a "touch" on its location
type nul > "C:\Program Files (x86)\Microsoft Visual Studio 14.0\Common7\IDE\devenv.com"

:: Set Visual Studio environment variables of X64
call "C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\vcvarsall.bat" amd64

:: Run the python script to generate the environment
python buildbot.py

:: Remove the password from the environment
set BUILD_SLAVE_PASSWORD=

:: Start the build slave
buildslave start
