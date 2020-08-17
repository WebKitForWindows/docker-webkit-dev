Write-Host "If requested, preload webkit svn"

if (Test-Path 'env:SVN_PRELOAD') {
    $count = 0

    Write-Host "Preloading webkit svn to $env:SVN_PRELOAD"
    svn checkout --non-interactive --no-auth-cache `
        https://svn.webkit.org/repository/webkit/trunk `
        $env:SVN_PRELOAD/build
    while ($LASTEXITCODE -and $count -lt 10) {
        $count = $count + 1
        Write-Host "Failed checkout, $count"
        pushd $env:SVN_PRELOAD/build
        svn cleanup
        popd
        svn checkout --non-interactive --no-auth-cache `
             https://svn.webkit.org/repository/webkit/trunk `
             $env:SVN_PRELOAD/build
    }

    if ($LASTEXITCODE) {
        Write-Host "Failed to update in 10 tries"
    }
    else {
        "https://svn.webkit.org/repository/webkit/trunk" | `
            out-file -encoding ASCII `
            "$env:SVN_PRELOAD/.buildbot-sourcedata-YnVpbGQ="
    }
}

