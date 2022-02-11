#Requires -Modules WebKitDev

$ErrorActionPreference = 'Stop';

# Verify that a build host name is present
if (-not (Test-Path Env:BUILD_HOST_NAME)) {
  Write-Error ('WebKit buildbots require a name for the host to connect to.
For local development set the BUILD_HOST_NAME environment variable using
  docker run -e BUILD_HOST_NAME=<host-name>')
}

# Verify that a build worker name is present
if (-not (Test-Path Env:BUILD_WORKER_NAME)) {
  Write-Error ('WebKit buildbots require a name for the worker to connect.
For local development set the BUILD_WORKER_NAME environment variable using
  docker run -e BUILD_WORKER_NAME=<worker-name>');
}

# Verify that a password is present
if (-not (Test-Path Env:BUILD_WORKER_PASSWORD)) {
  if (-not (Test-Path Env:BUILD_WORKER_PASSWORD_FILE)) {
    Write-Error ('WebKit buildbots require a password to connect.
For local development set the BUILD_WORKER_PASSWORD environment variable using
  docker run -e BUILD_WORKER_PASSWORD=<worker-password>
While in production use docker secrets and set the location of the file using the BUILD_WORKER_PASSWORD_FILE environment variable');
  }

  Write-Host ('Loading password from {0}',$env:BUILD_WORKER_PASSWORD_FILE);
  $Env:BUILD_WORKER_PASSWORD = Get-Content -Path $env:BUILD_WORKER_PASSWORD_FILE;
}

# Output information
Write-Host 'Buildbot information';
Write-Host ('Name: {0}' -f $env:BUILD_WORKER_NAME);
Write-Host ('Admin: {0} <{1}>' -f $env:ADMIN_NAME,$env:ADMIN_EMAIL);
Write-Host ('Description: {0}' -f $env:HOST_DESCRIPTION);

# Print the host information
$cs = Get-WmiObject -Class Win32_ComputerSystem;
Write-Host ('Host system');
Write-Host ('Processors: {0}' -f $cs.NumberOfProcessors);
Write-Host ('Logical processors: {0}' -f $cs.NumberOfLogicalProcessors);
Write-Host ('Total Physical Memory: {0:f2}gb' -f ($cs.TotalPhysicalMemory / 1Gb));

$ld = Get-WmiObject -Class Win32_LogicalDisk;
Write-Host $ld;
Write-Host ('Disk information {0}' -f ($ld.DeviceID));
Write-Host ('Total Disk Space: {0:f2}gb' -f ($ld.Size / 1Gb));
Write-Host ('Available Disk Space: {0:f2}gb' -f ($ld.FreeSpace / 1Gb));

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
Initialize-VSEnvironment -Architecture 'amd64' -Path (Get-VSBuildTools2022VCVarsAllPath);

if ($env:COMPILER -eq 'Clang') {
  $compilerExe = 'clang-cl.exe';
} else {
  $compilerExe = 'cl.exe';
}

$compilerPath = (Get-Command $compilerExe).Path;

Write-Host ('Found compiler at {0}' -f $compilerPath);
Initialize-NinjaEnvironment -Cc $compilerPath -CXX $compilerPath;

# Create the configuration
#
# Remove the password environment variable after configuration
# as buildbot will print the entire environment and leak the
# information.
Write-Host 'Initializing buildbot configuration';
python3 buildbot.py;

Remove-Item Env:BUILD_WORKER_PASSWORD;

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

# Start the buildbot
Write-Host 'Starting buildbot';
Write-Host 'buildbot-worker start'; buildbot-worker start;
