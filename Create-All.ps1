Param(
  [Parameter(Mandatory)]
  [ValidateSet('1709','1803','1809')]
  [string] $tag
)

$ErrorActionPreference = 'Stop';

Function Create-WebKitDockerImage {
  Param(
    [Parameter(Mandatory)]
    [string] $image,
    [Parameter(Mandatory)]
    [string] $tag
  )

  $input = Join-Path $PSScriptRoot (Join-Path $image 'Dockerfile.tmpl');
  $output = Join-Path $PSScriptRoot (Join-Path $image ('Dockerfile.{0}' -f $tag));

  $contents = (Get-Content $input).replace('{{tag}}', $tag);
  $contents | Out-File -Encoding utf8 $output;

  Write-Host ('Creating webkitdev/{0}:{1}' -f $image, $tag);
}

Create-WebKitDockerImage -Image scripts -Tag $tag;
Create-WebKitDockerImage -Image scm -Tag $tag;
Create-WebKitDockerImage -Image tools -Tag $tag;
Create-WebKitDockerImage -Image msbuild -Tag $tag;
Create-WebKitDockerImage -Image buildbot -Tag $tag;
Create-WebKitDockerImage -Image ews -Tag $tag;
