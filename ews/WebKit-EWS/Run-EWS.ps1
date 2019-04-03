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

  Write-Output ('Loading password from {0}', $env:BUGZILLA_PASSWORD_FILE);
  $Env:BUGZILLA_PASSWORD = Get-Content -Path $env:BUGZILLA_PASSWORD_FILE;
}

# Notification about security patches
if (-not (Test-Path Env:WEBKIT_STATUS_API_KEY)) {
  if (-not (Test-Path Env:WEBKIT_STATUS_API_KEY_FILE)) {
    Write-Output('WebKit EWS can process security patches if an API key is provided
For local development set the WEBKIT_STATUS_API_KEY environment variable using
  docker run -e WEBKIT_STATUS_API_KEY=<api-key>
While in production use docker secrets and set the location of the file using the WEBKIT_STATUS_API_KEY_FILE environment variable');
  } else {
    Write-Output ('Loading status key from {0}', $env:WEBKIT_STATUS_API_KEY_FILE);
    $Env:WEBKIT_STATUS_API_KEY = Get-Content -Path $env:WEBKIT_STATUS_API_KEY_FILE;
  }
}

# Output information
Write-Output 'EWS information';
Write-Output ('Queue: {0}' -f $env:EWS_QUEUE_NAME);
Write-Output ('Name: {0}' -f $env:EWS_SERVER_NAME);
Write-Output ('Iterations: {0}' -f $env:EWS_ITERATIONS);
Write-Output '';

# Print the host information
$cs = Get-CimInstance -Class Win32_ComputerSystem;
Write-Output ('Host system');
Write-Output ('Processors: {0}' -f $cs.NumberOfProcessors);
Write-Output ('Logical processors: {0}' -f $cs.NumberOfLogicalProcessors);
Write-Output ('Total Physical Memory: {0:f2}gb' -f ($cs.TotalPhysicalMemory /1Gb));

$ld = Get-CimInstance -Class Win32_LogicalDisk;
Write-Output ('Disk information {0}' -f ($ld.DeviceID));
Write-Output ('Total Disk Space: {0:f2}gb' -f ($ld.Size /1Gb));
Write-Output ('Available Disk Space: {0:f2}gb' -f ($ld.FreeSpace /1Gb));
Write-Output '';

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

# Setup git
Write-Output ('git config --global core.autocrlf false');
Start-Process -FilePath 'git.exe' -ArgumentList @('config', '--global', 'core.autocrlf', 'false') -Wait -NoNewWindow;

# Clone WebKit repository
if (Test-Path env:WEBKIT_GIT_URL) {
  $gitUrl = $env:WEBKIT_GIT_URL;
} else {
  $gitUrl = Get-WebKitGitUrl;
}

$cloneStdOut = 'git-out.txt';
$cloneStdErr = 'git-err.txt';

Write-Output ('git clone {0} WebKit' -f $gitUrl);
$clone = Start-Process -FilePath 'git.exe' `
  -ArgumentList @('clone', '--verbose', '--progress', $gitUrl, 'WebKit') `
  -RedirectStandardOutput $cloneStdOut `
  -RedirectStandardError $cloneStdErr `
  -NoNewWindow `
  -PassThru `
  -Wait;

# Stop execution if the clone failed
if ($clone.ExitCode -ne 0) {
  Write-Error 'Could not clone repository';
  Get-Content -Path $cloneStdOut -Tail 100 | Write-Error;
  Get-Content -Path $cloneStdErr -Tail 100 | Write-Error;
  exit;
}

Remove-Item $cloneStdOut;
Remove-Item $cloneStdErr;

# Run any additional startup scripts
$scriptPath = Join-Path $PSScriptRoot 'Scripts';

Write-Output ('Looking in {0} for additional startup scripts' -f $scriptPath);

$scripts = @();

if (Test-Path $scriptPath) {
  $scripts = Get-ChildItem -Path $scriptPath -Filter '*.ps1';
}

Write-Output ('{0} scripts found' -f $scripts.Count);

foreach ($script in $scripts) {
  $invocation = '& {0}' -f $script.FullName;
  Write-Output $invocation;
  Invoke-Expression $invocation;
}

# Setup credentials
Set-Location WebKit;

Write-Output ('git config bugzilla.username {0}' -f $env:BUGZILLA_USERNAME);
Start-Process -FilePath 'git.exe' -ArgumentList @('config', 'bugzilla.username', $env:BUGZILLA_USERNAME) -Wait -NoNewWindow;
Write-Output 'git config bugzilla.password ********'
Start-Process -FilePath 'git.exe' -ArgumentList @('config', 'bugzilla.password', $env:BUGZILLA_PASSWORD) -Wait -NoNewWindow;

# Initialize the Visual Studio environment
Write-Output 'Initializing Visual Studio environment';
Initialize-VSEnvironment -Architecture 'amd64' -Path (Get-VSBuildTools2019VCVarsAllPath);

if ($env:COMPILER -eq 'Clang') {
  $compilerExe = 'clang-cl.exe';
} else {
  $compilerExe = 'cl.exe';
}

$compilerPath = (Get-Command $compilerExe).Path;

Write-Output ('Found compiler at {0}' -f $compilerPath);
Initialize-NinjaEnvironment -CC $compilerPath -CXX $compilerPath;

# Start the script
Write-Output 'Starting EWS bot';

& Tools/EWSTools/Start-Queue.ps1 -Queue $env:EWS_QUEUE_NAME -Name $env:EWS_SERVER_NAME -Iterations $env:EWS_ITERATIONS;
