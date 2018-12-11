FROM webkitdev/tools

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

#--------------------------------------------------------------------
# Install MS Build Tools 2017
#--------------------------------------------------------------------

# FIXME: Currently we're installing the 15.7 toolset due to ongoing issues with 15.8 and later toolsets

RUN Install-VSBuildTools2017 -Workloads \
    Microsoft.VisualStudio.Workload.VCTools.14.14, \
    Microsoft.VisualStudio.Component.Windows10SDK.15063.Desktop, \
    Microsoft.VisualStudio.Component.Windows81SDK, \
    Microsoft.VisualStudio.ComponentGroup.NativeDesktop.Win81;

#--------------------------------------------------------------------
# Install LLVM for Clang tooling support
#--------------------------------------------------------------------

RUN Install-LLVM -Version 7.0.0;
