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
function Show-Window
{
  param(
    [Parameter(Mandatory)]
    [string] $ProcessName
  )
  $ProcessName = $ProcessName -replace '\.exe$'
  # WARN: This method om;y return the latest windows which have title. many which have titles but it's retained...
  # IF you want to truly switch between them, must switch using different method.
  $procId = (Get-Process -ErrorAction Ignore "*$ProcessName*"
  ).Where({ $_.MainWindowTitle }, 'First').Id

  if (-not $procId)
  { Throw "No $ProcessName process with a non-empty window title found." 
    return 1
  }
  $null = (New-Object -ComObject WScript.Shell).AppActivate($procId)
}
function Show-Neovide
{
  Show-Window("Neovide.exe")
}
Set-Alias -Name shw -Value Show-Window
Set-Alias -Name shv -Value Show-Neovide

# INFO: numbat is a kind of bc in both Windows/Linux.
function bc
{
  Write-Host "Numbat started." -ForegroundColor Red
  numbat
}


function omniSearchObsidian
{
  $query = ""
  $args | % {
    $query = $query + "$_%20"
  }
  Start-Process "obsidian://omnisearch?query=$query" &
}



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

# INFO: yazi on the download folders?
function yyd
{
  yy "~/Downloads/"
}
Set-Alias -Name dd -Value yy

function ycb
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



# INFO: Misc files on the terminal.
function clock
{
  tenki --mode meteor --timer-color green --show-fps
}



function cdd
{
  zi $args
}


# HACK: `lsd` and `ls` to `exa`
# There could be more function at this point though.
function lsd
{
  exa --hyperlink $args
}

Set-Alias -Name ls -Value lsd -Scope Global -Option AllScope
