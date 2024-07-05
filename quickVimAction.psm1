


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


# NOTE: neovim trigger function.
function :v
{
  $currentDir = (Get-Location) -replace '\\','\'
  # echo $currentDir
  if($args[$args.Length - 1] -match "^g")# "^gui")
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

# TODO: I am thinking of nesting vim or helix when I'm inside neovim here.
# Since lots of keymap could be collided when I'm inside the terminal, perhap it's a better choice to use editor in editor.

# INFO: Since I'm that lazy, cant type :v ls for sure.
# when not sure which project to jump. Type :vs for sure.

function :vl
{
  :v last "$args"
}

function :vg
{
  :v ls gui
  :v last
}


# INFO: Quick pwsh_profiles session.
# Table first
$sessionMap = @{
  "pw" = "pwsh_settings"
  "nv" = "nvim_dotfiles"
  "ob" = "obsidian"
  "vk" = "vulkan-samples"
  "cs" = "stylish-css"
}
function :vs
{
  if($null -eq $args[0])
  {
    $inputString = "pw"  
  } else
  {
    $inputString = $args[0]
  }
  $processedString = $sessionMap[$inputString]
  
  if($null -eq $inputString)
  {
    Write-Host "What do you want?" -ForegroundColor Yellow
    :v ls "$args"
  } else
  {
    nvim -c "lua require('resession').load `"$processedString`" "
  } 
}

# TODO: one day I will try to make them parse the yaml text instead of this clunky hash table.
$vaultPath = "D:\ProgramDataD\Notes\Obsidian\Vault_2401" 
$tableJournal = @{
  "default" = "$vaultPath\MainJournal.md"
  1688 = "$vaultPath\note_Items\1688Journal.md"
  "taobao" = "$vaultPath\note_Items\TaobaoJournal.md"
  "item" = "$vaultPath\note_Items\OtherItemsJournal.md"
  "asset" = "$vaultPath\note_Items\AssetJournal.md"
  "place" = "$vaultPath\note_Knowledge\note_Places\PlacesJournal.md"
  "work" = "$vaultPath\note_Business\WorkJournal.md"
  "lang" = "$vaultPath\note_algo_lang\0_LongJournal\LangJournal.md"
  "prog" = "$vaultPath\note_algo_lang\0_LongJournal\ProgrammingJournal.md"
  "comp" = "$vaultPath\note_Embedded\ComponentJournal.md"
  "kicad" = "$vaultPath\note_Embedded\note_EDA\EDAJournal.md"
  "eda" = "$vaultPath\note_Embedded\note_EDA\EDAJournal.md"
  "hard" = "$vaultPath\note_Embedded\HardwareJournal.md"
  "hw" = "$vaultPath\note_Embedded\HardwareJournal.md"
  "soft" = "$vaultPath\note_software\0_LongJournal\SoftwareJournal.md"
  "sw" = "$vaultPath\note_software\0_LongJournal\SoftwareJournal.md"
  "acro" = "$vaultPath\note_Knowledge\AcronymJournal.md"
  "vocab" = "$vaultPath\note_Knowledge\VocabJournal.md"
  "flow" = "$vaultPath\note_Business\WorkflowJournal.md"
  "wf" = "$vaultPath\note_Business\WorkflowJournal.md"
  "workflow" = "$vaultPath\note_Business\WorkflowJournal.md"
  "phr" = "$vaultPath\note_Knowledge\PhraseJournal.md"
  "phrase" = "$vaultPath\note_Knowledge\PhraseJournal.md"
  "quote" = "$vaultPath\note_Knowledge\QuoteJournal.md"
  "ev" = "$vaultPath\note_Knowledge\EventJournal.md"
  "event" = "$vaultPath\note_Knowledge\EventJournal.md"
  "math" = "$vaultPath\note_algo_lang\0_LongJournal\STEMJournal.md"
  "physic" = "$vaultPath\note_algo_lang\0_LongJournal\STEMJournal.md"
  "stem" = "$vaultPath\note_algo_lang\0_LongJournal\STEMJournal.md"
  "til" = "$vaultPath\note_algo_lang\0_LongJournal\OtherKnowledgeJournal.md"
  "acc" =  "$vaultPath\note_software\0_LongJournal\AccountJournal.md"
  "web" = "$vaultPath\note_software\0_LongJournal\WebJournal.md"
  "os" = "$vaultPath\note_software\0_LongJournal\OSJournal.md"
  "vid" = "$vaultPath\note_software\note_entertainment\note_discography\VideoJournal.md"
  "music" = "$vaultPath\note_entertainment\note_discography\VideoJournal.md"
  "life" = "$vaultPath\note_algo_lang\0_LongJournal\LifeJournal.md"
  "blog" = "$vaultPath\note_algo_lang\0_LongJournal\ReadAndListenJournal.md"
  "read" = "$vaultPath\note_algo_lang\0_LongJournal\ReadAndListenJournal.md"
  "book" = "$vaultPath\note_algo_lang\0_LongJournal\ReadAndListenJournal.md"
  "new" = "$vaultPath\note_Knowledge\NewsJournal.md"
  "comedy" = "$vaultPath\note_algo_lang\0_LongJournal\WholesomeJournal.md"
  "meme" = "$vaultPath\note_algo_lang\0_LongJournal\WholesomeJournal.md"
  "firm" = "$vaultPath\note_Embedded\FirmwareJournal.md"
  "fw" = "$vaultPath\note_Embedded\FirmwareJournal.md"
}

# NOTE: Obsidian trigger function.
# TODO: might as well implemented workspace open (Advanced)URI and something extreme.
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
      ((Start-Process "obsidian://open?path=$phrase")  &) | Out-Null
    }
  }
}

# INFO: switch workspace.
$workspaceNameTable = @{
  "j" = "Journal-code-eda"
  "jc" = "Journal-code-eda"
  "o" = "Obs-Nvim"
  "on" = "Obs-Nvim"
}
function :ow
{
  $vaultName = "Vault_2401"
  $defaultWorkspace = "Obs-Nvim"

  # Prepare arguments  
  $argument = $args -join " "
  $workspaceName = $workspaceNameTable[$argument] ?? "$defaultWorkspace"
  
  $originalURI = "obsidian://advanced-uri?vault=$vaultName&workspace=$workspaceName" 	
  (Start-Process "$originalURI" &) | Out-Null
}

Set-Alias -Name :o -Value :obsidian
Set-Alias -Name obs -Value :obsidian

$jrnlMainList = @(
  "default", "hw" , "sw", "lang", "prog","eda"
  , "phrase" , "til"
)

$knowledgeJrnlList = @(
  "vocab" , "til", "stem" , "phrase", "wf","life"
)

$businessJrnlList =@(
  ":1688","taobao","work","wf","comp","hw"
)

$placeAndEventJrnlList =@(
  "place","event"
)


$global:JrnlGroup =@{
  "all" = $jrnlMainList
  "prg" = $jrnlMainList
  "idea" = $jrnlMainList
  "busy" = $businessJrnlList
  "wk" =  $businessJrnlList
  "bs" = $businessJrnlList
  "word" = $knowledgeJrnlList
  "know" = $knowledgeJrnlList
  "vc" = $knowledgeJrnlList
  "pl" = $placeAndEventJrnlList
  "plev" = $placeAndEventJrnlList
}

# TODO: make the note taking add the #tag on it. so I could enter the note and start wrting on it right away without adding tag.
function :jrnl
{
  # rerowk list by specify first argument.
  $jrnlList = $null
  $argument = ""
  foreach($keyword in $JrnlGroup.Keys)
  {
    if($args[0] -match $keyword)
    {
      # Default behaviour is display today's written note.
      $jrnlList = $JrnlGroup[$keyword]
    }
  }
  if ($null -ne $jrnlList)
  {
    if ($args.Length -lt 2)
    {
      $argument = "-today"
    } else
    {
      $argument = $args[1..($args.Length - 1)]
    }
  } else
  {
    # casual passing argument. Dont omit anything.
    $argument = $args
  }


  # Rework argument.
  $specialArgumentList = @{
    "^bat" = 1
    "^last" = 2
    "^lt" = 2
    "^tg" = 3
    "^tag" = 3
    "^\d*e" = 4
    "^\d*d" = 5
  }

  foreach( $specialArgument in $specialArgumentList.Keys)
  {
    $argLast = $args[-1]
  
    if($argLast -match $specialArgument)
    {
      $matchValue_argLast = $Matches.0
      $argument = $argument -replace $argLast
      $flagRaise = $specialArgumentList[$specialArgument]
    }
  
    switch ($flagRaise)
    {
      1
      {
        $callBat = 1
      }
      2
      {
        # regex way to match
        $day = (Select-String -InputObject $argLast -pattern "\d*$").Matches.Value ?? 2
        $convertToInt = [int]$day #- [System.Char]"0"
        $fromDate = (Get-Date).AddDays(-$convertToInt)
        $trimDate = Get-Date $fromDate -Format "yyyy/MM/dd"
        $argument += " -from $trimDate"
      }
      3
      {
        echo "TAGGGG Work."
      }
      4
      {
        $matchValue = (Select-String -InputObject $argLast -pattern "^\d*").Matches.Value ?? 2
        $argument += " -$matchValue --edit"
      }
      5
      {
        $matchValue = (Select-String -InputObject $argLast -pattern "^\d*").Matches.Value ?? 2
        $argument += " -$matchValue --delete"
      }
    }
    if($null -ne $flagRaise)
    {
      break
    }
  }


  # execute `jrnl` command. 
  if($jrnlList -eq $null)
  {
    Invoke-Expression "jrnl $argument"
  } else
  {
    if($callBat -eq 1)
    {
      $TempFile = New-TemporaryFile
      foreach($jrnlFile in $jrnlList)
      {
        Write-Output "$jrnlFile notes`n" | Add-Content $TempFile
        Invoke-Expression "jrnl $jrnlFile  $argument" | Add-Content $TempFile
      }
      nvim $TempFile
    } else
    {
      foreach($jrnlFile in $jrnlList)
      {
        # Write-Host "$jrnlFile notes" -ForegroundColor Cyan # -BackgroundColor Red 
        Write-Output "- $jrnlFile notes`n" 

        Invoke-Expression "jrnl $jrnlFile  $argument"
      }
    }
  }

}

function Get-UniqueEntryJrnl
{
  $jrnlYamlPath = "~/.config/jrnl/jrnl.yaml"
  Import-Module powershell-yaml  
  #[System.Collections.ArrayList]$ResultList = @()
  $all_list = @()
  $os_list = (ConvertFrom-Yaml -yaml (get-content -Raw $jrnlYamlPath))
  $initial_keys_list = $os_list.journals.Keys
  $final_dir = $os_list.journals.Values.Values | Sort-Object | Get-Unique
  [System.Collections.ArrayList]$finalDir = $final_Dir
  foreach ($shortName in $initial_keys_list)
  {
    $matchedPath = $os_list.journals[$shortName].Journal
    if ($matchedPath -in $finalDir)
    {
      $finalDir.Remove($matchedPath)
      # WARN: Should be $ResultList, I dont know why it didnt work.
      #  $ResultList.Add($shortName)
      # HACK: Filter the `acc`. This is the worst way possible to filter this out.
      # Should be something else, but later, it work now.
      if ($shortName -ne "acc")
      {$all_list += $shortName
      }
    }
  }
  return $all_list
}

function Test-AllEntryJrnl
{
  # INFO: Each and everyone of them have alias, in case you want to golf,
  # I prefer to KISS.
  Get-UniqueEntryJrnl | ForEach-Object { `
      Write-Host $_ -ForegroundColor Cyan && Invoke-Expression "j $_ -today" } `
  | % {$_  -replace '^(\d{4}-\d{2}-\d{2})', "`n" } | Set-Clipboard
  # | % {$_  -replace '^\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2} (.*)', "`n" } | Set-Clipboard
}

Set-Alias -Name j -Value :jrnl

function jall
{
  :j all 
}

# HighWay function, to add the symlink in the current
# WARN: recently I found symlink affects recursive tools like fzf and fd a lot... 
# Might change that kind of add sy,links everywhere.
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

# What could we note here?
function :g
{
  if($global:symlinkHighWayList -eq $null)
  {
    Import-Module "$HighWay\BatchJob\GitSymLink.psm1" -Scope Global
    Import-Module "$highway\BatchJob\BatchMeasure.psm1" -Scope Global
  }
  if ($null -eq $args[0])
  { 
    gitAll st
  } else
  {

    Invoke-Expression "gitAll $args"
  }
}

# NOTE: Espanso powershell wrapper.
$espansoAlias = @{
  "st" = "status"
  "e" = "editInNvimSession"
}

function :e
{
  $argument = ""
  # Prepare arguments 
  foreach($arg in $args)
  {
    $postProcessArgument = $espansoAlias[$arg] ?? $arg 
    $argument += "$postProcessArgument "
  }

  if ($argument -eq "editInNvimSession ")
  {
    $espansoNvimSession = "espanso"
    nvim -c "lua require('resession').load `"$espansoNvimSession`""
  } else
  {
    Invoke-Expression "espansod $argument"
  }
}


# INFO: Justfile runner. 
# I think its syntax is quite suitable to put it in each of folders. which need tasks to run.
Set-Alias -Name ju -Value just



# INFO: function to switch between applications.
# Right now it's based on the Show-Window function.
function :s
{
  Show-Window "$args"
}
