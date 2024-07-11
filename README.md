# docker-webkit-dev
Docker images for local WebKit development and CI/CD on Windows.

[![Build Status](https://dev.azure.com/donjolmstead/Docker%20WebKit%20Dev/_apis/build/status%2FWebKitForWindows.docker-webkit-dev?branchName=main)](https://dev.azure.com/donjolmstead/Docker%20WebKit%20Dev/_build/latest?definitionId=1&branchName=main)

## Host Setup
Using the `webkitdev` Docker images requires a Windows host, ideally Windows 11
or Windows Server 2022 but Windows 10 and Windows Server 2019 can also be used,
with [Docker](https://www.docker.com/) installed and targeting Windows
containers. For new installs follow the latest documentation to setup
[Windows for containers](https://learn.microsoft.com/en-us/virtualization/windowscontainers/quick-start/set-up-environment).

## Images
The `webkitdev` Docker images include the required software to build WebKit on
Windows. Docker images can descend from each other, following a single
inheritance model like in Object-Oriented Programming (OOP). The images in the
table below are organized by purpose and include all components of the previous
image. In practice users will likely only ever need the `msbuild-2022` one for
local builds or `buildbot-worker` for [running CI/CD](BUILDBOT.md) within the
WebKit infrastructure.

| Image | Description |
|---|---|
| [base](https://hub.docker.com/r/webkitdev/base) | The base image (depends on the tag) |
| [scripts](https://hub.docker.com/r/webkitdev/scripts) | Powershell modules to install the software needed |
| [scm](https://hub.docker.com/r/webkitdev/scm) | Contains the Source Control Management (SCM) used for WebKit, e.g. git |
| [tools](https://hub.docker.com/r/webkitdev/tools) | Contains build tools for WebKit, e.g. python, cmake, etc. |
| [msbuild-2022](https://hub.docker.com/r/webkitdev/msbuild-2022) | Contains Visual Studio Build Tools and LLVM |
| [buildbot-worker](https://hub.docker.com/r/webkitdev/buildbot-worker) | Contains Buildbot and scripts to connect to WebKit CI/CD infrastructure |

Docker images support tagging. For Windows images the tag references the version
of the container base image, Windows Server 2022 and Windows Server 2019.
Compatibility depends on what the host OS is. In general Windows 11 needs to
target 2022 tags and Windows 10 needs to target 2019 tags. For the latest
information on Windows container version compatibility see the
[documentation](https://learn.microsoft.com/en-us/virtualization/windowscontainers/deploy-containers/version-compatibility).

| Tag | Automated | Win 11 | Win 10 | Description |
|---|:---:|:---:|:---:|---|
| 2022 | :white_check_mark: | :white_check_mark: | :x: | A Windows 2022 server container |
| windows-2022 | :x: | :white_check_mark: | :x: | A Windows container, used for Layout Tests |
| 1809 | :x: | :white_check_mark: | :white_check_mark: | A Windows 2019 server container |
| windows-1809 | :x: | :white_check_mark: | :white_check_mark: | A Windows container, used for Layout Tests |

The `windows-<version>` have a larger base image containing more Windows OS
components making them ideal for testing WebKit. The other tags use Windows
Server Core and are suitable for building WebKit.

### Building locally
> [!IMPORTANT]
> Windows 11 and Windows Server 2022 users should pull the images directly from
> DockerHub rather than building locally. The only exception is when
> [updating the images](UPDATING.md).

Run the `Build-All.ps1` PowerShell script to build the images. It expects a
single argument `-Tag` which specifies the tag to build. Use the :point_up:
table to determine what value to use.

After the script completes run `docker images` and verify the images are present
and tagged. The created time should be within the time frame the script was
executing in.

## Building the Windows WebKit port
With the `webkitdev/msbuild-2022` image everything is there to do a build of 
the Windows WebKit port. Start out by doing a local checkout of the
[WebKit repository](https://github.com/WebKit/WebKit). The `docker run` command
needs to be populated with the following fields.

| Field | Description |
|---|---|
| tag | The tag to use |
| cpu-count | The number of CPUs to dedicate to the container (optional on a Windows Server host) |
| [memory](https://docs.docker.com/reference/cli/docker/container/run/#memory) | The memory limit for the container (optional on a Windows Server host) | 
| [volume](https://docs.docker.com/reference/cli/docker/container/run/#volume) | A local path containing the WebKit checkout, use `/` over `\` |

```powershell
docker run --name build --rm -it `
    --cpu-count=<cpu-count> --memory=<memory> `
    --volume <volume>:C:/webkit `
    webkitdev/msbuild-2022:<tag> powershell
```

As an example a Windows 11 host having 8 logical cores and 32GB of memory
containing a checkout of WebKit at `C:\GitHub\webkit` would run the container
like this :point_down:.

```powershell
docker run --name build --rm -it `
    --cpu-count=6 --memory=16g `
    --volume C:/GitHub/webkit:C:/webkit `
    webkitdev/msbuild-2022:2022 powershell
```

Once the command is run it will place you into a Powershell session. From there
execute the following to build the Windows WebKit port.

```powershell
Select-VSEnvironment
$env:CC = 'clang-cl.exe'
$env:CXX = 'clang-cl.exe'
cd C:\webkit
perl Tools\Scripts\build-webkit
```

> [!NOTE]
> Building in a container in Hyper-V isolation, the default for Windows 11 and
> 10, will take longer than a local build. Building in a container in process
> mode, the default for Windows Server 2022 and 2019, will build in a similar
> time as a local build.
>
> Ideally dedicate a large amount of resources when running in Hyper-V to reduce
> build time.

After completion the artifacts end up in the `WebKitBuild` directory within the
checkout. The Buildbots for the Windows WebKit port use these Docker containers
so they should build WebKit without issue. However if there any problems with
the images feel free to open an issue.
