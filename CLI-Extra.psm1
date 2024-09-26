# INFO: Import Completion scripts.
function Import-Completion
{
  $completionsDir = "$env:p7settingDir\completions"
  $listImport = Get-ChildItem $completionsDir
  if($args[0] -eq $null)
  {
    # $importScripts = $listImport.FullName | fzf 
    $importName = $listImport.BaseName | fzf
    . (Join-Path -Path $completionsDir -ChildPath "$importName.ps1")
  } else
  {
    foreach($arg in $args)
    {
      $importName = $arg
      . (Join-Path -Path $completionsDir -ChildPath "$importName.ps1")
    }
  }
}
Set-Alias -Name :cp -Value Import-Completion 


function Get-Playlistmpv(
  [Parameter(Mandatory=$false)]
  [System.String[]]
  [PSDefaultValue(help = "Text/Lines that contain links, hope we can evolve it to file(s)")]
  [Alias("s")]
  $String = @(Get-Clipboard)
)
{
  # HACK: in case we copy a chunk of text with newline.
  $listURI = $string -split "`n",""
  # echo ($listURI).PSobject
  $global:playlistTemp = "$HOME/mpv-playing.txt"
  $conditionPlaylist = Test-Path $global:playlistTemp
  if ($conditionPlaylist)
  {
    Remove-Item $global:playlistTemp -ErrorAction SilentlyContinue -Force
  }
  New-Item $global:playlistTemp
  foreach($junkText in $listURI)
  {
    filterURI $junkText `
    | ForEach-Object {if ($_)
      {
        # (mpv $_ &) | Wait-Job
        "$_`n" >> $global:playlistTemp
      }
    }
  }
  cat $global:playlistTemp
}

# HACK: launch in different pwsh process.
function mpvc(
  [Parameter(
    # Mandatory = $true,
    ValueFromPipeline = $true
  )]
  [System.String[]]
  [Alias("s")]
  $strings = (Get-Clipboard),
	
  [Parameter(Mandatory=$false)]
  [System.Boolean]
  [PSDefaultValue(help = "Text/Lines that contain links, hope we can evolve it to file(s)")]
  [Alias("b")]
  $Background = $true

)
{
  if($Background)
  {
    # HACK: clean up old playlist.

    Get-Playlistmpv ($strings)
    # INFO: supress output from start-job.
    (pwsh -Command "mpv --playlist=`"$global:playlistTemp`"" &) | Out-Null
  } else
  {
    Get-Playlistmpv (Get-Clipboard)
  }
}

# INFO: currently it's 1688 desktop chat client.
function aliim
{ 
  Stop-Process -Name "aliim*"
  if ($args[0] -eq $null)
  {
    Start-Sleep -Seconds 2
    Start-Process "C:\Program Files (x86)\Ali1688Buyer\AliIM.exe"
    Start-Process "C:\Program Files (x86)\AliWangWang\AliIM.exe"
  } elseif ($args[0] -eq "16")
  {
    Start-Sleep -Seconds 2
    Start-Process "C:\Program Files (x86)\Ali1688Buyer\AliIM.exe"
  } elseif ($args[0] -eq "tb")
  {
    Start-Sleep -Seconds 2
    Start-Process "C:\Program Files (x86)\Ali1688Buyer\AliIM.exe"
  } else
  {
    Write-Host "should be nothing" -ForegroundColor Yellow
  }
}
