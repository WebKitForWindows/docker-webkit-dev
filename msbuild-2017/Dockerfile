# escape=`

ARG IMAGE_TAG
FROM webkitdev/tools:$IMAGE_TAG

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

#--------------------------------------------------------------------
# Install MS Build Tools 2017
#--------------------------------------------------------------------

RUN Install-VSBuildTools2017 -InstallationPath C:\MSVS -Workloads `
    Microsoft.VisualStudio.Component.Roslyn.Compiler, `
    Microsoft.Component.MSBuild, `
    Microsoft.VisualStudio.Component.CoreBuildTools, `
    Microsoft.VisualStudio.Workload.MSBuildTools, `
    Microsoft.VisualStudio.Component.Windows10SDK, `
    Microsoft.VisualStudio.Component.VC.CoreBuildTools, `
    Microsoft.VisualStudio.Component.VC.Tools.x86.x64, `
    Microsoft.VisualStudio.Component.VC.Redist.14.Latest, `
    Microsoft.VisualStudio.Component.Windows10SDK.17763, `
    Microsoft.VisualStudio.Workload.VCTools, `
    Microsoft.VisualStudio.Workload.NetCoreBuildTools, `
    Microsoft.Net.Component.4.7.1.TargetingPack

#--------------------------------------------------------------------
# Install LLVM for Clang tooling support
#--------------------------------------------------------------------

ENV LLVM_VERSION 12.0.1

RUN Register-SystemPath -Path C:\LLVM\bin; `
    Install-LLVM -Version $env:LLVM_VERSION -InstallationPath C:\LLVM;

#--------------------------------------------------------------------
# Install Debugging Tools for Windows
#--------------------------------------------------------------------

RUN Install-Windows10SDK -Features OptionId.WindowsDesktopDebuggers;
