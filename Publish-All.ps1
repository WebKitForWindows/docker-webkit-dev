$ErrorActionPreference = 'Stop';

Function Publish-WebKitDockerImage {
  Param(
    [Parameter(Mandatory)]
    [string] $tag
  )

  $cmd = 'docker push webkitdev/{0}' -f $tag;

  Write-Host $cmd;
  Invoke-Expression $cmd;
}

Publish-WebKitDockerImage -Tag scripts;
Publish-WebKitDockerImage -Tag scm;
Publish-WebKitDockerImage -Tag tools;
Publish-WebKitDockerImage -Tag msbuild;
Publish-WebKitDockerImage -Tag buildbot;
Publish-WebKitDockerImage -Tag ews;
