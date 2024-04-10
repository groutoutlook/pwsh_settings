


function :q
{
  Stop-Process -id $pid
}
Set-Alias -Name qqq -Value :q


# Quick way to reload profile and turn back to the default pwsh
# There's some other effects, so I may need to dig further I think?
function :t($p7 = 0) 
{
  Push-Location
  $old_dirs = dirs
  $old_pid = $pid
  if($p7 -eq 0)
  {
    pwsh
    Stop-Process -id $old_pid

  } else
  {
    $pushCommand = ""
    foreach ($dir in $old_dirs.Path)
    {
      $pushCommand += "&& Push-Location $dir "
    }
    # echo $pushCommand
    pwsh -Noexit -Command "p7 && p7mod $pushCommand"
    Stop-Process -id $old_pid 
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


function :v
{
  $currentDir = (Get-Location) -replace '\\','\'
  echo $currentDir
  if ($args[0] -eq $null)
  {
    # $args = "."
    nvim "." # -c "lua require('resession')" -c "call feedkeys(`"<leader>..`")"
  } else
  {
    if($args -match "ls")
    {
      nvim $currentDir -c "lua require('resession').load()"
    } else
    {
      nvim $args
    }
  }
   
}

$vaultPath = "D:\ProgramDataD\Notes\Obsidian\Vault_2401" 
$tableJournal = @{
  "default" = "D:\ProgramDataD\Notes\Obsidian\Vault_2401\MainJournal.md"
  1688 = "D:\ProgramDataD\Notes\Obsidian\Vault_2401\1_Markdown\note_Items\1688Journal.md"
  "taobao" = "D:\ProgramDataD\Notes\Obsidian\Vault_2401\1_Markdown\note_Items\TaobaoJournal.md"
  "item" = "D:\ProgramDataD\Notes\Obsidian\Vault_2401\_Markdown\note_Items\OtherItemsJournal.md"
  "asset" = "D:\ProgramDataD\Notes\Obsidian\Vault_2401\1_Markdown\note_Items\AssetJournal.md"
  "place" = "D:\ProgramDataD\Notes\Obsidian\Vault_2401\1_Markdown\note_Knowledge\note_Places\PlacesJournal.md"
  "work" = "D:\ProgramDataD\Notes\Obsidian\Vault_2401\1_Markdown\note_Business\WorkJournal.md"
  "lang" = "D:\ProgramDataD\Notes\Obsidian\Vault_2401\1_Markdown\note_algo_lang\0_LongJournal\LangJournal.md"
  "prog" = "D:\ProgramDataD\Notes\Obsidian\Vault_2401\1_Markdown\note_algo_lang\0_LongJournal\ProgrammingJournal.md"
  "comp" = "D:\ProgramDataD\Notes\Obsidian\Vault_2401\1_Markdown\note_Embedded\ComponentJournal.md"
  "kicad" = "D:\ProgramDataD\Notes\Obsidian\Vault_2401\1_Markdown\note_Embedded\note_EDA\EDAJournal.md"
  "eda" = "D:\ProgramDataD\Notes\Obsidian\Vault_2401\1_Markdown\note_Embedded\note_EDA\EDAJournal.md"
  "hard" = "D:\ProgramDataD\Notes\Obsidian\Vault_2401\1_Markdown\note_Embedded\HardwareJournal.md"
  "hw" = "D:\ProgramDataD\Notes\Obsidian\Vault_2401\1_Markdown\note_Embedded\HardwareJournal.md"
  "soft" = "D:\ProgramDataD\Notes\Obsidian\Vault_2401\1_Markdown\note_software\0_LongJournal\SoftwareJournal.md"
  "sw" = "D:\ProgramDataD\Notes\Obsidian\Vault_2401\1_Markdown\note_software\0_LongJournal\SoftwareJournal.md"
  "acro" = "D:\ProgramDataD\Notes\Obsidian\Vault_2401\1_Markdown\note_Knowledge\AcronymJournal.md"
  "vocab" = "D:\ProgramDataD\Notes\Obsidian\Vault_2401\1_Markdown\note_Knowledge\VocabJournal.md"
  "flow" = "D:\ProgramDataD\Notes\Obsidian\Vault_2401\1_Markdown\note_Business\WorkflowJournal.md"
  "wf" = "D:\ProgramDataD\Notes\Obsidian\Vault_2401\1_Markdown\note_Business\WorkflowJournal.md"
  "workflow" = "D:\ProgramDataD\Notes\Obsidian\Vault_2401\1_Markdown\note_Business\WorkflowJournal.md"
  "phr" = "D:\ProgramDataD\Notes\Obsidian\Vault_2401\1_Markdown\note_Knowledge\PhraseJournal.md"
  "phrase" = "D:\ProgramDataD\Notes\Obsidian\Vault_2401\1_Markdown\note_Knowledge\PhraseJournal.md"
  "obs" = "D:\ProgramDataD\Notes\Obsidian\Vault_2401\1_Markdown\note_software\400002_Obsidian.md"
  "nvim" = "D:\ProgramDataD\Notes\Obsidian\Vault_2401\1_Markdown\note_software\100001_Neovim.md"
}


function :o()
{
  if($args[0] -eq $null)
  {
    Show-Window Obsidian
  } else
  {

    $phrase = $tableJournal[$args[0]]
    if($phrase -ne $null)
    {
      (Start-Process "obsidian://open?path=$phrase") | Out-Null
    } else
    {
      omniSearchObsidian $args | Out-Null
    }
  }
}

Set-Alias -Name j -Value jrnl

# HighWay function, to add the symlink in the current directory.
$global:HighWay = "D:\ProgramDataD\1_AllActiveProject" 
function :hw($dir = $global:HighWay,$HighWaylinkName = "hw",$destinationName = $null,$Remove = $null)
{
  $currentDir = (get-Location)
  $currentDirLeaf = Split-Path -Path $currentDir -Leaf
  if($Remove -ne $null)
  {
    rm "$HighWay/$currentDirLeaf"
    rm "$currentDir/$HighWaylinkName"
  } else
  {
    if((Test-Path "$currentDir/$HighWaylinkName") -eq $false)
    {
      New-Item $HighWaylinkName -ItemType SymbolicLink -Value $dir
    } else
    {
      Write-Host "Symlink $HighWaylinkName Already Exist" -ForegroundColor Green
    }
    Write-Output "$HighWaylinkName" | Add-Content -Path .\.gitignore
    if($destinationName -eq $null)
    {
      $destinationName = $currentDirLeaf
    }
    if((Test-Path "$global:HighWay/$destinationName") -eq $false)
    {
      New-Item "$global:HighWay/$destinationName" -ItemType SymbolicLink -Value $currentDir
    } else
    {
      Write-Host "Symlink $destinationName Already Exist" -ForegroundColor Green
    }
  }  
}



function :ga
{
  if($global:symlinkHighWayList -eq $null)
  {
    Import-Module "$HighWay\BatchJob\GitSymLink.psm1" -Scope Global
  }
  if ($args[0] -eq $null)
  {
    gitAll st
  } else
  {
    gitAll $args
  }
}

