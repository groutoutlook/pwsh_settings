
# INFO: it's better to keep stdout/console output.
function clearScrn
{
  [Microsoft.PowerShell.PSConsoleReadLine]::RevertLine()
  [Microsoft.PowerShell.PSConsoleReadLine]::ClearScreen()
}
Set-Alias -Name cls -Value clearScrn -Scope Global -Option AllScope
Set-Alias -Name clear -Value clearScrn -Scope Global -Option AllScope

# INFO: All basic function about other external apps better reside here.
function Restart-ForceApp($fileDir)
{
  $fileName = (Split-Path $fileDir -Leaf) -replace "\.exe$"
  $currentSearchingProcess = (Get-Process -Name $fileName -ErrorAction Ignore)
  if($currentSearchingProcess.Id -eq $null)
  {
    Write-Host "Haven't started the $fileName yet." -ForegroundColor Red
    Start-Process $fileDir
  } else
  {
    Stop-Process -Id $currentSearchingProcess.Id && `
      Start-Sleep -Milliseconds 500 && `
      Start-Process $fileDir
  }
}

# INFO: Show Window based on title.
function Show-Window
{
  param(
    [Parameter(Mandatory)]
    [string] $ProcessName
  )
  $ProcessName = $ProcessName -replace '\.exe$'
  # WARN: This method return the latest windows which have title. many have titles but cant show.
  # IF you want to switch between them, must use different method like powertoys run.
  $procId = (Get-Process -ErrorAction Ignore "*$ProcessName*"
  ).Where({ $_.MainWindowTitle }, 'First').Id

  if (-not $procId)
  { Throw "No $ProcessName process with a non-empty window title found." 
    return 1
  }
  $null = (New-Object -ComObject WScript.Shell).AppActivate($procId)
}
Set-Alias -Name shw -Value Show-Window

# INFO: Copy previous command in history.
# Either index? or some initial. Return best match I supposed.
function cp!(
  [Parameter(Mandatory=$false)]
  [System.Int32]
  [Alias("i")]
  $index = 1
)
{
  $previousCommand = Get-History -Count $index
  Write-Host $previousCommand -ForegroundColor Yellow
  Set-Clipboard $previousCommand
}

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

