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

# INFO: `ripgrep`.
function ripgrepFileName(
  # Parameter help description
  [Parameter(Mandatory=$true)]
  [System.String]
  [Alias("s")]
  $String

)
{
  $fileNameWithLineNumber = (rg "$String" -o -n $args[1..($args.length - 1)]) `
    -replace ":(\d+):.*",":`$1" 
  return $fileNameWithLineNumber
}

function :vr(
  # Parameter help description
  [Parameter(Mandatory=$true)]
  [System.String]
  [Alias("s")]
  $String
)
{
  ripgrepFileName "$String" | fzf | ForEach-Object{
    :v $_
  }
}

Set-Alias -Name rgrep -Value ripgrepFileName



# INFO: Default completion import.
Import-Completion just
