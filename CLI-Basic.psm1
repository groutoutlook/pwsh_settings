# INFO: numbat is a kind of bc in both Windows/Linux. There are also Julia if you want to try.
function bc
{
  Write-Host "Numbat started." -ForegroundColor Red
  if ($args){
    numbat -e "$args"
  }
  else{
  Write-Host "Start shell instead" -ForegroundColor Yellow
    numbat 
  }
}


function omniSearchObsidian
{
  $query = ""
  $args | % {
    $query = $query + "$_%20"
  }
  Start-Process "obsidian://omnisearch?query=$query" &
}

# INFO: `ripgrep`. But with file names and position as output only.
# NOTE: this is because I need that to edit in helix. 
function rgF(
)
{
  $fileNameWithLineNumber = 
  Invoke-Expression("rg $args -o -n") `
  | % {$_ -replace ":(\d+):.*",':$1'}
    
  return $fileNameWithLineNumber
}

# WARN: now new alternative is `ig` since it's in scoop.
function vr(
  
)
{
  ig "$args" 
  # Invoke-Expression("ripgrepFileName $args") `
  # | Sort-object -Unique `
  # | fzf `
  # | ForEach-Object{
  #   :v $_
  # }
}

function rgj(

)
{
  $rgArgs = $args -join " "
  $command = "rg $rgArgs -g '*Journal.md' (zoxide query obs) -M 400 -C1"
  Invoke-Expression $command
  # [`$?` variable](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_automatic_variables?view=powershell-7.4#section-1)
  if($? -eq $false)
  {
    Write-Host "not in those journal.md" -ForegroundColor Magenta
    rg "$($args -join " ")" -g !'*Journal.md' (zoxide query obs) -M 400
    if($? -eq $false)
    {
      Search-DuckDuckGo ($args -join " ") 
      Write-Host "Fall back to other search engine." -ForegroundColor Red
    } else
    {
      Write-Host "In other Files in Vault, not in those journal.md" -ForegroundColor Blue
    }
  }
}

# HACK: rg in vault's other files.
function rgo()
{
  # HACK: lots of dirty trick.
  # echo "$args"
  rg ($args -join " ") -g !'*Journal.md' (zoxide query obs) -M 400 -C1
  # [`$?` variable](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_automatic_variables?view=powershell-7.4#section-1)
}


function vrj(

)
{
  # HACK: query the directory in here.
 
  $rgArgs = $args -join " "
  $command = "ig $rgArgs -g '*Journal.md' (zoxide query obs)"
  Invoke-Expression $command
  # ig "$($args -join " ")" -g '*Journal.md' (zoxide query obs)
  # Invoke-Expression("ripgrepFileName $args -g '*Journal.md' (zoxide query obs)") `
  # | Sort-object -Unique `
  # | fzf `
  # | ForEach-Object{
  #   :v $_
  # }
}

# INFO: yazi quick call.
function yy
{
  $tmp = [System.IO.Path]::GetTempFileName()
  yazi $args --cwd-file="$tmp"
  $cwd = Get-Content -Path $tmp
  if (-not [String]::IsNullOrEmpty($cwd) -and $cwd -ne $PWD.Path)
  {
    Set-Location -Path $cwd
  }
  Remove-Item -Path $tmp
}

Set-Alias -Name ff -Value yy
Set-Alias -Name zz -Value yy

# INFO: mousemaster or something related to mouse controlling
function mousemt
{
  Stop-Process -Name mousemaster*
  ( Start-Sleep -Seconds 2 && mousemaster --configuration-file="$env:usrbinD\mousemaster.properties") &
}

Set-Alias -Name msmt -Value mousemt

# INFO: neko, for the fun of it.
function neko
{
  (neko-windows-amd64 -scale "1.2" -speed "8" -mousepassthrough "true" -quiet "true" &)
}

function mcat
{
  neko && mousemt
}

function Get-PathFromFiles()
{
  [CmdletBinding()]
  param (
    [Parameter(ValueFromPipeline = $true)]
    [string[]]$Strings
  )
  $inputPath = $Strings -join ""
  $isDoubleQuote = $inputPath -match '"' 
  # HACK: since we have cmd and ps1 with differrent style of wrapping path.
  $patternOnQuotes = $isDoubleQuote ? '"([^"]+)"' : "'`([^']+`)'"
  if ($inputPath -match $patternOnQuotes)
  {
    $path = $matches[1]
    return $path
  } else
  {
    Write-Host "isDoubleQuote is $isDoubleQuote"
    Write-Host "invalid string, not contained any kind of filesystem path."
  }
}


# HACK: `lsd` and `ls` to `exa`
# There could be more function at this point though.
function lsd
{
  exa --hyperlink --icons=always $args 
}

Set-Alias -Name ls -Value lsd -Scope Global -Option AllScope
Set-Alias -Name jpa -Value Join-Path -Scope Global -Option AllScope

function zsh
{
  # INFO: Since I set an experimental flag in powershell which evaluate the ~ symbol. No need to cd to ~ anymore.
  wsl $args --cd ~
  # wsl
}
function zo
{
  zoxide query "$($args -join " ")"
}

Set-Alias zq zo
Set-Alias -Name r -Value just -Scope Global -Option AllScope

# INFO: vscode quick open, with line/column number
function ccb{
  $clipboardContent = Get-Clipboard
  $lineNumber=":"+($args -join ":")
  $isPath = Test-Path $clipboardContent
  if($isPath){
    code --goto "$clipboardContent$lineNumber"
  }
  else{
    Write-Error "Not Path, check again."
  }
}

# INFO: same for helix.
function xcb{
  $clipboardContent = Get-Clipboard
  if($args -ne $null) {$lineNumber=":"+($args -join ":")}
  else{ $lineNumber=":1" }
  $isPath = Test-Path $clipboardContent
  if($isPath){
    hx "$clipboardContent$lineNumber"
  }
  else{
    Write-Error "Not Path, check again."
  }
}


function rb {
  just build
}
function rr {
  just run
}

Set-Alias rme remindme
Set-Alias rgr scooter


# INFO: more alias.
Set-Alias -Name top -Value btm


# HACK: hook this into scoop.
Invoke-Expression (&sfsu hook)
