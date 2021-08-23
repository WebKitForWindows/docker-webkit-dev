param(
  [Parameter(Mandatory)]
  [ValidateSet('1809','1903','1909','2004','20H2','windows-1809','windows-1903','windows-1909','windows-2004','windows-20H2','aws', 'windows-aws')]
  [string]$tag
)

$ErrorActionPreference = 'Stop';

function Build-WebKitDockerImage {
  param(
    [Parameter(Mandatory)]
    [string]$image,
    [Parameter(Mandatory)]
    [string]$tag
  )

  $path = Join-Path $PSScriptRoot $image;
  if ($image -eq 'base') {
    $file = Join-Path $path ('Dockerfile.{0}' -f $tag);
    $buildArgs = '';
  } else {
    $file = Join-Path $path 'Dockerfile';
    $buildArgs = ('--build-arg IMAGE_TAG={0}' -f $tag);
  }

  $cmd = 'docker build -t webkitdev/{0}:{1} {2} -f {3} -m 2GB {4}' -f $image,$tag,$buildArgs,$file,$path;

  Write-Host ('Starting build at {0}' -f (Get-Date))
  Write-Host $cmd;
  Invoke-Expression $cmd;

  if ($LASTEXITCODE -ne 0) {
    Write-Error "docker build failed"
  }
}

Build-WebKitDockerImage -Image base -Tag $tag;
Build-WebKitDockerImage -Image scripts -Tag $tag;
Build-WebKitDockerImage -Image scm -Tag $tag;
Build-WebKitDockerImage -Image tools -Tag $tag;
Build-WebKitDockerImage -Image msbuild -Tag $tag;
Build-WebKitDockerImage -Image msbuild-2017 -Tag $tag;
Build-WebKitDockerImage -Image buildbot-worker -Tag $tag;
Build-WebKitDockerImage -Image buildbot -Tag $tag;
