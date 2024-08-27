# Updating Images
As new versions of the software housed in the Docker images are released the
versions used should be updated. This document describes the process for doing
that.

> [!NOTE]
> This document assumes experience
> [building the images locally](https://github.com/WebKitForWindows/docker-webkit-dev?tab=readme-ov-file#building-locally).
> If unfamiliar please attempt to build the images as is before attempting to
> modify them.

## Finding new versions
Software versions in Dockerfiles are manually determined. Check the software's
site for updates using the :point_down: table.

| Software | Download Link |
|---|:---:|
| git | https://github.com/git-for-windows/git/releases |
| perl | https://strawberryperl.com/releases.html |
| python | https://www.python.org/downloads |
| pip | https://pypi.org/project/pip |
| pywin32 | https://pypi.org/project/pywin32 |
| ruby | https://rubyinstaller.org/downloads |
| webrick | https://github.com/ruby/webrick/releases |
| cmake | https://cmake.org/download |
| ninja | https://ninja-build.org |
| nuget | https://www.nuget.org/downloads |
| llvm | https://github.com/llvm/llvm-project/releases |

Every software in the Dockerfile has a corresponding `_VERSION` environment
variable. Update this variable to install the newer version.

Installing the software is done through the
[WebKitDev PowerShell module](https://www.powershellgallery.com/packages/WebKitDev).
If the download fails open an
[issue](https://github.com/WebKitForWindows/powershell-webkit-dev/issues) there.

> [!Warning]
> The WebKitDev module expands a filename pattern for the installer. Any changes
> to the naming scheme will cause download failures. The module may be replaced
> by [Chocolatey](https://chocolatey.org) in the future.

## Building
Use the `Build-All.ps1` PowerShell script to build the images. Again it expects
a single argument `-Tag` which specifies the tag to build.

```powershell
./Build-All -tag 2022
```

Executing the script will create all the `webkitdev` images. Most of `RUN`
commands in the Dockerfiles, minus those installing Visual Studio and the
Windows SDK, will complete in short order. However, the entire build process may
require a significant amount of time to complete.

> [!Warning]
> Sometimes an updated installer will fail to run within the container. If an
> installer is taking an abnormal amount of time to complete stop the build,
> hit `CTRL-C`, and revert the change for that version. If the script gets past
> that `RUN` command then pin the version by leaving a comment in the
> Dockerfile.
>
> Conversely if a new version appears after pinning try to update the version in
> case the installation issue is resolved.

After the script completes run `docker images` and verify the images are present
and tagged. The created time should be within the time frame of the build.

## Verification
The best way to verify the new images is to run a [buildbot](BUILDBOT.md)
locally. If that's not possible the `webkitdev/msbuild-2022` image can be used
to make a build. Follow the instructions on
[building the Windows WebKit port](https://github.com/WebKitForWindows/docker-webkit-dev?tab=readme-ov-file#building-the-windows-webkit-port).

If the Buildbot instance runs successfully or the build completes within the
updated image it is ready to land.

## Creating the PR
With the changes tested locally its time to open a PR. Create a branch
`tools-YYYY-MM-DD`, where `YYYY-MM-DD` corresponds with the current date. The
first line of the commit message should be `Update tools`. From there write the
software and the new version. A commit that follows these rules looks like :point_down:.

```text
Update tools

pip -> 24.1.1
cmake -> 3.30.0
llvm -> 18.1.8
```

Push the branch and open a PR on the repository. The CI will attempt to build
the changes and if they pass the PR is ready to merge.
