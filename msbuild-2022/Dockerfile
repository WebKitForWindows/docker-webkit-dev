# escape=`

ARG IMAGE_TAG
FROM webkitdev/tools:$IMAGE_TAG

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

#--------------------------------------------------------------------
# Install MS Build Tools 2022
#--------------------------------------------------------------------

RUN Install-VSBuildTools2022 -InstallationPath C:\MSVS -Workloads `
    Microsoft.VisualStudio.Workload.MSBuildTools, `
    Microsoft.VisualStudio.Workload.VCTools, `
    Microsoft.VisualStudio.Component.VC.Tools.x86.x64,`
    Microsoft.VisualStudio.Component.Windows11SDK.26100, `
    Microsoft.VisualStudio.Component.Windows10SDK.18362;

#--------------------------------------------------------------------
# Install LLVM for Clang tooling support
#--------------------------------------------------------------------

ENV LLVM_VERSION 20.1.4

RUN Install-LLVM -Version $env:LLVM_VERSION -InstallationPath C:\LLVM;

#--------------------------------------------------------------------
# Install Debugging Tools for Windows
#--------------------------------------------------------------------

RUN Install-Windows10SDK -Features OptionId.WindowsDesktopDebuggers;
