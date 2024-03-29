


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


function :v()
{
  if ($args[0] -eq $null)
  {
    $args = "."
  } else
  {
  }
  nvim $args
}

$tableJournal = @{
  "default" = "Journal.md"
  1688 = "1_Markdown\note_Items\1688Journal.md"
  "taobao" = "1_Markdown\note_Items\TaobaoJournal.md"
  "item" = "_Markdown\note_Items\OtherItemsJournal.md"
  "asset" = "1_Markdown\note_Items\AssetJournal.md"
  "place" = "1_Markdown\note_Knowledge\note_Places\PlacesJournal.md"
  "work" = "1_Markdown\note_Business\WorkJournal.md"
  "lang" = "1_Markdown\note_algo_lang\0_LongJournal\LangJournal.md"
  "prog" = "1_Markdown\note_algo_lang\0_LongJournal\ProgrammingJournal.md"
  "comp" = "1_Markdown\note_Embedded\ComponentJournal.md"
  "kicad" = "1_Markdown\note_Embedded\note_EDA\EDAJournal.md"
  "eda" = "1_Markdown\note_Embedded\note_EDA\EDAJournal.md"
  "hard" = "1_Markdown\note_Embedded\HardwareJournal.md"
  "hw" = "1_Markdown\note_Embedded\HardwareJournal.md"
  "soft" = "1_Markdown\note_software\0_LongJournal\SoftwareJournal.md"
  "sw" = "1_Markdown\note_software\0_LongJournal\SoftwareJournal.md"
  "acro" = "1_Markdown\note_Knowledge\AcronymJournal.md"
  "vocab" = "1_Markdown\note_Knowledge\VocabJournal.md"
  "flow" = "1_Markdown\note_Business\WorkflowJournal.md"
  "wf" = "1_Markdown\note_Business\WorkflowJournal.md"
  "workflow" = "1_Markdown\note_Business\WorkflowJournal.md"
  "phr" = "1_Markdown\note_Knowledge\PhraseJournal.md"
  "phrase" = "1_Markdown\note_Knowledge\PhraseJournal.md"
  "nvim" = "1_Markdown\note_software\100001_Neovim.md"
  "obs" = "1_Markdown\note_software\400002_Obsidian.md"
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
      (Start-Process "obsidian://open?vault=Vault_2401&path=$phrase") | Out-Null
    } else
    {
      omniSearchObsidian $args | Out-Null
    }
  }
}


