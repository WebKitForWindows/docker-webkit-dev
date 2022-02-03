# escape=`

ARG IMAGE_TAG
FROM webkitdev/tools:$IMAGE_TAG

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

#--------------------------------------------------------------------
# Install MS Build Tools 2019
#
# Using Windows SDK 10.0.18362 rather than 10.0.17763 to avoid
#  error C2039: 'CheckForDuplicateEntries': is not a member of 'Microsoft::WRL::Details'
# errors with /permissive- on ANGLE compile
#--------------------------------------------------------------------

RUN Install-VSBuildTools2019 -InstallationPath C:\MSVS -Workloads `
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

ENV LLVM_VERSION 13.0.1

RUN Register-SystemPath -Path C:\LLVM\bin; `
    Install-LLVM -Version $env:LLVM_VERSION -InstallationPath C:\LLVM;

#--------------------------------------------------------------------
# Install include-what-you-use
#--------------------------------------------------------------------

COPY include-what-you-use C:/tools/include-what-you-use
RUN Register-SystemPath -Path C:\Tools\include-what-you-use\bin; `
    include-what-you-use --version;

#--------------------------------------------------------------------
# Install Debugging Tools for Windows
#--------------------------------------------------------------------

RUN Install-Windows10SDK -Features OptionId.WindowsDesktopDebuggers;
