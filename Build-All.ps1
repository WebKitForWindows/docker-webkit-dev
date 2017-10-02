$ErrorActionPreference = 'Stop';

Function Build-WebKitDockerImage {
  Param(
    [Parameter(Mandatory)]
    [string] $tag
  )

  $path = Join-Path $PSScriptRoot (Join-Path $tag 'windowsservercore');
  $cmd = 'docker build -t webkitdev/{0} {1}' -f $tag, $path;

  Write-Host $cmd;
  Invoke-Expression $cmd;
}

# Update Windows image
Write-Host 'docker pull microsoft/windowsservercore';
docker pull microsoft/windowsservercore

Build-WebKitDockerImage -Tag scripts;
Build-WebKitDockerImage -Tag scm;
Build-WebKitDockerImage -Tag tools;
Build-WebKitDockerImage -Tag msbuild;
Build-WebKitDockerImage -Tag buildbot;
