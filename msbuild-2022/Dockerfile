# escape=`

ARG IMAGE_TAG
FROM webkitdev/tools:$IMAGE_TAG

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

#--------------------------------------------------------------------
# Install MS Build Tools 2022
#--------------------------------------------------------------------

RUN Install-VSBuildTools2022 -InstallationPath C:\MSVS -Workloads `
    Microsoft.VisualStudio.Component.Roslyn.Compiler, `
    Microsoft.Component.MSBuild, `
    Microsoft.VisualStudio.Component.CoreBuildTools, `
    Microsoft.VisualStudio.Workload.MSBuildTools, `
    Microsoft.VisualStudio.Component.Windows10SDK, `
    Microsoft.VisualStudio.Component.VC.CoreBuildTools, `
    Microsoft.VisualStudio.Component.VC.Tools.x86.x64, `
    Microsoft.VisualStudio.Component.VC.Redist.14.Latest, `
    Microsoft.VisualStudio.Component.Windows10SDK.18362, `
    Microsoft.VisualStudio.Workload.VCTools

#--------------------------------------------------------------------
# Install LLVM for Clang tooling support
#--------------------------------------------------------------------

ENV LLVM_VERSION 18.1.2

RUN Register-SystemPath -Path C:\LLVM\bin; `
    Install-LLVM -Version $env:LLVM_VERSION -InstallationPath C:\LLVM;

#--------------------------------------------------------------------
# Install Debugging Tools for Windows
#--------------------------------------------------------------------

RUN Install-Windows10SDK -Features OptionId.WindowsDesktopDebuggers;
