shebang := if os() == 'windows' { 'pwsh.exe' } else { '/usr/bin/env pwsh' }
set shell := ["pwsh", "-c"]
set windows-shell := ["pwsh.exe", "-NoLogo", "-Command"]
set dotenv-load := true
# set dotenv-filename	:= ".env"
# set dotenv-required := true
# INFO: if you want to edit the justfile use js -e.

help:
    @just --list -f "{{home_directory()}}/justfile"

default_arg := 'TODO:'
alias td := todo
todo todo=default_arg:
    rg {{todo}} -g '!justfile' -g "!third_party" 

hello:
    @Write-Host "Hello, world!" -ForegroundColor Yellow

placeholder:
    #!{{ shebang }}
    Write-Host "Havent written build task for this repo." -ForegroundColor Red
    if($env:pwsh_env) {Write-Host "$env:pwsh_env"}
    else {Write-Host "Apparently no .env as well" -ForegroundColor Yellow}

# INFO: basic `run` recipe.
alias r := run
default_args := 'args here'
run args=default_args:
    @Write-Host {{default_args}} -ForegroundColor Red


alias b := build
build: placeholder

format: 
    # could be something as `biome format --write`
