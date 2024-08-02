# Cross platform shebang:
shebang := if os() == 'windows' { 'pwsh.exe' } else { '/usr/bin/env pwsh' }

# Set shell for non-Windows OSs:
set shell := ["pwsh", "-c"]

# Set shell for Windows OSs:
set windows-shell := ["pwsh.exe", "-NoLogo", "-Command"]

# control whether or not to load dotenv. 
set dotenv-load := true
# set dotenv-filename	:= ".env"
# set dotenv-required := true

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

placeholder:
    #!{{ shebang }}
    Write-Host "Havent written build task for this repo." -ForegroundColor Red
    if($env:pwsh_env) {Write-Host "$env:pwsh_env"}
    else {Write-Host "Apparently no .env as well" -ForegroundColor Yellow}

alias j := editjust
editjust:
    nvim ./justfile

alias b := build
build: placeholder
