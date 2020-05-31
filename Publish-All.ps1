param(
  [Parameter(Mandatory)]
  [ValidateSet('1809','1903','1909','2004','windows-1809','windows-1903','windows-1909','windows-2004')]
  [string]$tag
)

$ErrorActionPreference = 'Stop';

function Publish-WebKitDockerImage {
  param(
    [Parameter(Mandatory)]
    [string]$image,
    [Parameter(Mandatory)]
    [string]$tag
  )

  $cmd = 'docker push webkitdev/{0}:{1}' -f $image,$tag;

  Write-Host $cmd;
  Invoke-Expression $cmd;

  if ($LASTEXITCODE -ne 0) {
    Write-Error "docker push failed"
  }
}

Publish-WebKitDockerImage -Image base -Tag $tag;
Publish-WebKitDockerImage -Image scripts -Tag $tag;
Publish-WebKitDockerImage -Image scm -Tag $tag;
Publish-WebKitDockerImage -Image tools -Tag $tag;
Publish-WebKitDockerImage -Image msbuild -Tag $tag;
Publish-WebKitDockerImage -Image msbuild-2017 -Tag $tag;
Publish-WebKitDockerImage -Image buildbot -Tag $tag;
Publish-WebKitDockerImage -Image ews -Tag $tag;
