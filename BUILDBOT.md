# Connecting a WebKit Buildbot
The `docker-webkit-dev` project contains Docker images for running Buildbot
workers that connect to WebKit infrastructure. The Windows WebKit port builds
happen within Docker containers running the `webkitdev/buildbot-worker` image.

> [!IMPORTANT]  
> To connect to WebKit infrastructure credentials are required.
> Contact the infrastructure team on [Slack](https://webkit.slack.com) by
> dropping a message in the `#dev` channel for assistance in connecting new
> bots.

## Getting the image
The `webkitdev/buildbot-worker` image is built and pushed to
[Docker Hub](https://hub.docker.com/r/webkitdev/buildbot-worker). The following
tags are supported. For the latest information on Windows container version
compatibility see the
[documentation](https://learn.microsoft.com/en-us/virtualization/windowscontainers/deploy-containers/version-compatibility)

| Tag Name  | Automated | Description |
|---|:---:|---|
| 2022 | :white_check_mark: | A Windows 2022 server container |
| windows-2022 | :x: | A Windows container, used for Layout Tests |
| 1809 | :x: | A Windows 2019 server container |

Visit [Docker Hub](https://hub.docker.com/r/webkitdev/buildbot-worker/tags) to
see when the last build happened for the image's tags.

## Configuring the Buildbot worker
The `webkitdev/buildbot-worker` image uses environment variables for
configuration. When invoking `docker run` environment variables are specified on
the command line individually or through a file. See the
[documentation](https://docs.docker.com/engine/reference/commandline/container_run/#env)
for more details.

| Environment Variable  | Required | Description |
|---|:---:|---|
| BUILD_HOST_NAME | :white_check_mark: | Host of the buildbot instance, either `build.webkit.org`, for repository commits, or `ews-build.webkit.org` for pull requests |
| BUILD_HOST_PORT | :x: | Port of the buildbot instance, defaults to 17000 |
| BUILD_WORKER_NAME | :white_check_mark: | Name for the worker, provided by infrastructure team  |
| BUILD_WORKER_PASSWORD | :white_check_mark: | Password for the worker, provided by infrastructure team |
| BUILD_WORKER_KEEPALIVE | :x: | Time in seconds that messages should be sent by the worker to the server, defaults to 240 |
| ADMIN_NAME | :x:| Contact name for the admin of the worker | 
| ADMIN_EMAIL | :x: | Contact e-mail address for the admin of the worker |
| HOST_DESCRIPTION |:x: | A description of the host running the worker |
| COMPILER | :white_check_mark: | Needs to be set to `Clang` since the alternative, `cl`, is no longer able to build WebKit |

The preferred method of setup uses an environment file. An example file to fill
out with all the options present looks like this. Save the text file locally
with the name corresponding to worker name; for this example `build.env` is
used.

```txt
ADMIN_EMAIL=<email>
ADMIN_NAME=<admin>
BUILD_HOST_NAME=<host>
BUILD_WORKER_NAME=<name>
BUILD_WORKER_PASSWORD=<password>
HOST_DESCRIPTION=<description>
COMPILER=Clang
```

## Running the Buildbot worker
On a Windows Server 2022 machine run the following in a powershell session. On
Windows Server 2022 the Docker container runs in process isolation mode which
gives it access to all the resources of the host.

> [!NOTE]
> Replace `<tag>` with the value from the above [table](#getting-the-image)
> based on the type of worker being created.

```powershell
docker run --name build --env-file build.env --detach --restart always --storage-opt size=80G webkitdev/buildbot-worker:<tag>
```

> [!IMPORTANT]
> The worker will fail to start if not given enough resources to perform a
> build. This limitation arises because, by default, the Windows container
> allocates only two processors, which is inadequate for running a build. The
> minimum requirements are 4 CPUs with 12GB of memory and 30GB of storage.
> However its best to give as many CPUs as possible with each assigned at least
> 2GB of memory and 80GB of storage.

On a Windows 11 machine run the following in a powershell session. On Windows 11
the Docker container runs in Hyper-V isolation mode so the amount of resources
need to be specified with `cpu-count` and `memory`. Replace `X` with the number
of processors to use and `Y` with the amount of memory in GBs to reserve for the
container.

```powershell
docker run --name build --env-file build.env --detach --restart always --storage-opt size=80G --cpu-count X --memory Yg webkitdev/buildbot-worker:<tag>
```

To see if the container is running invoke the following in a powershell session.
If everything is configured the output will look like this. Check the Buildbot
instance and the worker should be present in its listing.

```powershell
docker logs build

Buildbot information
Name: <name>
Admin: <admin> <email>
Description: <description>
Host system
Processors: 1
Logical processors: 16
Total Physical Memory: 24.50gb
\\60A8A235F96C\root\cimv2:Win32_LogicalDisk.DeviceID="C:"
Disk information C:
Total Disk Space: 126.87gb
Available Disk Space: 126.74gb
Initializing Visual Studio environment
**********************************************************************
** Visual Studio 2022 Developer Command Prompt v17.8.5
** Copyright (c) 2022 Microsoft Corporation
**********************************************************************
[vcvarsall.bat] Environment initialized for: 'x64'
Found compiler at C:\LLVM\bin\clang-cl.exe
Initializing buildbot configuration
Looking in C:\BW\Scripts for additional startup scripts
0 scripts found
Starting buildbot
buildbot-worker start
```

## Debugging
To check on what is going on inside the container and diagnose an issue open a
command prompt on the machine running the Docker container and enter the
following command to get an interactive Powershell prompt within it.

```powershell
docker exec -it build powershell
```

An administrator Powershell instance is now running in the specified container,
`build`, providing full access to it.

An example administrative task would be looking at the Buildbot logs within the
container to diagnose a connection issue. To do that run the following command.

```powershell
PS C:\BW> Get-Content .\twistd.log
```

Whenever the task is over just use `exit` to terminate the session. As long as
the container is running it can be re-entered using `docker exec`. Use it
liberally to diagnose issues with the build.
