FROM webkitdev/tools

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

#--------------------------------------------------------------------
# Install MS Build Tools 2017
#--------------------------------------------------------------------

RUN Install-VSBuildTools2017 -Add Microsoft.VisualStudio.Workload.VCTools Microsoft.VisualStudio.Component.Windows81SDK;
