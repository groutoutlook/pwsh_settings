
# INFO: numbat is a kind of bc in both Windows/Linux. There are also Julia if you want to try.
# function bc
# {
#   Write-Host "Numbat started." -ForegroundColor Red
#   numbat -e "$args"
# }
#
Set-Alias -Name cal -Value Show-Neovide

function omniSearchObsidian
{
  $query = ""
  $args | % {
    $query = $query + "$_%20"
  }
  Start-Process "obsidian://omnisearch?query=$query" &
}


# INFO: `ripgrep`.
function ripgrepFileName(
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
  # HACK: lots of dirty trick.
  # echo "$args"
  rg ($args -join " ") -g '*Journal.md' (zoxide query obs) -M 400 
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

function vrj(

)
{
  # HACK: query the directory in here.
  ig "$($args -join " ")" -g '*Journal.md' (zoxide query obs)
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

# Set-Alias -Name dd -Value yy
Set-Alias -Name zz -Value yy
#
# function ycb
# {
#   try
#   {
#     $clipboardExtracted = ((Get-Clipboard) -replace '"',"" )
#     $processedPath = (Split-path -Path $clipboardExtracted)
#   } catch [System.Management.Automation.ParameterBindingValidationException]
#   {
#     Write-Error "Clipboard is not a system path."
#     $processedPath = "$pwd"
#   }
#   yy $processedPath
# }
# Set-Alias -Name dcb -Value ycb
# Set-Alias -Name zcb -Value ycb
#


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

# # INFO: Zoxide quick action.
# function cdd
# {
#   zi $args
# }

# function jm
# { 
#   jjmp.exe $args | cd 
# }

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

Set-Alias -Name cat -Value mdcat -Scope Global -Option AllScope

function zsh
{
  # INFO: Since I set an experimental flag in powershell which evaluate the ~ symbol. No need to cd to ~ anymore.
  wsl $args --cd ~
  # wsl
}

# INFO: absolute dire need of some program in linux.

# function task
# {
#   Invoke-Expression "wsl task $args"
# }

function zo
{
  zoxide query "$($args -join " ")"
}

Set-Alias zq zo


# HACK: hook this into scoop.
Invoke-Expression (&sfsu hook)
