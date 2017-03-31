Write-Host 'Buildbot information';
Write-Host ('Name: {0}' -f $env:BUILD_SLAVE_NAME);
Write-Host ('Admin: {0} <{1}>' -f $env:ADMIN_NAME, $env:ADMIN_EMAIL);
Write-Host ('Description: {0}' -f $env:HOST_DESCRIPTION);

# Initialize the Visual Studio environment
Write-Host 'Initializing Visual Studio environment';

Select-VSEnvironment;

# Create the configuration
#
# Remove the password environment variable after configuration
# as buildbot will print the entire environment and leak the
# information.
Write-Host 'Initializing buildbot configuration';
python buildbot.py;

Remove-Item Env:BUILD_SLAVE_PASSWORD;

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
Write-Host 'buildslave start'; buildslave start;
