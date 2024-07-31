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
# INFO: numbat is a kind of bc in both Windows/Linux.
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
  ( mousemaster --configuration-file="$env:usrbinD\mousemaster.properties") &
}
Set-Alias -Name msmt -Value mousemt

# INFO: neko, for the fun of it.
function neko
{
  (neko-windows-amd64 -scale "1.2" -speed "4" &)
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

