


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
  # echo $currentDir
  if($args[$args.Length - 1] -match "^gui")
  {
    $codeEditor = "neovide --"
  } else
  {
    $codeEditor = "nvim"
  }
  if ($args[0] -eq $null)
  {
    # $args = "."
    Invoke-Expression "$codeEditor ." # -c "lua require('resession')" -c "call feedkeys(`"<leader>..`")"
  } else
  {
    if($args[0] -match "^ls")
    {
      Invoke-Expression "$codeEditor -c `"lua require('resession').load()`""
    } elseif($args[0] -match "^last")
    {
      Invoke-Expression "$codeEditor -c `"lua require('resession').load 'Last Session'`""
    } else
    {
      Invoke-Expression "$codeEditor $args" # -c "lua require('resession')" -c "call feedkeys(`"<leader>..`")"
    }
  }
   
}

# Since I'm that lazy, cant type :v ls for sure.
# when not sure which project to jump. Type :vs for sure.
function :vs
{
  :v ls "$args"
}

function :vl
{
  :v last "$args"
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
  "til" = "1D:\ProgramDataD\Notes\Obsidian\Vault_2401\1_Markdown/note_algo_lang/0_LongJournal/OtherKnowledgeJournal.md"
  "obs" = "D:\ProgramDataD\Notes\Obsidian\Vault_2401\1_Markdown\note_software\400002_Obsidian.md"
  "nvim" = "D:\ProgramDataD\Notes\Obsidian\Vault_2401\1_Markdown\note_software\100001_Neovim.md"
}


function :obsidian()
{
  if($args[0] -eq $null)
  {
    Show-Window Obsidian
  } else
  {
    $inputString = $args[0]
    $phrase = $tableJournal[$inputString]
    if($phrase -eq $null)
    {
      # Second chance to match the phrase.
      
      if(($inputString -match "j$") -or ($inputString -match " $"))
      {
        $clippedPhrase = $inputString -replace " $" -replace "j$" 
        $phrase = $tableJournal[$clippedPhrase]
      }
    } 

    if($phrase -eq $null)
    {
      omniSearchObsidian $args | Out-Null
    } else
    {
      ((Start-Process "obsidian://open?path=$phrase") &) | Out-Null
    }
  }
}

Set-Alias -Name :o -Value :obsidian

$jrnlMainList = @(
  "default", "hw" , "sw", "lang", "prog","eda"
  , "phr" , "vocab" , "til"
)

$otherJrnlList =@(
  ":1688","taobao","work","comp","hw"
)

$JrnlGroup =@{
  "all" = $jrnlMainList
  "prg" = $jrnlMainList
  "idea" = $jrnlMainList
  "busy" = $otherJrnlList
  "wk" = $otherJrnlList #work, short like that since we need to parse through some of those jrnl notes.
  "bs" = $otherJrnlList #busy, same as above.
}

function :j
{
  # Loop to find correct word that match the list. If not, branch out to execute normal commands.
  $jrnlList = $null
  foreach($keyword in $JrnlGroup.Keys)
  {
    if($args[0] -match $keyword)
    {
      # Default behaviour is display today's written note.
      if ($args.Length -lt 2)
      {
        $argument = "-today"
      } else
      {
        $argument = $args[1..($args.Length - 1)]
      }
      $jrnlList = $JrnlGroup[$keyword]
    }
  }

  if($jrnlList -eq $null)
  {
    jrnl $args
    # break
  } else
  {
    foreach($jrnlFile in $jrnlList)
    {
      Write-Host $jrnlFile -ForegroundColor Cyan # -BackgroundColor Red 
      Invoke-Expression "jrnl $jrnlFile  $argument"
    }
  }
}

Set-Alias -Name j -Value :j

function jall
{
  :j all 
}

# HighWay function, to add the symlink in the current directory.
$global:HighWay = "D:\ProgramDataD\1_AllActiveProject" 
function :hw($destinationName=$null,$HighWaylinkName = "hw",$dir = $global:HighWay,$Remove = $null)
{
  $currentDir = (get-Location)
  $currentDirLeaf = Split-Path -Path $currentDir -Leaf
  if($Remove -ne $null)
  {
    rm "$global:HighWay/$currentDirLeaf"
    rm "$currentDir/$HighWaylinkName"
  } else
  {
    if((Test-Path "$currentDir/$HighWaylinkName") -eq $false)
    {
      New-Item $HighWaylinkName -ItemType SymbolicLink -Value $dir
      Write-Output "$HighWaylinkName`n" | Add-Content -Path .\.gitignore
    } else
    {
      Write-Host "Symlink $HighWaylinkName Already Exist" -ForegroundColor Green
    }
    if($destinationName -eq $null)
    {
      $destinationName = $currentDirLeaf
    }
    if((Test-Path "$global:HighWay/$destinationName") -eq $false)
    {
      New-Item "$global:HighWay/$destinationName" -ItemType SymbolicLink -Value $currentDir
      Write-Output "$destinationName`n" | Add-Content -Path "$global:HighWay\.gitignore"
    } else
    {
      Write-Host "Symlink $destinationName Already Exist" -ForegroundColor Green
    }
  }  
}



function :g([string]$commands)
{
  if($global:symlinkHighWayList -eq $null)
  {
    Import-Module "$HighWay\BatchJob\GitSymLink.psm1" -Scope Global
    Import-Module "$highway\BatchJob\BatchMeasure.psm1" -Scope Global
  }
  if ($commands -eq '')
  {
    gitAll st
  } else
  {
    gitAll $commands
  }
}

