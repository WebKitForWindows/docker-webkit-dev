Write-Host "Adding proxy info if necessary to svn"

if (Test-Path 'env:HTTP_PROXY') {
    $validProxy = $env:HTTP_PROXY -match 'http(s?)://([^:]+):(\d+)'
    if ($validProxy -eq $True) {
        $proxy_host = $Matches.2
        $proxy_port = $Matches.3
        Write-Host "Host: $proxy_host"
        Write-Host "Port: $proxy_port"
        if (-Not (Test-Path "$env:APPDATA/Subversion/servers")) {
            svn --version
        }
        Add-Content "$env:APPDATA/Subversion/servers" "`n[global]`nhttp-proxy-host=$proxy_host`nhttp-proxy-port=$proxy_port`n"
    }
}


