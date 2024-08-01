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
  [Parameter(Mandatory=$true)]
  [System.String[]]
  [Alias("s")]
  $String,
  
  [Parameter(Mandatory=$false)]
  [System.String]
  [Alias("d")]
  $Dir = "."

)
{
  $fileNameWithLineNumber = (rg "$String" -o -n $Dir) `
    -replace ":(\d+):.*",":`$1" 
  return $fileNameWithLineNumber
}

function :vr(
  # Parameter help description
  [Parameter(Mandatory=$true)]
  [System.String[]]
  [Alias("s")]
  $String
)
{
  ripgrepFileName "$String" `
  | fzf `
  | ForEach-Object{
    :v $_
  }
}

function :vrj(
  # Parameter help description
  [Parameter(Mandatory=$true)]
  [System.String[]]
  [Alias("s")]
  $String
)
{
  # HACK: query the directory in here.
  ripgrepFileName "$String" -Dir (zoxide query obs) `
  | fzf `
  | ForEach-Object{
    :v $_
  }
}



function rgj(
  # Parameter help description
  [Parameter(Mandatory=$true)]
  [System.String[]]
  [Alias("s")]
  $String
)
{
  # HACK: lots of dirty trick.
  # echo "$args"
  rg "$String" -g "*Journal.md" (zoxide query obs) 
}


function rgjn(
  # Parameter help description
  [Parameter(Mandatory=$true)]
  [System.String[]]
  [Alias("s")]
  $String
)
{
  # HACK: lots of dirty trick.
  # echo "$args"
  rg "$String" -g !"*Journal.md" (zoxide query obs)
}


Set-Alias -Name rgrep -Value ripgrepFileName



# INFO: Default completion import.
# Import-Completion just
