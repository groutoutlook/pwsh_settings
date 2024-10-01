# INFO: quick open GUI/CLI app.
function goviet()
{
  $fileDir = "$env:ProgramFilesD/GoTiengViet/GoTiengViet.exe"
  Restart-ForceApp -fileDir $fileDir	
}
function pentab()
{
  $fileDir = "$env:ProgramFiles\Pentablet\PenTablet.exe"
  Restart-ForceApp -fileDir $fileDir	
}
function vdhelper()
{
  $fileDir = "${env:ProgramFiles(x86)}\Windows Virtual Desktop Helper\WindowsVirtualDesktopHelper"
  Restart-ForceApp -fileDir $fileDir
}
# INFO: numbat is a kind of bc in both Windows/Linux. There are also Julia if you want to try.
function bc
{
  Write-Host "Numbat started." -ForegroundColor Red
  numbat -e "$args"
}

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
    Write-Host "not in those journal.md" -ForegroundColor Red
    Invoke-Expression("rg $args -g !'*Journal.md' (zoxide query obs) -M 400")
    Write-Host "Again, not in those journal.md" -ForegroundColor Blue
  }
}

function vrj(

)
{
  # HACK: query the directory in here.
  ig $args -g '*Journal.md' (zoxide query obs)
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

function yyd
{
  yy "~/Downloads/"
}
Set-Alias -Name dd -Value yy

function yc
{
  try
  {
    $clipboardExtracted = ((Get-Clipboard) -replace '"',"" )
    $processedPath = (Split-path -Path $clipboardExtracted)
  } catch [System.Management.Automation.ParameterBindingValidationException]
  {
    Write-Error "Clipboard is not a system path."
    $processedPath = "$pwd"
  }
  yy $processedPath
}
Set-Alias -Name dcb -Value ycb



# INFO: mousemaster or something related to mouse controlling
function mousemt
{
  Stop-Process -Name mousemaster*
  ( mousemaster --configuration-file="$env:usrbinD\mousemaster.properties") &
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

# INFO: Zoxide quick action.
function cdd
{
  zi $args
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
function zellij
{
  Invoke-Expression "wsl --cd ~ zellij $args "
}
function task
{
  Invoke-Expression "wsl task $args"
}


# HACK: hook this into scoop.
Invoke-Expression (&sfsu hook)
