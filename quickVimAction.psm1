


function :q
{
  exit
}



# Quick way to reload profile and turn back to the default pwsh
# There's some other effects, so I may need to dig further I think?
function :t($p7 = 0) 
{
  if($p7 -eq 0)
  {
    pwsh && exit
  } else
  {
    pwsh -Noexit -Command "p7 && p7mod && cd-" && exit
  }
}
# since I want to type them faster. nm is kinda long.
function :a
{
  :t 7
}

function :backup($Verbose = $null)
{
  Import-Module -Name $env:dotfilesRepo\BackupModule.psm1
  Backup-Environment $Verbose && Backup-Extensive $Verbose
}

Set-Alias -Name :bak -Value :backup


function :n($defaultPath = (Get-Location))
{
  nvim $defaultPath
}
Set-Alias -Name :v -Value :n


function :o()
{
  omniSearchObsidian $args
}

