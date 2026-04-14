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
    Microsoft.VisualStudio.Component.Vcpkg, `
    Microsoft.VisualStudio.Component.Windows11SDK.28000;

#--------------------------------------------------------------------
# Install LLVM for Clang tooling support
#--------------------------------------------------------------------

ENV LLVM_VERSION 21.1.8

RUN Install-LLVM -Version $env:LLVM_VERSION -InstallationPath C:\LLVM;

#--------------------------------------------------------------------
# Install Debugging Tools for Windows
#--------------------------------------------------------------------

RUN Install-Windows10SDK -Features OptionId.WindowsDesktopDebuggers;
