function :q {
    Stop-Process -Id $pid
}
function :a{
    $old_dirs = Get-Location
    $old_pid = $pid
    if($null -ne $args) {
        $tempdir = zq "$($args -join " ")" 
    }
    if ($old_dirs.Path -ne $HOME) {
        $final_path = $tempdir ?? $old_dirs
        pwsh -Noexit -wd "$final_path" -Command "p7 && p7mod" 
    }
    else {
        pwsh -Noexit -wd "$HOME/hw/obs" -Command "p7 && p7mod" 
    }
    Stop-Process -Id $old_pid 
}
function :m {
    Restart-ModuleList
}
function :backup($Verbose = $null) {
    Import-Module -Name $env:dotfilesRepo\BackupModule.psm1
    Backup-Environment $Verbose && Backup-Extensive $Verbose
}
Set-Alias -Name :bak -Value :backup
# NOTE: neovim trigger function.
function :v {
    if ($args[$args.Length - 1] -match "^g") {
        # "^gui")
        $codeEditor = "neovide --frame none --"
        $args = $args[0..($args.Length - 2)]
    }
    else {
        $codeEditor = "nvim"
    }
  
    $parsedArgs = @($args | ForEach-Object { 
            $_ -split ":", "" -split " ", "" 
        })
    # echo ($parsedArgs).Psobject
    # INFO: check if more than 2 elements and final element is number, then modify.
    # I havent thought of a better deal right now.
    if ($parsedArgs.Count -ge 2 -and $parsedArgs[-1] -match "^\d+") {
        if ($parsedArgs[0] -eq "") {
            $parsedArgs[0] = $null
        }
        $finalIndex = $parsedArgs.Count - 2
        $lineNumber = ($Matches.Values)

        if ($parsedArgs[0] -match "^\p{L}$") {
            $parsedArgs[0] = $parsedArgs[0] + ":" + $parsedArgs[1]
            $parsedArgs[1] = $null
            $processedArgs = `
                "`"$($parsedArgs[0..$finalIndex] -join ' ')`""                              `
                + " +" + "$lineNumber" 
        }
        else {
            $processedArgs = `
                "`"$($parsedArgs[0..$finalIndex] -join ' ')`""                              `
                + " +" + "$lineNumber"
        }
        # echo ($processedArgs).Psobject
    }
    else {
        $processedArgs = $args[0]
    }

    if ($null -eq $processedArgs ) {
        Invoke-Expression "$codeEditor ." # -c "lua require('resession')" -c "call feedkeys(`"<leader>..`")"
    }
    else {
        if ($processedArgs -match "^ls") {
            Invoke-Expression "$codeEditor -c `"lua require('resession').load()`""
        }
        elseif ($processedArgs -match "^last") {
            Invoke-Expression "$codeEditor -c `"lua require('resession').load 'Last Session'`""
        }
        else {
            Invoke-Expression "$codeEditor $processedArgs" # -c "lua require('resession')" -c "call feedkeys(`"<leader>..`")"
        }
    }

}
function :vl {
    :v last "$args"
}

function :vc {
    :v "`"$(Get-Clipboard)`"" $args
}

# INFO: Quick pwsh_profiles session. better checkout [root dir]($env:LOCALAPPDATA\nvim-data\session)
# Fall back to default symlink on highway if it's not the complex `nvim`
$sessionMap = @{
    "pw"  = "pwsh"
    "nv"  = "nvim"
    "nu"  = "nushell"
    "m"   = "mouse"
    "ob"  = "obsidian"
    "es"  = "espanso"
    "vk"  = "vulkan-samples"
    "wts" = "wt_shader"
}
function :vs {
    if ($null -eq $args[0]) {
        $inputString = "pw"  
    }
    else {
        $inputString = $args[0]
    }
    $processedString = $sessionMap[$inputString]
  
    if ($null -eq $processedString) {
        Write-Host "What do you want?" -ForegroundColor Yellow
        :v ls "$args"
    }
    else {
        if ($null -eq $env:nvim_appname) {
            nvim -c "lua require('resession').load `"$processedString`" "
        }
        else {
            Invoke-Expression "$env:EDITOR ~/hw/$processedString"
        }
    } 
}

# TODO: one day I will try to make them parse the yaml text instead of this clunky hash table.
# HACK: As today I could `Get-UniqueEntryJrnl table | Set-Clipboard`
$global:vaultName = "MainVault"
$global:vaultPath = "D://ProgramDataD//Notes//Obsidian//$vaultName"
$JrnlTable = @{
    "graph"    = "$vaultPath//note_algo_lang//journal//GraphicUIJournal.md"
    "gui"      = "$vaultPath//note_algo_lang//journal//GraphicUIJournal.md"
    "money"    = "$vaultPath//note_Business//MoneyJournal.md"
    "etym"     = "$vaultPath//note_Knowledge//journal//PhraseJournal.md"
    "module"   = "$vaultPath//note_Embedded//ChipsetJournal.md"
    "cash"     = "$vaultPath//note_Business//MoneyJournal.md"
    "pers"     = "$vaultPath//note_entertainment//note_interest//PersonalJournal.md"
    "inte"     = "$vaultPath//note_Embedded//ProtocolJournal.md"
    "stm"      = "$vaultPath//note_Embedded//FirmwareJournal.md"
    "self"     = "$vaultPath//note_entertainment//note_interest//PersonalJournal.md"
    "stem"     = "$vaultPath//note_algo_lang//journal//STEMJournal.md"
    "conn"     = "$vaultPath//note_Business//ConnectionJournal.md"
    "qt"       = "$vaultPath//note_Knowledge//journal//QuoteJournal.md"
    "firm"     = "$vaultPath//note_Embedded//FirmwareJournal.md"
    "wf"       = "$vaultPath//note_Business//WorkflowJournal.md"
    "windows"  = "$vaultPath//note_software//journal//OSJournal.md"
    "sw"       = "$vaultPath//note_software//journal//SoftwareJournal.md"
    "cs"       = "$vaultPath//note_algo_lang//journal//CompSciJournal.md"
    "tip"      = "$vaultPath//note_Knowledge//journal//LifeHackJournal.md"
    "wpro"     = "$vaultPath//note_os_web//SDK//WebProgJournal.md"
    "fcad"     = "$vaultPath//note_IDEAndTools//Asset//CAD//CADJournal.md"
    ":3"       = "$vaultPath//note_IDEAndTools//Asset//Art//ArtToolsJournal.md"
    "phrase"   = "$vaultPath//note_Knowledge//journal//PhraseJournal.md"
    "econ"     = "$vaultPath//note_Knowledge//journal//EconomyJournal.md"
    "acro"     = "$vaultPath//note_Knowledge//journal//AcronymJournal.md"
    "wlib"     = "$vaultPath//note_os_web//SDK//WebAPIJournal.md"
    "phr"      = "$vaultPath//note_Knowledge//journal//PhraseJournal.md"
    "draw"     = "$vaultPath//note_IDEAndTools//Asset//Art//ArtToolsJournal.md"
    "work"     = "$vaultPath//note_Business//WorkJournal.md"
    "wire"     = "$vaultPath//note_Embedded//ProtocolJournal.md"
    "mus"      = "$vaultPath//note_entertainment//note_discography//MusicJournal.md"
    "bus"      = "$vaultPath//note_Embedded//ProtocolJournal.md"
    "physic"   = "$vaultPath//note_algo_lang//journal//STEMJournal.md"
    "people"   = "$vaultPath//note_Business//ConnectionJournal.md"
    "ali"      = "$vaultPath//note_Items//1688Journal.md"
    "mech"     = "$vaultPath//note_IDEAndTools//Asset//CAD//CADJournal.md"
    "quote"    = "$vaultPath//note_Knowledge//journal//QuoteJournal.md"
    "three"    = "$vaultPath//note_IDEAndTools//Asset//Art//ArtToolsJournal.md"
    "other"    = "$vaultPath//note_Knowledge//journal//OtherKnowledgeJournal.md"
    "rule"     = "$vaultPath//note_Business//WorkflowJournal.md"
    "os"       = "$vaultPath//note_software//journal//OSJournal.md"
    "wapi"     = "$vaultPath//note_os_web//SDK//WebAPIJournal.md"
    "eco"      = "$vaultPath//note_Knowledge//journal//EconomyJournal.md"
    "hh"       = "$vaultPath//note_Knowledge//journal//WholesomeJournal.md"
    "book"     = "$vaultPath//note_Knowledge//journal//ReadAndListenJournal.md"
    "til"      = "$vaultPath//note_Knowledge//journal//OtherKnowledgeJournal.md"
    "cad3d"    = "$vaultPath//note_IDEAndTools//Asset//CAD//CADJournal.md"
    "workflow" = "$vaultPath//note_Business//WorkflowJournal.md"
    "blog"     = "$vaultPath//note_Knowledge//journal//ReadAndListenJournal.md"
    "kicad"    = "$vaultPath//note_Embedded//note_EDA//EDAJournal.md"
    "video"    = "$vaultPath//note_entertainment//note_discography//VideoJournal.md"
    "viap"     = "$vaultPath//note_Embedded//PCB_Standard//PCBJournal.md"
    "new"      = "$vaultPath//note_Knowledge//journal//NewsJournal.md"
    "blend"    = "$vaultPath//note_IDEAndTools//Asset//Art//ArtToolsJournal.md"
    "linux"    = "$vaultPath//note_software//journal//OSJournal.md"
    "myrule"   = "$vaultPath//note_Business//WorkflowJournal.md"
    "ecad"     = "$vaultPath//note_Embedded//note_EDA//EDAJournal.md"
    "ev"       = "$vaultPath//note_Knowledge//journal//EventJournal.md"
    "music"    = "$vaultPath//note_entertainment//note_discography//MusicJournal.md"
    "idea"     = "$vaultPath//note_Business//IdeaJournal.md"
    "hack"     = "$vaultPath//note_Knowledge//journal//LifeHackJournal.md"
    "news"     = "$vaultPath//note_Knowledge//journal//NewsJournal.md"
    "pcb"      = "$vaultPath//note_Embedded//PCB_Standard//PCBJournal.md"
    "slang"    = "$vaultPath//note_Knowledge//journal//PhraseJournal.md"
    "embed"    = "$vaultPath//note_Embedded//FirmwareJournal.md"
    "art"      = "$vaultPath//note_IDEAndTools//Asset//Art//ArtToolsJournal.md"
    "edit"     = "$vaultPath//note_IDEAndTools//Asset//Art//ArtToolsJournal.md"
    "csci"     = "$vaultPath//note_algo_lang//journal//CompSciJournal.md"
    "acc"      = "$vaultPath//note_Knowledge//secret//AccountJournal.md"
    "meme"     = "$vaultPath//note_Knowledge//journal//WholesomeJournal.md"
    ":1"       = "$vaultPath//note_Items//1688Journal.md"
    "lib"      = "$vaultPath//note_algo_lang//journal//LibraryJournal.md"
    "chip"     = "$vaultPath//note_Embedded//ChipsetJournal.md"
    "style"    = "$vaultPath//note_Business//WorkflowJournal.md"
    "wasm"     = "$vaultPath//note_os_web//SDK//WebProgJournal.md"
    "cad"      = "$vaultPath//note_IDEAndTools//Asset//CAD//CADJournal.md"
    "asset"    = "$vaultPath//note_IDEAndTools//Asset//Art//ArtToolsJournal.md"
    "prog"     = "$vaultPath//note_algo_lang//journal//ProgrammingJournal.md"
    "event"    = "$vaultPath//note_Knowledge//journal//EventJournal.md"
    "ic"       = "$vaultPath//note_Embedded//ChipsetJournal.md"
    "vid"      = "$vaultPath//note_entertainment//note_discography//VideoJournal.md"
    "emb"      = "$vaultPath//note_Embedded//FirmwareJournal.md"
    "taobao"   = "$vaultPath//note_Items//TaobaoJournal.md"
    "vocab"    = "$vaultPath//note_Knowledge//journal//VocabJournal.md"
    "media"    = "$vaultPath//note_Knowledge//journal//NewsJournal.md"
    "come"     = "$vaultPath//note_Knowledge//journal//WholesomeJournal.md"
    "ui"       = "$vaultPath//note_algo_lang//journal//GraphicUIJournal.md"
    "life"     = "$vaultPath//note_Knowledge//journal//LifeJournal.md"
    "fw"       = "$vaultPath//note_Embedded//FirmwareJournal.md"
    "pol"      = "$vaultPath//note_Knowledge//journal//NewsJournal.md"
    "pger"     = "$vaultPath//note_Business//ConnectionJournal.md"
    "hard"     = "$vaultPath//note_Embedded//HardwareJournal.md"
    "grap"     = "$vaultPath//note_algo_lang//journal//GraphicUIJournal.md"
    ":3d"      = "$vaultPath//note_IDEAndTools//Asset//Art//ArtToolsJournal.md"
    "ety"      = "$vaultPath//note_Knowledge//journal//PhraseJournal.md"
    "default"  = "$vaultPath//MainJournal.md"
    "math"     = "$vaultPath//note_algo_lang//journal//STEMJournal.md"
    "prot"     = "$vaultPath//note_Embedded//ProtocolJournal.md"
    "social"   = "$vaultPath//note_Business//ConnectionJournal.md"
    "model"    = "$vaultPath//note_IDEAndTools//Asset//Art//ArtToolsJournal.md"
    "lhack"    = "$vaultPath//note_Knowledge//journal//LifeHackJournal.md"
    "eda"      = "$vaultPath//note_Embedded//note_EDA//EDAJournal.md"
    "psy"      = "$vaultPath//note_Knowledge//journal//LifeJournal.md"
    "per"      = "$vaultPath//note_entertainment//note_interest//PersonalJournal.md"
    ":1688"    = "$vaultPath//note_Items//1688Journal.md"
    "web"      = "$vaultPath//note_software//journal//WebJournal.md"
    "interest" = "$vaultPath//note_entertainment//note_interest//PersonalJournal.md"
    "soc"      = "$vaultPath//note_Embedded//ChipsetJournal.md"
    "wprog"    = "$vaultPath//note_os_web//SDK//WebProgJournal.md"
    "api"      = "$vaultPath//note_algo_lang//journal//LibraryJournal.md"
    "read"     = "$vaultPath//note_Knowledge//journal//ReadAndListenJournal.md"
    "hw"       = "$vaultPath//note_Embedded//HardwareJournal.md"
    "soft"     = "$vaultPath//note_software//journal//SoftwareJournal.md"
    "vc"       = "$vaultPath//note_Knowledge//journal//VocabJournal.md"
    "item"     = "$vaultPath//note_Items//OtherItemsJournal.md"
    "lowsw"    = "$vaultPath//note_Embedded//FirmwareJournal.md"
    "comp"     = "$vaultPath//note_Embedded//ComponentJournal.md"
    "lang"     = "$vaultPath//note_algo_lang//journal//LangJournal.md"
    "pp"       = "$vaultPath//note_Business//ConnectionJournal.md"
    "like"     = "$vaultPath//note_entertainment//note_interest//PersonalJournal.md"
    "ltip"     = "$vaultPath//note_Knowledge//journal//LifeHackJournal.md"
    "freecad"  = "$vaultPath//note_IDEAndTools//Asset//CAD//CADJournal.md"
    "place"    = "$vaultPath//note_Knowledge//journal//PlacesJournal.md"
    "pcba"     = "$vaultPath//note_Embedded//PCB_Standard//PCBJournal.md"
    "html"     = "$vaultPath//note_os_web//SDK//WebProgJournal.md"
    "peo"      = "$vaultPath//note_Business//ConnectionJournal.md"
}

# NOTE: Obsidian trigger function.
# TODO: might as well implemented workspace open (Advanced)URI and something extreme.
function :obsidian(
    [Parameter(Mandatory = $false)]
    [System.String[]]
    [Alias("s")]
    $String
) {
    if ($null -eq $string) {
        Show-Window Obsidian
        return
    }
    else {
        $inputString = $String[0]
        $phrase = $JrnlTable[$inputString]
        if ($phrase -eq $null) {
            # Second chance to match the phrase.
      
            if (($inputString -match "j$") -or ($inputString -match " $")) {
                $clippedPhrase = $inputString -replace " $" -replace "j$" 
                $phrase = $JrnlTable[$clippedPhrase]
            }
        } 

        if ($phrase -eq $null) {
            omniSearchObsidian "$($String -join ' ')" | Out-Null
        }
        else {
      ((Start-Process "obsidian://open?path=$phrase")  &) | Out-Null
        }
    }
}

# INFO: switch workspace.
$workspaceNameTable = @{
    "j"  = "Journal-code-eda"
    "jc" = "Journal-code-eda"
    "o"  = "Obs-Nvim"
    "on" = "Obs-Nvim"
}
function :ow {
    $defaultWorkspace = "Obs-Nvim"

    # Prepare arguments  
    $argument = $args -join " "
    $workspaceName = $workspaceNameTable[$argument] ?? "$defaultWorkspace"
  
    $originalURI = "obsidian://advanced-uri?vault=$global:vaultName&workspace=$workspaceName" 	
  (Start-Process "$originalURI" &) | Out-Null
}

Set-Alias -Name :o -Value :obsidian
Set-Alias -Name :oo -Value obsidian-cli
# TODO: make the note taking add the #tag on it. so I could enter the note and start wrting on it right away without adding tag.
function :jrnl {
    $argument = $args
    $specialArgumentList = @{
        "^\d+$" = 1
        "^last" = 2
        "^lt"   = 2
        "^tg"   = 3
        "^tag"  = 3
        "^\d+e" = 4
        "^\d+d" = 5
    }

    foreach ( $specialArgument in $specialArgumentList.Keys) {
        $argLast = $args[-1]
  
        if ($argLast -match $specialArgument) {
            $matchValue_argLast = $Matches.0
            $argument = $argument -replace $argLast
            $flagRaise = $specialArgumentList[$specialArgument]
        }
  
        switch ($flagRaise) {
            1 {
                $match = (Select-String -InputObject $argLast -Pattern "^\d*")
                $matchValue = $match.Matches.Value
                $argument[-1] = " -$matchValue"
            }
            2 {
                # regex way to match
                $day = (Select-String -InputObject $argLast -Pattern "\d*$").Matches.Value ?? 2
                $convertToInt = [int]$day #- [System.Char]"0"
                $fromDate = (Get-Date).AddDays(-$convertToInt)
                $trimDate = Get-Date $fromDate -Format "yyyy/MM/dd"
                $argument[-1] = " -from $trimDate"
            }
            3 {
                echo "TAGGGG Work."
            }
            4 {
                $match = (Select-String -InputObject $argLast -Pattern "^\d*")
                $matchValue = $match.Matches.Value ?? 2
                $argument[-1] = " -$matchValue --edit"
            }
            5 {
                $match = (Select-String -InputObject $argLast -Pattern "^\d*")
                # echo $match
                $matchValue = $match.Matches.Value ?? 2
                $argument[-1] = " -$matchValue --delete"
            }
        }
        if ($null -ne $flagRaise) {
            break
        }
    }
    Invoke-Expression "jrnl $argument"
}

# INFO: call `Get-UniqueEntryJrnl table` to get current jrnltable list.
function Get-UniqueEntryJrnl {
    $jrnlYamlPath = "~/.config/jrnl/jrnl.yaml"
    # INFO : Import a heavy specialized module here for YAML processing. 
    Import-Module powershell-yaml  
    #[System.Collections.ArrayList]$ResultList = @()
    $all_list = @()
    $os_list = ConvertFrom-Yaml -Yaml (Get-Content -Raw $jrnlYamlPath)
    $initial_keys_list = $os_list.journals.Keys

    # HACK: Convert / or // to \ in journal paths for Windows compatibility
    $final_dir = $os_list.journals.Values.Values | Where-Object { $_ -match "~[\\/]+hw[\\/]+obs[\\/]*" } | ForEach-Object { $_ -replace "~[\\/]+hw[\\/]+obs[\\/]*", "`$vaultPath//" -replace '[\\/]+', '//' }
    # $final_dir = $os_list.journals.Values.Values | Where-Object {$_ -match "~/hw/obs"}
    # INFO: Could also create a hashTable of keys and value here.
    if ($args[0] -match "^table") {
        $myHash = @{}
        $initial_keys_list | ForEach-Object -Begin { $i = 0 } -Process {
            $myHash["`'$_`'"] = "`'$($final_dir[$i])`'"
            $i++
        }
        return $myHash  | ConvertTo-Yaml | % { $_ -replace "'", "" -replace '": "', '"= "' }
    }
  
    $final_dir = $final_dir | Sort-Object | Get-Unique
    [System.Collections.ArrayList]$finalDir = $final_Dir
    foreach ($shortName in $initial_keys_list) {
        $matchedPath = $os_list.journals[$shortName].Journal
        if ($matchedPath -in $finalDir) {
            $finalDir.Remove($matchedPath)
            if ($shortName -ne "acc") {
                $all_list += $shortName
            }
        }
    }
    return $all_list
}

Set-Alias -Name j -Value :jrnl

# WARN: recently I found symlink affects recursive tools like fzf and fd a lot... 
# Might change that kind of add sy,links everywhere.
$global:HighWay = "D:\ProgramDataD\1_AllActiveProject" 
function :hw($destinationName = $null, $HighWaylinkName = "hw", $dir = $global:HighWay, $Remove = $null) {
    $currentDir = (Get-Location)
    $currentDirLeaf = Split-Path -Path $currentDir -Leaf
    if ($Remove -ne $null) {
        rm "$global:HighWay/$currentDirLeaf"
        rm "$currentDir/$HighWaylinkName"
    }
    else {
        # HACK: create highway symlink within $pwd. To be fair, avoid this altogether.
        if ((Test-Path "$currentDir/$HighWaylinkName") -eq $false) {
            # New-Item $HighWaylinkName -ItemType SymbolicLink -Value $dir
            Write-Output "$HighWaylinkName`n" | Add-Content -Path .\.gitignore
        }
        else {
            Write-Host "Symlink $HighWaylinkName Already Exist" -ForegroundColor Green
        }

        # INFO: source of highway.
        if ($destinationName -eq $null) {
            $destinationName = $currentDirLeaf
        }
        if ((Test-Path "$global:HighWay/$destinationName") -eq $false) {
            New-Item "$global:HighWay/$destinationName" -ItemType SymbolicLink -Value $currentDir
            Write-Output "$destinationName`n" | Add-Content -Path "$global:HighWay\.gitignore"
        }
        else {
            Write-Host "Symlink $destinationName Already Exist" -ForegroundColor Green
        }
    }  
}
# NOTE: Espanso powershell wrapper.
$espansoAlias = @{
    "st" = "status"
    "e"  = "editInNvimSession"
}

function :e {
    $argument = ""
    # Prepare arguments 
    foreach ($arg in $args) {
        $postProcessArgument = $espansoAlias[$arg] ?? $arg 
        $argument += "$postProcessArgument "
    }

    if ($argument -eq "editInNvimSession ") {
        $espansoNvimSession = "espanso"
        nvim -c "lua require('resession').load `"$espansoNvimSession`""
    }
    else {
        Invoke-Expression "espansod $argument"
    }
}
# INFO: function to switch between applications. Right now it's based on the Show-Window function.
function :s {
    Show-Window "$args"
}
