#Requires -Modules WebKitDev

$ErrorActionPreference = 'Stop';

# Verify that a queue name is present
if (-not (Test-Path Env:EWS_QUEUE_NAME)) {
  Write-Error('WebKit EWS requires a queue for the worker to connect to.
For local development set the EWS_QUEUE_NAME environment variable using
  docker run -e EWS_QUEUE_NAME=<worker-name>');
}

# Verify that a server is present
if (-not (Test-Path Env:EWS_SERVER_NAME)) {
  Write-Error('WebKit EWS requires a unique name for the worker to connect as.
For local development set the EWS_SERVER_NAME environment variable using
  docker run -e EWS_SERVER_NAME=<server-name>');
}

# Verify that a bugzilla account is present
if (-not (Test-Path Env:BUGZILLA_USERNAME)) {
  Write-Error('WebKit EWS requires a bugzilla account for the worker to use to retrieve patches.
For local development set the BUGZILLA_USERNAME environment variable using
  docker run -e BUGZILLA_USERNAME=<bugzilla-username>');
}

# Verify that a password is present
if (-not (Test-Path Env:BUGZILLA_PASSWORD)) {
  if (-not (Test-Path Env:BUGZILLA_PASSWORD_FILE)) {
  Write-Error('WebKit EWS requires a bugzilla account for the worker to use to retrieve patches.
For local development set the BUILD_WORKER_PASSWORD environment variable using
  docker run -e BUGZILLA_PASSWORD=<bugzilla-password>
While in production use docker secrets and set the location of the file using the BUGZILLA_PASSWORD_FILE environment variable');
  }

  Write-Host ('Loading password from {0}', $env:BUGZILLA_PASSWORD_FILE);
  $Env:BUGZILLA_PASSWORD = Get-Content -Path $env:BUGZILLA_PASSWORD_FILE;
}

# Notification about security patches
if (-not (Test-Path Env:WEBKIT_STATUS_API_KEY)) {
  if (-not (Test-Path Env:WEBKIT_STATUS_API_KEY_FILE)) {
    Write-Host('WebKit EWS can process security patches if an API key is provided
For local development set the WEBKIT_STATUS_API_KEY environment variable using
  docker run -e WEBKIT_STATUS_API_KEY=<api-key>
While in production use docker secrets and set the location of the file using the WEBKIT_STATUS_API_KEY_FILE environment variable');
  } else {
    Write-Host ('Loading status key from {0}', $env:WEBKIT_STATUS_API_KEY_FILE);
    $Env:WEBKIT_STATUS_API_KEY = Get-Content -Path $env:WEBKIT_STATUS_API_KEY_FILE;
  }
}

# Output information
Write-Host 'EWS information';
Write-Host ('Queue: {0}' -f $env:EWS_QUEUE_NAME);
Write-Host ('Name: {0}' -f $env:EWS_SERVER_NAME);
Write-Host ('Iterations: {0}' -f $env:EWS_ITERATIONS);
Write-Host;

# Print the host information
$cs = Get-WMIObject -Class Win32_ComputerSystem;
Write-Host ('Host system');
Write-Host ('Processors: {0}' -f $cs.NumberOfProcessors);
Write-Host ('Logical processors: {0}' -f $cs.NumberOfLogicalProcessors);
Write-Host ('Total Physical Memory: {0:f2}gb' -f ($cs.TotalPhysicalMemory /1Gb));

$ld = Get-WMIObject -Class Win32_LogicalDisk;
Write-Host ('Disk information {0}' -f ($ld.DeviceID));
Write-Host ('Total Disk Space: {0:f2}gb' -f ($ld.Size /1Gb));
Write-Host ('Available Disk Space: {0:f2}gb' -f ($ld.FreeSpace /1Gb));

# Sanity check the configuration to make sure it is setup properly
$minProcessors = 4;

if ($cs.NumberOfLogicalProcessors -lt $minProcessors) {
  Write-Error ('WebKit builds need to have at least {0} processors available.
Make sure the number of processors is specified when starting the container
  docker run --cpu-count={0}' -f $minProcessors);
}

$minPhysicalMemory = 12;

if ($cs.TotalPhysicalMemory -lt ($minPhysicalMemory * 1Gb)) {
  Write-Error ('WebKit builds need to have at least {0}Gbs of memory available.
Make sure the amount of memory is specified when starting the container
  docker run --memory={0}g' -f $minPhysicalMemory);
}

$minDiskSpace = 30;

if ($ld.Size -lt ($minDiskSpace * 1Gb)) {
  Write-Error ('WebKit builds need to have at least {0}Gbs of disk space available.
Make sure the amount of disk space is set in the storage-opts setting of the daemon
  "storage-opts": [ "size={0}GB" ]' -f $minDiskSpace);
}

# Initialize the Visual Studio environment
Write-Host 'Initializing Visual Studio environment';
Initialize-VSEnvironment -Architecture 'amd64' -Path (Get-VSBuildTools2019VCVarsAllPath);

if ($env:COMPILER -eq 'Clang') {
  $compilerExe = 'clang-cl.exe';
} else {
  $compilerExe = 'cl.exe';
}

$compilerPath = (Get-Command $compilerExe).Path;

Write-Host ('Found compiler at {0}' -f $compilerPath);
Initialize-NinjaEnvironment -CC $compilerPath -CXX $compilerPath;

# Setup git
Write-Host ('git config --global core.autocrlf false');
git config --global core.autocrlf false;

# Clone WebKit repository
$gitUrl = Get-WebKitGitUrl;
Write-Host ('git clone {0} WebKit' -f $gitUrl);
git clone $gitUrl WebKit

# Run any additional startup scripts
$scriptPath = Join-Path $PSScriptRoot 'Scripts';

Write-Host ('Looking in {0} for additional startup scripts' -f $scriptPath);

$scripts = @();

if (Test-Path $scriptPath) {
  $scripts = Get-ChildItem -Path $scriptPath -Filter '*.ps1';
}

Write-Host ('{0} scripts found' -f $scripts.Count);

foreach ($script in $scripts) {
  $invocation = '& {0}' -f $script.FullName;
  Write-Host $invocation;
  Invoke-Expression $invocation;
}

# Setup credentials
Set-Location WebKit;

Write-Host ('git config bugzilla.username {0}' -f $env:BUGZILLA_USERNAME);
git config bugzilla.username $env:BUGZILLA_USERNAME;
Write-Host 'git config bugzilla.password ********'
git config bugzilla.password $env:BUGZILLA_PASSWORD;

# Start the script
Write-Host 'Starting EWS bot';

& Tools/EWSTools/Start-Queue.ps1 -Queue $env:EWS_QUEUE_NAME -Name $env:EWS_SERVER_NAME -Iterations $env:EWS_ITERATIONS;
