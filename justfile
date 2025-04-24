shebang := if os() == 'windows' { 'pwsh.exe' } else { '/usr/bin/env pwsh' }
set shell := ["pwsh", "-c"]
set windows-shell := ["pwsh.exe", "-NoLogo", "-Command"]
set dotenv-load := true
# INFO: really dont want to meddle with the .env, direnv is also related to this.
# WARN: should have get them in .gitignore.
set dotenv-filename	:= ".env"
# set dotenv-required := true
export JUST_ENV := "just_env" # WARN: this is also a method to export env var. 
help:
    @just --list -f "{{home_directory()}}/justfile"

default_arg := 'TODO:'
alias td := todo
todo todo_arg=default_arg:
    rg {{todo_arg}} -g '!justfile' -g "!third_party" 

hello:
    @Write-Host "Hello, world!" -ForegroundColor Yellow

placeholder args="nothing":
    #!{{ shebang }}
    Write-Host "Havent written build task for this repo." -ForegroundColor Red
    if($env:pwsh_env) {Write-Host "$env:pwsh_env and {{args}} as ``just`` args"}
    else {Write-Host "Apparently no .env as well" -ForegroundColor Yellow}

# INFO: basic `run` recipe.
alias r := run
default_args := 'args here'
run args=default_args:
    @Write-Host {{default_args}} -ForegroundColor Red

build: (placeholder "from build") 


format args="nothing":
    @echo {{ if args == "nothing" {"default_arg"} else { args } }}
    # could be something as `biome format --write`

var_test := "test format"
alias t := test
test *args=var_test: (format args) && (placeholder "'from test'") 
    # also something directly test behaviour.
