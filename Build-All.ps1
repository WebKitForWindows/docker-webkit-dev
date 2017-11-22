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

Build-WebKitDockerImage -Tag scripts;
Build-WebKitDockerImage -Tag scm;
Build-WebKitDockerImage -Tag tools;
Build-WebKitDockerImage -Tag msbuild;
Build-WebKitDockerImage -Tag buildbot;
Build-WebKitDockerImage -Tag ews;
