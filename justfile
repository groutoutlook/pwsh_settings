# Cross platform shebang:

shebang := if os() == 'windows' { 'pwsh.exe' } else { '/usr/bin/env pwsh' }

# Set shell for non-Windows OSs:

set shell := ["pwsh", "-c"]

# Set shell for Windows OSs:

set windows-shell := ["pwsh.exe", "-NoLogo", "-Command"]

# If you have PowerShell Core installed and want to use it,
# use `pwsh.exe` instead of `powershell.exe`

hello:
    Write-Host "Hello, world!" -ForegroundColor Yellow

shebang:
    #!{{ shebang }}
    $PSV = $PSVersionTable.PSVersion | % {"$_" -split "\." }
    $psver = $PSV[0] + "." + $PSV[1]
    if ($PSV[2].Length -lt 4) {
    	$psver += "." + $PSV[2] + " Core"
    } else {
    	$psver += " Desktop"
    }
    echo "PowerShell $psver"
