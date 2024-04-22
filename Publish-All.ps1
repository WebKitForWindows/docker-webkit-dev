param(
  [Parameter(Mandatory)]
  [ValidateSet('1809','2022','aws','windows-1809','windows-aws','windows-2022')]
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
Publish-WebKitDockerImage -Image msbuild-2019 -Tag $tag;
Publish-WebKitDockerImage -Image msbuild-2022 -Tag $tag;
Publish-WebKitDockerImage -Image buildbot-worker -Tag $tag;
