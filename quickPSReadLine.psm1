using namespace System.Console
using namespace System.Management.Automation
using namespace System.Management.Automation.Language

# Shorten the PSConsoleReadLine type reference
$RLModule = [Microsoft.PowerShell.PSConsoleReadLine]
$ggSearchParameters = @{
  Key = 'Ctrl+s'
  BriefDescription = 'Web Search Mode'
  LongDescription = 'Maybe other search function, but who knows.'
  ScriptBlock = {
    param($key, $arg)   # The arguments are ignored in this example

    # GetBufferState gives us the command line (with the cursor position)
    $line = $null
    $cursor = $null
    $RLModule::GetBufferState([ref]$line,
      [ref]$cursor)
    $searchFunction = "Search-DuckDuckGo" 
    $SearchWithQuery = ""
    if ($line -match "[a-z]")
    {
      if($line -match "^scoop")
      {
                
        $SearchWithQuery = "$searchFunction $line; $line"
      } else
      {

        $SearchWithQuery = "$searchFunction $line"
      }

    } else
    {
      $SearchWithQuery = "$searchFunction $(Get-History -Count 1)"
    }
    $RLModule::AddToHistory($line)
    Invoke-Expression $SearchWithQuery
      
  }
}

# Setup for (!s) 
$IterateCommandParameters = @{
  Key = 'Alt+s'
  BriefDescription = 'iterate commands in the current line.'
  LongDescription = 'want to be like alt a'
  ScriptBlock = {
    param($key, $arg)   # The arguments are ignored in this example

    $ast = $null
    $tokens = $null
    $errors = $null
    $cursor = $null
    $RLModule::GetBufferState(
      [ref]$ast, [ref]$tokens, [ref]$errors, [ref]$cursor
    )
    # INFO: filtering with FindAll API.
    # HACK: dont understand the type and member syntaxes at all.read blog then?
    # [Abstract Syntax Tree - powershell.one](https://powershell.one/powershell-internals/parsing-and-tokenization/abstract-syntax-tree)
    
    $asts = $ast.FindAll( {
        $args[0] -is [System.Management.Automation.Language.ExpressionAst] `
          -and $args[0].Parent -is [System.Management.Automation.Language.CommandAst] 
        # -and $args[0].Parent -is [System.Management.Automation.Language.ExpressionAst]
        # -and $args[0].Extent.StartOffset -ne $args[0].Parent.Extent.StartOffset
      }, $true)
  
    if ($asts.Count -eq 0)
    {
      $lastCommand = (Get-History -Count 1).CommandLine
      $RLModule::Replace(0, $ast.Extent.Text.Length, $lastCommand)
      $RLModule::Ding()
      return
    }
    
    $nextAst = $null

    if ($null -ne $arg)
    {
      $nextAst = $asts[$arg - 1]
    } else
    {
      foreach ($ast in $asts)
      {
        if ($ast.Extent.StartOffset -ge $cursor)
        {
          $nextAst = $ast
          break
        }
      } 
        
      if ($null -eq $nextAst)
      {
        $nextAst = $asts[0]
      }
    }

    $startOffsetAdjustment = 0
    $endOffsetAdjustment = 0

    if ($nextAst -is [System.Management.Automation.Language.StringConstantExpressionAst] -and
      $nextAst.StringConstantType -ne [System.Management.Automation.Language.StringConstantType]::BareWord)
    {
      $startOffsetAdjustment = 1
      $endOffsetAdjustment = 2
    }

    # INFO: jump to next symbols
    $RLModule::SetCursorPosition($nextAst.Extent.StartOffset + $startOffsetAdjustment)
    $RLModule::SetMark($null, $null)
    $RLModule::SelectForwardChar($null, ($nextAst.Extent.EndOffset - $nextAst.Extent.StartOffset) - $endOffsetAdjustment)
  }
}

$IterateCommandBackwardParameters = @{
  Key = 'Ctrl+Shift+s'
  BriefDescription = 'iterate commands in the current line.'
  LongDescription = 'want to be like alt a'
  ScriptBlock = {
    param($key, $arg)   # The arguments are ignored in this example

    $ast = $null
    $tokens = $null
    $errors = $null
    $cursor = $null
    $RLModule::GetBufferState(
      [ref]$ast, [ref]$tokens, [ref]$errors, [ref]$cursor
    )
  
    $asts = $ast.FindAll( {
        $args[0] -is [System.Management.Automation.Language.ExpressionAst] `
          -and $args[0].Parent -is [System.Management.Automation.Language.CommandAst] 
      }, $true)
  
    if ($asts.Count -eq 0)
    {
      $RLModule::Ding()
      return
    }
    
    
    $nextAst = $null

    if ($null -ne $arg)
    {
      $nextAst = $asts[$arg - 1]
    } else
    {
      # HACK: reverse the ast?
      foreach ($ast in $asts)
      {
        if ($ast.Extent.StartOffset -ge $cursor)
        {
          $nextAst = $ast
          break
        }
      } 
        
      if ($null -eq $nextAst)
      {
        $nextAst = $asts[-1]
      }
    }

    $startOffsetAdjustment = 0
    $endOffsetAdjustment = 0

    if ($nextAst -is [System.Management.Automation.Language.StringConstantExpressionAst] -and 
      $nextAst.StringConstantType -ne [System.Management.Automation.Language.StringConstantType]::BareWord)
    {
      $startOffsetAdjustment = 1
      $endOffsetAdjustment = 2
    }

    # INFO: jump to next symbols
    $RLModule::SetCursorPosition($nextAst.Extent.StartOffset + $startOffsetAdjustment)
    $RLModule::SetMark($null, $null)
    $RLModule::SelectForwardChar($null, ($nextAst.Extent.EndOffset - $nextAst.Extent.StartOffset) - $endOffsetAdjustment)
  }
}

# Setup for (^O) 
$omniSearchParameters = @{
  Key = 'Ctrl+o'
  BriefDescription = 'Obsidian Mode'
  LongDescription = 'Search Obsidian.'
  ScriptBlock = {
    param($key, $arg)   # The arguments are ignored in this example

    # GetBufferState gives us the command line (with the cursor position)
    $line = $null
    $cursor = $null
    $RLModule::GetBufferState([ref]$line,
      [ref]$cursor)
    $searchFunction = ":obsidian" # omniSearchObsidian
    if ($line -match "[a-z]")
    {
      $SearchWithQuery = "$searchFunction $line"
    } else
    {
      $SearchWithQuery = "$searchFunction $(Get-History -Count 1)"
    }
 
    #Store to history for future use.
    $RLModule::AddToHistory($line)
    $RLModule::CancelLine()
    Invoke-Expression $SearchWithQuery
    # Can InvertLine() here to return empty line.
      
  }
}

# INFO: search character at current word.
# $CharacterSearchParameters = @{
#   Key = 'F4'
#   BriefDescription = 'Character Surfing'
#   LongDescription = 'Surfing char.'
#   ScriptBlock = {
#     param($key, $arg)   # The arguments are ignored in this example
#     #
#     #   $ast = $null
#     #   $tokens = $null
#     #   $errors = $null
#     #   $cursor = $null
#     #   $RLModule::GetBufferState([ref]$ast, [ref]$tokens, [ref]$errors, [ref]$cursor)
#     $line = $null
#     $cursor = $null
#     $RLModule::GetBufferState([ref]$line,
#       [ref]$cursor)
#     # New-Variable -Name consoleKey -type [System.ConsoleKeyInfo]
#     # $consoleKey = "a" -as [System.ConsoleKeyInfo]
#     # HACK: [ConsoleKeyInfo(Char, ConsoleKey, Boolean, Boolean, Boolean) Constructor (System) | Microsoft Learn](https://learn.microsoft.com/en-us/dotnet/api/system.consolekeyinfo.-ctor?view=net-8.0#system-consolekeyinfo-ctor(system-char-system-consolekey-system-boolean-system-boolean-system-boolean))
#     if($cursor -ge ($line.length - 2))
#     {
#       $cursor = 0
#       $conkey = [System.ConsoleKey]::Parse(($line[$cursor]).ToString())
#       $consoleKey = (New-Object -TypeName System.ConsoleKeyInfo -ArgumentList (
#           $line[$cursor], $conkey,$false,$false,$false))
#       $RLModule::SetCursorPosition($cursor)
#       $RLModule::CharacterSearch($consoleKey ,1)
#     } else
#     {
#
#       $conkey = [System.ConsoleKey]::Parse(($line[$cursor]).ToString())
#       $consoleKey = (New-Object -TypeName System.ConsoleKeyInfo -ArgumentList (
#           $line[$cursor], $conkey,$false,$false,$false))
#       $RLModule::CharacterSearch($consoleKey,1)
#     }
#
#   }
# }


$JrnlParameters = @{
  Key = 'Ctrl+j'
  BriefDescription = 'Jrnl edit back?'
  LongDescription = 'draft.'
  ScriptBlock = {
    param($key, $arg)   # The arguments are ignored in this example
    <#
    .SYNOPSIS
    
    .DESCRIPTION

    .PARAMETERS

    .EXAMPLES


    #>
    # GetBufferState gives us the command line (with the cursor position)
    $line = $null
    $cursor = $null
    $RLModule::GetBufferState([ref]$line,
      [ref]$cursor)
    $defaultValue = 4
    $editPattern =  '\d+e$'
    if($line -match "^j +")
    {
      if ($line -match $editPattern)
      {
        # INFO: if there are 
        $defaultValue = 8
        
        $startPosition = $line `
        | Select-String -Pattern  $editPattern `
        | ForEach-Object {$_.Matches}
        if ($startPosition.Index -ne 0)
        {
          $RLModule::Replace($startPosition.Index,$startPosition.Count,"6e")
        } else
        {
          $RLModule::Insert(" $($defaultValue)e ")
        }
      } else
      {
        $RLModule::Insert(" $($defaultValue)e")
      }
    } elseif ($line -eq "j")
    {
      # INFO: most recent jrnl 
      $defaultValue = 6
      $SearchWithQuery = Get-Content -Tail 40 (Get-PSReadlineOption).HistorySavePath `
      | Where-Object {$_ -match '^j +'}
      $SearchWithQuery = $SearchWithQuery[-1] -replace $editPattern,''
      
      $RLModule::Replace(0, $line.Length, "$SearchWithQuery $($defaultValue)e")
    } else
    {

      $finalOptions = $null
      $checkHistory = (Get-History `
      | Sort-Object -Property CommandLine -Unique `
      | Select-Object -ExpandProperty CommandLine `
      | Select-String -Pattern '^j +' )
      if(($checkHistory).Length -lt 2)
      {
        $historySource = (Get-Content -tail 200 (Get-PSReadlineOption).HistorySavePath `
        | Select-String -Pattern '^j +' )
      } else
      {
        $historySource = $checkHistory
      }
      
      $historySource `
    | fzf --query '^j '`
    | ForEach-Object { $finalOptions = $_ + " $($defaultValue)e"}

      $RLModule::RevertLine()
      $RLModule::Insert("$finalOptions")
    }
    $RLModule::AcceptLine()
  }
}



$HistorySearchGlobalParameters = @{
  Key = 'Ctrl+Shift+j'
  BriefDescription = 'Jrnl edit back?'
  LongDescription = 'draft.'
  ScriptBlock = {
    param($key, $arg)   # The arguments are ignored in this example

    # GetBufferState gives us the command line (with the cursor position)
    $line = $null
    $cursor = $null
    $RLModule::GetBufferState([ref]$line,
      [ref]$cursor)
    $finalOptions = $null
    $defaultValue = 8
    

    Get-Content -tail 200 (Get-PSReadlineOption).HistorySavePath `
    | Select-String -Pattern '^j +' `
    | fzf --query '^j ' `
    | ForEach-Object { $finalOptions = $_ + " $($defaultValue)e" }

    $RLModule::Insert("$finalOptions")
    
    $RLModule::AcceptLine()
  }
}


# Custom implementation of the ViEditVisually PSReadLine function.
$openEditorParameters = @{
  Key = 'ctrl+x,ctrl+e' 
  BriefDescription = 'Set-LocationWhere the paste directory.'
  LongDescription = 'Invoke cdwhere with the current directory in the command line'
  ScriptBlock = {
    param($key, $arg)
    $RLModule::ViEditVisually()
  }
}

# $cdHandlerParameters = @{
#   Key = 'Alt+x'
#   BriefDescription = 'Set-LocationWhere the paste directory.'
#   LongDescription = 'Invoke cdwhere with the current directory in the command line'
#   ScriptBlock = {
#     param($key, $arg)   # The arguments are ignored in this example
#
#     # GetBufferState gives us the command line (with the cursor position)
#     $line = $null
#     $cursor = $null
#     $RLModule::GetBufferState([ref]$line,
#       [ref]$cursor)
#     $invokeFunction = "Set-LocationWhere"
#     $Query = "$invokeFunction `'$line`'"
#     #Store to history for future use.
#
#     $RLModule::BeginningOfLine()
#     $RLModule::Insert("$invokeFunction `'")
#     $RLModule::EndOfLine()
#     $RLModule::Insert("`'")
#     # $RLModule::AddToHistory($Query)
#     #Store to history for future use.
#     # Can InvertLine() here to return empty line.
#     $RLModule::AcceptLine()
#       
#   }
# }
#



$rgToNvimParameters = @{
  Key = 'Alt+v'
  BriefDescription = 'open `ig`'
  LongDescription = 'Invoke vr in place of rg.'
  ScriptBlock = {
    param($key, $arg)   # The arguments are ignored in this example

    # GetBufferState gives us the command line (with the cursor position)
    $line = $null
    $cursor = $null
    $RLModule::GetBufferState([ref]$line,
      [ref]$cursor)
    if($line -match '^rg')
    {
      # INFO: Replace could actually increase the length of original strings.
      # So I could be longer than the start.
      $RLModule::Replace(0, 2, "vr")
    } else
    {
      # INFO: check history for the latest match commands
      $SearchWithQuery = Get-History -Count 40 `
      | Sort-Object -Property Id -Descending `
      | Where-Object {$_.CommandLine -match "^rg"}
      | select-object -Index 0 `

      $RLModule::Insert($SearchWithQuery)
      $RLModule::Replace(0, 2, "vr")
    }
    $RLModule::AcceptLine()
      
  }
}


$rgToRggParameters = @{
  Key = 'Ctrl+h'
  BriefDescription = 'replace in `rgr`'
  LongDescription = 'Invoke rgr in place of rg.'
  ScriptBlock = {
    param($key, $arg)   # The arguments are ignored in this example

    # GetBufferState gives us the command line (with the cursor position)
    $line = $null
    $cursor = $null
    $RLModule::GetBufferState([ref]$line,
      [ref]$cursor)
    if($line -match '^rg ')
    {
      # INFO: Replace could actually increase the length of original strings.
      # So I could be longer than the start.
      $RLModule::Replace(0, 2, "rgr")
    } else
    {
      # INFO: check history for the latest match commands
      $SearchWithQuery = Get-History -Count 40 `
      | Sort-Object -Property Id -Descending `
      | Where-Object {$_.CommandLine -match "^rg "}
      | select-object -Index 0 `

      $RLModule::Insert($SearchWithQuery)
      $RLModule::Replace(0, 2, "rgr")
    }
    $RLModule::AcceptLine()
      
  }
}





$quickEscParameters = @{
  Key = 'Ctrl+k'
  BriefDescription = 'Open Kicad'
  LongDescription = 'Reserved key combo. Havent thought of any useful function to use with its'
  ScriptBlock = {
    param($key, $arg)   # The arguments are ignored in this example

    # GetBufferState gives us the command line (with the cursor position)
    $line = $null
    $cursor = $null
    $RLModule::GetBufferState([ref]$line,
      [ref]$cursor)
    #Store to history for future use.
    # Can InvertLine() here to return empty line.
    $RLModule::RevertLine()
      
  }
}

function Invoke-SudoPwsh
{
  sudo pwsh -Command "$args"
}
$sudoRunParameters = @{
  Key = 'Ctrl+shift+x'
  BriefDescription = 'Execute as sudo (in pwsh).'
  LongDescription = 'Call sudo on current command or latest command in history.'
  ScriptBlock =
  {
    param($key, $arg)   # The arguments are ignored in this example

    # GetBufferState gives us the command line (with the cursor position)
    $line = $null
    $cursor = $null
    $RLModule::GetBufferState([ref]$line,
      [ref]$cursor)
    $invokeFunction = "Invoke-SudoPwsh"
    if ($line -match "[a-z]")
    {
      $invokeCommand = "$invokeFunction `"$line`""
    } else
    {
      $invokeCommand = "$invokeFunction `"$(Get-History -Count 1)`""
    }

    # Invoke-Expression $invokeCommand
    
    # HACK: Just revert the line and brute force printing the line again in console.
    # Ugly way but worked.
    $RLModule::RevertLine()
    $RLModule::BeginningOfLine()
    $RLModule::Insert("$invokeCommand")
    $RLModule::AcceptLine()
      
  }
}


# HACK: combine both Bakwardkillword and forwardkillword(alt+D) 
$smartKillWordParameters = @{
  Key = 'Ctrl+w'
  BriefDescription = 'Smarter kill word '
  LongDescription = 'Call sudo on current command or latest command in history.'
  ScriptBlock = {
    param($key, $arg)   # The arguments are ignored in this example

    # GetBufferState gives us the command line (with the cursor position)
    $line = $null
    $cursor = $null
    $RLModule::GetBufferState([ref]$line,
      [ref]$cursor)
     
    #Info 
    if($cursor -eq 0)
    {
      $RLModule::KillWord()
    } else
    {
      $RLModule::BackwardKillWord()
    }
  }
}


## HACK: combine both Bakwardkillword and forwardkillword(alt+D) 
$ExtraKillWordParameters = @{
  Key = 'Ctrl+Backspace'
  BriefDescription = 'Smarter kill word '
  LongDescription = 'Call sudo on current command or latest command in history.'
  ScriptBlock = {
    param($key, $arg)   # The arguments are ignored in this example

    # GetBufferState gives us the command line (with the cursor position)
    $line = $null
    $cursor = $null
    $RLModule::GetBufferState([ref]$line,
      [ref]$cursor)
     
    #Info 
    if($cursor -eq 0)
    {
      $RLModule::KillWord()
    } else
    {
      $RLModule::BackwardKillWord()
    }
  }
}


$ExtraKillWord1Parameters = @{
  Key = 'Alt+w'
  BriefDescription = 'Smarter kill word '
  LongDescription = 'Kill Forward, but hit ceiling then kill backward.'
  ScriptBlock = {
    param($key, $arg)   # The arguments are ignored in this example

    # GetBufferState gives us the command line (with the cursor position)
    $line = $null
    $cursor = $null
    $RLModule::GetBufferState([ref]$line,
      [ref]$cursor)
     
    #Info 
    if($cursor -ge ($line.length - 2))
    {
      $RLModule::BackwardKillWord()
    } else
    {
      $RLModule::KillWord()
    }
  }
}



$MathExpressionParameter = @{
  Key = 'Alt+m'
  BriefDescription = 'parentheses the selection'
  LongDescription = 'As brief.'
  ScriptBlock = {
    param($key, $arg)

    $selectionStart = $null
    $selectionLength = $null
    $RLModule::GetSelectionState([ref]$selectionStart, [ref]$selectionLength)

    $line = $null
    $cursor = $null
    $RLModule::GetBufferState([ref]$line, [ref]$cursor)
    if ($selectionStart -ne -1)
    {
      $RLModule::Replace($selectionStart, $selectionLength, 'bc "' + $line.SubString($selectionStart, $selectionLength) + '"')
      $RLModule::SetCursorPosition($selectionStart + $selectionLength + 2)
    } else
    {
      $RLModule::Replace(0, $line.Length, 'bc "' + $line + '"')
      $RLModule::EndOfLine()
    }
  
  }

}



$ParenthesesParameter = @{
  Key = 'Alt+0'
  BriefDescription = 'parentheses the selection or nearest token'
  LongDescription = 'Wraps selected text in parentheses; if no selection, wraps the token nearest to the cursor. Cursor is placed after the closing parenthesis.'
  ScriptBlock = {
    param($key, $arg)

    $selectionStart = $null
    $selectionLength = $null
    $RLModule::GetSelectionState([ref]$selectionStart, [ref]$selectionLength)

    $ast = $null
    $tokens = $null
    $errors = $null
    $cursor = $null
    $RLModule::GetBufferState([ref]$ast, [ref]$tokens, [ref]$errors, [ref]$cursor)

    # Extract the line text from the AST
    $line = if ($ast.Extent) { $ast.Extent.Text } else { '' }

    if ($selectionStart -ne -1)
    {
      # Wrap selected text in parentheses
      $selectedText = $line.SubString($selectionStart, $selectionLength)
      $RLModule::Replace($selectionStart, $selectionLength, "($selectedText)")
      $RLModule::SetCursorPosition($selectionStart + $selectionLength + 2)
    }
    else
    {
      # Find the token nearest to the cursor
      $nearestToken = $tokens | Where-Object {
        $_.Extent.StartOffset -le $cursor -and $_.Extent.EndOffset -ge $cursor
      } | Select-Object -First 1

      if (-not $nearestToken)
      {
        # If no token is under the cursor, find the closest token
        $nearestToken = $tokens | Sort-Object {
          [Math]::Abs($_.Extent.StartOffset - $cursor)
        } | Select-Object -First 1
      }

      if ($nearestToken -and $nearestToken.Extent.StartOffset -ge 0 -and $nearestToken.Extent.StartOffset -le $line.Length)
      {
        $start = $nearestToken.Extent.StartOffset
        $length = $nearestToken.Extent.EndOffset - $start
        # Ensure length doesn't extend beyond buffer
        if ($start + $length -le $line.Length)
        {
          $text = $nearestToken.Extent.Text
          $RLModule::Replace($start, $length, "($text)")
          $RLModule::SetCursorPosition($start + $length + 1)
        }
        else
        {
          # Fallback: insert () at cursor
          $RLModule::Insert('()')
          $RLModule::SetCursorPosition($cursor + 1)
        }
      }
      else
      {
        # Fallback if no valid tokens are found (e.g., empty line)
        $RLModule::Insert('()')
        $RLModule::SetCursorPosition($cursor + 1)
      }
    }
  }
}



$ParenthesesAllParameter = @{
  Key = 'Alt+9'
  BriefDescription = 'parentheses all or the selection'
  LongDescription = 'Wraps the selected text or the entire line in parentheses.'
  ScriptBlock = {
    param($key, $arg)

    $selectionStart = $null
    $selectionLength = $null
    $RLModule::GetSelectionState([ref]$selectionStart, [ref]$selectionLength)

    $line = $null
    $cursor = $null
    $RLModule::GetBufferState([ref]$line, [ref]$cursor)
    if ($selectionStart -ne -1)
    {
      $selectedText = $line.SubString($selectionStart, $selectionLength)
      $RLModule::Replace($selectionStart, $selectionLength, "($selectedText)")
      $RLModule::SetCursorPosition($selectionStart + $selectionLength + 2)
    }
    else
    {
      $RLModule::Replace(0, $line.Length, "($line)")
      $RLModule::EndOfLine()
    }
  }
}

$WrapPipeParameter = @{
  Key = 'Alt+\'
  BriefDescription = 'wrap in pipe (|%{<selected one> $_})'
  LongDescription = 'As brief.'
  ScriptBlock = {
    param($key, $arg)

    $selectionStart = $null
    $selectionLength = $null
    $RLModule::GetSelectionState([ref]$selectionStart, [ref]$selectionLength)

    $line = $null
    $cursor = $null
    $RLModule::GetBufferState([ref]$line, [ref]$cursor)
    if ($selectionStart -ne -1)
    {
      # Wrap selected text in |%{}
      $selectedText = $line.SubString($selectionStart, $selectionLength)
      $RLModule::Replace($selectionStart, $selectionLength, "|%{$selectedText `$_}")
      $RLModule::SetCursorPosition($selectionStart + $selectionLength + 4)
    }
    else
    {
      # Append |%{} at the end and place cursor between braces
      $RLModule::Replace($line.Length, 0, "|%{ `$_}")
      $RLModule::SetCursorPosition($line.Length + 3)
    }
  }
}

$GlobalEditorSwitch = @{
  Key = 'Ctrl+Shift+e,Ctrl+Shift+e'
  BriefDescription = 'Change $env:nvim_appname to something else'
  LongDescription = 'I think I need to work on changing $env:EDITOR as well.'
  ScriptBlock = {
    param($key, $arg)
    $line = $null
    $cursor = $null
    $RLModule::GetBufferState([ref]$line, [ref]$cursor)
    if ($env:nvim_appname -eq $null){
      Write-Host "`nNow minimal" -NoNewLine
      $RLModule::SetCursorPosition($cursor)
      $env:nvim_appname = "viniv"
      $env:EDITOR = "hx"
    }
    else{
      Write-Host "`nNow complex" -NoNewLine
      $RLModule::SetCursorPosition($cursor)
      $env:nvim_appname = $null
    }
  } 
}

# INFO: switch between windows mode and vi mode. for easier navigation
$OptionsSwitchParameters = @{
  Key = 'Ctrl+x,Ctrl+x'
  BriefDescription = 'toggle vi navigation'
  LongDescription = 'as I mimic the behaviour in zsh'
  ScriptBlock = {
    param($key, $arg)   # The arguments are ignored in this example
    OptionsSwitch 
    setAllHandler
    # HACK: set the ctrl+r and ctrl+t
    MoreTerminalModule
  }
}


# INFO: Start Command Mode commands.
$OptionsSwitch_Command_Parameters = @{
  Key = 'Ctrl+x,Ctrl+x'
  BriefDescription = 'toggle vi navigation in command(normal) mode'
  LongDescription = 'This is only included when in ViMode,in command(normal) mode'
  ViMode  = "Command"
  ScriptBlock = {
    param($key, $arg)  
    OptionsSwitch 
    setAllHandler
    MoreTerminalModule
  }
}

# HACK: Solution [at here as today](https://github.com/PowerShell/PSReadLine/issues/1701#issuecomment-1019386349)
$j_timer = New-Object System.Diagnostics.Stopwatch

$twoKeyEscape_k_Parameters = @{
  Key = 'k'
  BriefDescription = 'jk escape'
  LongDescription = 'This is only included when in ViMode,in command(normal) mode'
  ViMode  = "Insert"
  ScriptBlock = {
    param($key, $arg)   
    if (!$j_timer.IsRunning -or $j_timer.ElapsedMilliseconds -gt 500)
    {
      $RLModule::Insert("k")
    } else
    {
      $RLModule::ViCommandMode()
      $line = $null
      $cursor = $null
      $RLModule::GetBufferState([ref]$line, [ref]$cursor)
      $RLModule::Delete($cursor, 1)
      $RLModule::SetCursorPosition($cursor-1)
    }

  }
}


$twoKeyEscape_j_Parameters = @{
  Key = 'j'
  BriefDescription = 'jk/jj escape'
  LongDescription = 'This is only included when in ViMode,in command(normal) mode'
  ViMode  = "Insert"
  ScriptBlock = {
    param($key, $arg)   
    if (!$j_timer.IsRunning -or $j_timer.ElapsedMilliseconds -gt 500)
    {
      $RLModule::Insert("j")
      $j_timer.Restart()
      return # HACK: return right before anything got executed below.
    }
    
    $RLModule::Insert("j")
    $RLModule::ViCommandMode()

    $line = $null
    $cursor = $null
    $RLModule::GetBufferState([ref]$line, [ref]$cursor)
    $RLModule::Delete($cursor-1, 2)
    $RLModule::SetCursorPosition($cursor-2)
    
  }
}

$ctrlBracket_Parameters = @{
  # HACK: on the key code, using [System.Console]::ReadKey() -> `[` as Oem4.
  Key = 'ctrl+Oem4'
  BriefDescription = 'ctrl+['
  LongDescription = 'This is only included when in ViMode,in command(normal) mode'
  ViMode  = "Insert"
  ScriptBlock = {
    param($key, $arg)   
    $RLModule::ViCommandMode()
  }
}

# INFO: Common Windows/Vi Mode Key handlers
$HandlerParameters = @{
  "ggHandler"   = $ggSearchParameters
  "obsHandler"  = $omniSearchParameters
  "jrnlHandler" = $JrnlParameters 
  "histJSearchHandler" = $HistorySearchGlobalParameters
  "sudoHandler"  = $sudoRunParameters
  "killword" = $smartKillWordParameters
  "extrakillword" = $ExtraKillWordParameters
  "extrakillword1" = $ExtraKillWord1Parameters
  "parentSel" = $ParenthesesParameter
  "parentAll" = $ParenthesesAllParameter
  "wrapPipeSel" = $wrappipeparameter
  "rtnHandler" = $rgToNvimParameters
  "rggHandler" = $rgToRggParameters
  "iterateBackward" = $IterateCommandBackwardParameters
  "iterateForward" = $IterateCommandParameters
  "OptionsSwitch" = $OptionsSwitchParameters
  "openEditor" = $openEditorParameters
  "GlobalEditorSwitch" = $GlobalEditorSwitch
  "MathExpression" = $MathExpressionParameter
}

# INFO: Unique for Vi mode.
$ViHandlerParameters = @{
  "OptionsSwitch_c" = $OptionsSwitch_Command_Parameters
  "two-kj" = $twoKeyEscape_k_Parameters 
  "two-jk" = $twoKeyEscape_j_Parameters 
  "esc-ctrlbracket" = $ctrlBracket_Parameters
}

# INFO: IF you want to go real freaky
# Consider Unique for Emacs mode.

#INFO: Default of Windows PSReadLineOptions
$PSReadLineOptions_Windows = @{
  EditMode = "Windows"
  HistoryNoDuplicates = $true
  HistorySearchCursorMovesToEnd = $true
  PredictionViewStyle = "ListView"

  Colors = @{
    "Command" = "#f9f1a5"
  }
}

$PSReadLineOptions_Vi = @{
  EditMode = "Vi"
  HistoryNoDuplicates = $true
  HistorySearchCursorMovesToEnd = $true
  PredictionViewStyle = "ListView"
  Colors = @{
    "Command" = "#8181f7"
  }
}

function setAllHandler()
{
  # Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete
  # INFO: custom default keyhandler.
  ForEach($handler in $HandlerParameters.Keys)
  {
    $parameters = $HandlerParameters[$handler]
    Set-PSReadLineKeyHandler @parameters
  }

  # INFO: Add Vi Handler.
  $currentMode = (Get-PSReadLineOption).EditMode 
  if ($currentMode -eq "Vi")
  {
    ForEach($handler in $ViHandlerParameters.Keys)
    {
      $parameters = $ViHandlerParameters[$handler]
      Set-PSReadLineKeyHandler @parameters
    }
  }

}

function OptionsSwitch()
{
  $currentMode = (Get-PSReadLineOption).EditMode 
  if ($currentMode -eq "Windows")
  {
    Set-PSReadLineOption @PSReadLineOptions_Vi
    $RLModule::ViCommandMode()
  } else
  {
    Set-PSReadLineOption @PSReadLineOptions_Windows
  }

}

# HACK: preset of the initial settings.
Set-PSReadLineOption @PSReadLineOptions_Windows
setAllHandler
