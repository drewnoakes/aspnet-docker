$ErrorActionPreference = 'Stop'

# Functions

function exec($cmd) {
    Write-Host -foregroundcolor Cyan "$(hostname) > $cmd $args"
    & $cmd @args
    if ($LastExitCode -ne 0) {
        fatal 'Command exited with non-zero code'
    }
}

function fatal {
    Write-Error "$args"
    exit 1
}

# Main

gci $PSScriptRoot/*/nanoserver/*/Dockerfile | % {
    $type = $_.Directory.Name
    $version = $_.Directory.Parent.Parent.Name
    $tag = "test/aspnetcore$(if ($type -eq 'sdk') { '-build' } ):${version}-nanoserver"
    exec docker build $(split-path -parent $_) -t $tag
}
