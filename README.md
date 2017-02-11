# docker-webkit-dev
Docker images for doing WebKit development

## Windows development

The `webkitdev` images contain the tools necessary to build WebKit on Windows.
To run the images follow the instructions for [Docker for Windows]
(https://docs.docker.com/docker-for-windows/). After installation Docker will
be able to run Linux containers. To switch over to Windows containers follow
[this visual]
(https://stefanscherer.github.io/run-linux-and-windows-containers-on-windows-10/).

Currently 1.13.1 is the tested version. The beta channel has not been tested.

### Building WinCairo

With the `webkitdev/msbuild` image everything is there to do a build of 
WinCairo. To start run the following command replacing `X` with the number of
CPUs you'd like to have running the build, and `Y` with the number of GBs that
should be available for the build. The defaults for the container are not enough
to build WinCairo successfully.

As an example with 8 logical cores setting `cpu-count` to `6` and `memory` to
`16g` can successfully build WinCairo. To be safe you can give more memory and
CPU to make sure the build completes.

```powershell
# Pulls the latest image
docker pull webkitdev/msbuild

# Runs an interactive shell which will remove itself when completed
docker run --name build --rm -it --cpu-count=X --memory=Yg webkitdev/msbuild cmd
```

Once the command is run it will place you into a Windows Command Prompt.
From there run the following.

```cmd
:: Checkout WebKit
svn checkout -q https://svn.webkit.org/repository/webkit/trunk WebKit

:: WebKit looks for files on disk to identify the IDE. It is currently
:: unable to determine when MS Build Tools are installed. So to get
:: around this we pretend that we have Visual Studio Professional
:: installed on the machine by doing a "touch" on its location
type nul > "C:\Program Files (x86)\Microsoft Visual Studio 14.0\Common7\IDE\devenv.com"

:: Build WinCairo
:: 
:: The output is currently being redirected to a file as there is an
:: outstanding bug on Docker for Windows where too much console output
:: will cause the container to break.
::
:: https://github.com/docker/for-win/issues/199
cd WebKit
perl Tools\Scripts\build-webkit --wincairo --64-bit
```

The build shouldn't take more than an hour. If at any point you want to check
the progress you can run the following to gain access to the container.

```powershell
docker exec -it build powershell
```

Then to check the output of the file do the following where `X` is the number of
lines at the end of the file to display.

```powershell
Get-Content .\WebKit\output.txt | Select-Object -last X
```

### Troubleshooting

Currently the only issue I've had with the setup is that the build
requires a large amount of memory. If you see in the build logs that the 
compiler needs more memory then exit out of the container and start it again 
with additional memory.
