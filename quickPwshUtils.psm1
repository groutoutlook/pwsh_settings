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

# INFO: quick create hashmap.
function buildIndex
{
  Param( [Object[]]$inputArray, [string]$keyName) 

  $index = @{};
  foreach($row in $inputArray)
  {
    $key = $row.($keyName);
    if($null -eq $key -or $key.Equals([DBNull]::Value) -or $key.Length -eq 0)
    {
      $key = "<empty>"
    }
    $data = $index[$key];
    if ($data -is [System.Collections.Generic.List[PSObject]])
    {
      $data.Add($row)
    } elseif ($data)
    {
      $index[$key] = New-Object -TypeName System.Collections.Generic.List[PSObject]
      $index[$key].Add($data, $row)
    } else
    {
      $index[$key] = $row
    }
  }
  $index
}

# HACK: alias `Measure-Command`
Set-Alias -Name mcm -Value Measure-Command
Set-Alias -Name time -Value Measure-Command

# INFO: URI maniulation
function filterURI
{
  
  $link = $args
  if (($link -match ' *^\[\p{L}') -or ($link -match '^.*-.*\[\p{L}'))
  {
    # Write-Host "Markdown Link" -ForegroundColor Green 
    $processedLink = $link -replace '^-',"" -replace '^ *-.*',"" -replace "`t.*",""
    $markdownName = ($processedLink | Select-String '^.*\[(.*)\]').Matches.Value
    # echo $markdownName
    $processedLink = ($processedLink | Select-String 'http.*').Matches.Value -replace '\)$',""
    # $processedLink = $processedLink -replace '^.*\[(.*)\]\(',"" 
    # $processedLink = $processedLink -replace '\)$',""  
    if ($processedLink -notmatch '^http')
    {
      Write-Host 'Somehow Invalid' -ForegroundColor Red  
      # echo $processedLink
      $processedLink = $null
    }
  } elseif ($link -match '^http')
  {
    Write-Host "Plain link" -ForegroundColor Yellow 
    $processedLink = $link  
  } else
  {
    # Write-Host "What?" -ForegroundColor Red 
    $processedLink = $null
  }
  return  $markdownName +"`n" + $processedLink

}




