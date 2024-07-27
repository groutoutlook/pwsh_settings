using namespace System.Management.Automation
using namespace System.Management.Automation.Language

# Setup for (^S)
# Substitute the fwd_i_search.
# (https://stackoverflow.com/a/76991018/22954711)
$ggSearchParameters = @{
  Key = 'Ctrl+s'
  BriefDescription = 'Google Mode'
  LongDescription = 'Maybe other search function, but who knows.'
  ScriptBlock = {
    param($key, $arg)   # The arguments are ignored in this example

    # GetBufferState gives us the command line (with the cursor position)
    $line = $null
    $cursor = $null
    [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line,
      [ref]$cursor)
    $searchFunction = "Search-Google"
    if ($line -match "[a-z]")
    {
      $SearchWithQuery = "$searchFunction $line"
    } else
    {
      $SearchWithQuery = "$searchFunction $(Get-History -Count 1)"
    }
    #Store to history for future use.
    [Microsoft.PowerShell.PSConsoleReadLine]::AddToHistory($line)
    Invoke-Expression $SearchWithQuery
    # Can InvertLine() here to return empty line.
    # [Microsoft.PowerShell.PSConsoleReadLine]::BeginningOfLine()
    # Rather than that, I put the cursor at the end instead.
      
  }
}

$ggSearch_1_Parameters = @{
  Key = 'Ctrl+g'
  BriefDescription = 'Google Mode'
  LongDescription = 'Maybe other search function, but who knows.'
  ScriptBlock = {
    param($key, $arg)   # The arguments are ignored in this example

    # GetBufferState gives us the command line (with the cursor position)
    $line = $null
    $cursor = $null
    [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line,
      [ref]$cursor)
    $searchFunction = "Search-Google"
    if ($line -match "[a-z]")
    {
      $SearchWithQuery = "$searchFunction $line"
    } else
    {
      $SearchWithQuery = "$searchFunction $(Get-History -Count 1)"
    }
    #Store to history for future use.
    [Microsoft.PowerShell.PSConsoleReadLine]::AddToHistory($line)
    Invoke-Expression $SearchWithQuery
    # Can InvertLine() here to return empty line.
    # [Microsoft.PowerShell.PSConsoleReadLine]::BeginningOfLine()
    # Rather than that, I put the cursor at the end instead.
      
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
    [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState(
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
      [Microsoft.PowerShell.PSConsoleReadLine]::Ding()
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
    [Microsoft.PowerShell.PSConsoleReadLine]::SetCursorPosition($nextAst.Extent.StartOffset + $startOffsetAdjustment)
    [Microsoft.PowerShell.PSConsoleReadLine]::SetMark($null, $null)
    [Microsoft.PowerShell.PSConsoleReadLine]::SelectForwardChar($null, ($nextAst.Extent.EndOffset - $nextAst.Extent.StartOffset) - $endOffsetAdjustment)
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
    [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line,
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
    [Microsoft.PowerShell.PSConsoleReadLine]::AddToHistory($line)
    Invoke-Expression $SearchWithQuery
    # Can InvertLine() here to return empty line.
    [Microsoft.PowerShell.PSConsoleReadLine]::InvertLine()
      
  }
}

$omniSearchParameters = @{
  Key = 'Ctrl+j'
  BriefDescription = 'Jrnl edit back?'
  LongDescription = 'draft.'
  ScriptBlock = {
    param($key, $arg)   # The arguments are ignored in this example

    # GetBufferState gives us the command line (with the cursor position)
    $line = $null
    $cursor = $null
    [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line,
      [ref]$cursor)
    if($line -match "^j +")
    {

      [Microsoft.PowerShell.PSConsoleReadLine]::Insert(" 4e")
    } else
    {

      $finalOptions = $null
      Get-History | Sort-Object -Property CommandLine -Unique | `
          Select-Object -Property CommandLine | fzf --query '^j '| `
          ForEach-Object { $finalOptions = $_ + " 4e"}
      [Microsoft.PowerShell.PSConsoleReadLine]::Insert("$finalOptions")
      # [Microsoft.PowerShell.PSConsoleReadLine]::Replace(0, $line.Length, '(' + $line + ')')
    }
    [Microsoft.PowerShell.PSConsoleReadLine]::AcceptLine()
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
    [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line,
      [ref]$cursor)
    $finalOptions = $null
    if($line -match "^j +")
    {

      [Microsoft.PowerShell.PSConsoleReadLine]::Insert(" 4e")
    } else
    {


      Get-Content -tail 100 (Get-PSReadlineOption).HistorySavePath | `
          Select-String -Pattern '^j' | fzf --query '^j ' | `
          ForEach-Object { $finalOptions = $_ + " 4e" }

      [Microsoft.PowerShell.PSConsoleReadLine]::Insert("$finalOptions")
      # [Microsoft.PowerShell.PSConsoleReadLine]::AddToHistory($line)
      # [Microsoft.PowerShell.PSConsoleReadLine]::Replace(0, $line.Length, '(' + $line + ')')
    }
    [Microsoft.PowerShell.PSConsoleReadLine]::AcceptLine()
  }
}


# Custom implementation of the ViEditVisually PSReadLine function.
Set-PSReadLineKeyHandler -Chord 'Alt+e' -Function ViEditVisually

$cdHandlerParameters = @{
  Key = 'Alt+x'
  BriefDescription = 'Set-LocationWhere the paste directory.'
  LongDescription = 'Invoke cdwhere with the current directory in the command line'
  ScriptBlock = {
    param($key, $arg)   # The arguments are ignored in this example

    # GetBufferState gives us the command line (with the cursor position)
    $line = $null
    $cursor = $null
    [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line,
      [ref]$cursor)
    $invokeFunction = "Set-LocationWhere"
    $Query = "$invokeFunction `'$line`'"
    #Store to history for future use.

    [Microsoft.PowerShell.PSConsoleReadLine]::BeginningOfLine()
    [Microsoft.PowerShell.PSConsoleReadLine]::Insert("$invokeFunction (")
    [Microsoft.PowerShell.PSConsoleReadLine]::EndOfLine()
    [Microsoft.PowerShell.PSConsoleReadLine]::Insert(")")
    # [Microsoft.PowerShell.PSConsoleReadLine]::AddToHistory($Query)
    #Store to history for future use.
    # Can InvertLine() here to return empty line.
    [Microsoft.PowerShell.PSConsoleReadLine]::AcceptLine()
      
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
    [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line,
      [ref]$cursor)
    #Store to history for future use.
    # Can InvertLine() here to return empty line.
    [Microsoft.PowerShell.PSConsoleReadLine]::RevertLine()
      
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
    [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line,
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
    [Microsoft.PowerShell.PSConsoleReadLine]::RevertLine()
    [Microsoft.PowerShell.PSConsoleReadLine]::BeginningOfLine()
    [Microsoft.PowerShell.PSConsoleReadLine]::Insert("$invokeCommand")
    [Microsoft.PowerShell.PSConsoleReadLine]::AcceptLine()
      
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
    [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line,
      [ref]$cursor)
     
    #Info 
    if($cursor -eq 0)
    {
      [Microsoft.PowerShell.PSConsoleReadLine]::KillWord()
    } else
    {
      [Microsoft.PowerShell.PSConsoleReadLine]::BackwardKillWord()
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
    [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line,
      [ref]$cursor)
     
    #Info 
    if($cursor -eq 0)
    {
      [Microsoft.PowerShell.PSConsoleReadLine]::KillWord()
    } else
    {
      [Microsoft.PowerShell.PSConsoleReadLine]::BackwardKillWord()
    }
  }
}


$ExtraKillWord1Parameters = @{
  Key = 'Alt+Backspace'
  BriefDescription = 'Smarter kill word '
  LongDescription = 'Call sudo on current command or latest command in history.'
  ScriptBlock = {
    param($key, $arg)   # The arguments are ignored in this example

    # GetBufferState gives us the command line (with the cursor position)
    $line = $null
    $cursor = $null
    [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line,
      [ref]$cursor)
     
    #Info 
    if($cursor -eq 0)
    {
      [Microsoft.PowerShell.PSConsoleReadLine]::KillWord()
    } else
    {
      [Microsoft.PowerShell.PSConsoleReadLine]::BackwardKillWord()
    }
  }
}






# # INFO: yank word. The latest killed one.
# # Currently therer is no way to access a list  of tjust killed words.
# $YankWordParameters = @{
#   Key = 'Ctrl+q'
#   BriefDescription = 'Yank word pararmeter'
#   LongDescription = 'yank word that we just kill, it is currently limited to the latest in ring.'
#   ScriptBlock = {
#     param($key, $arg)   # The arguments are ignored in this example
#
#     # GetBufferState gives us the command line (with the cursor position)
#     $line = $null
#     $cursor = $null
#     [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line,
#       [ref]$cursor)
#      
#     [Microsoft.PowerShell.PSConsoleReadLine]::Yank()
#   }
# }

# INFO: Self-made function.
$HandlerParameters = @{
  "ggHandler"   = $ggSearchParameters
  "gg1Handler"   = $ggSearch_1_Parameters
  "ItCmHandler"   = $IterateCommandParameters
  "obsHandler"  = $omniSearchParameters
  "histJSearchHandler"= $HistorySearchGlobalParameters
  "cdHandler"  = $cdHandlerParameters
  "escHandler"  = $quickEscParameters
  "sudoHandler"  = $sudoRunParameters
  "killword" = $smartKillWordParameters
  "extrakillword" = $ExtraKillWordParameters
  "extrakillword1" = $ExtraKillWord1Parameters
  # "yankword" = $YankWordParameters
}
ForEach($handler in $HandlerParameters.Keys)
{
  $parameters = $HandlerParameters[$handler]
  Set-PSReadLineKeyHandler @parameters
}



# Sometimes you want to get a property of invoke a member on what you've entered so far
# but you need parens to do that.  This binding will help by putting parens around the current selection,
# or if nothing is selected, the whole line.
# $ original is alt+(
Set-PSReadLineKeyHandler -Key 'Alt+9' `
  -BriefDescription ParenthesizeSelection `
  -LongDescription "Put parenthesis around the selection or entire line and move the cursor to after the closing parenthesis" `
  -ScriptBlock {
  param($key, $arg)

  $selectionStart = $null
  $selectionLength = $null
  [Microsoft.PowerShell.PSConsoleReadLine]::GetSelectionState([ref]$selectionStart, [ref]$selectionLength)

  $line = $null
  $cursor = $null
  [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)
  if ($selectionStart -ne -1)
  {
    [Microsoft.PowerShell.PSConsoleReadLine]::Replace($selectionStart, $selectionLength, '(' + $line.SubString($selectionStart, $selectionLength) + ')')
    [Microsoft.PowerShell.PSConsoleReadLine]::SetCursorPosition($selectionStart + $selectionLength + 2)
  } else
  {
    [Microsoft.PowerShell.PSConsoleReadLine]::Replace(0, $line.Length, '(' + $line + ')')
    [Microsoft.PowerShell.PSConsoleReadLine]::EndOfLine()
  }
}

# This example will replace any aliases on the command line with the resolved commands.
# Original is alt+%
Set-PSReadLineKeyHandler -Key "Alt+5" `
  -BriefDescription ExpandAliases `
  -LongDescription "Replace all aliases with the full command" `
  -ScriptBlock {
  param($key, $arg)

  $ast = $null
  $tokens = $null
  $errors = $null
  $cursor = $null
  [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$ast, [ref]$tokens, [ref]$errors, [ref]$cursor)

  $startAdjustment = 0
  foreach ($token in $tokens)
  {
    if ($token.TokenFlags -band [TokenFlags]::CommandName)
    {
      $alias = $ExecutionContext.InvokeCommand.GetCommand($token.Extent.Text, 'Alias')
      if ($alias -ne $null)
      {
        $resolvedCommand = $alias.ResolvedCommandName
        if ($resolvedCommand -ne $null)
        {
          $extent = $token.Extent
          $length = $extent.EndOffset - $extent.StartOffset
          [Microsoft.PowerShell.PSConsoleReadLine]::Replace(
            $extent.StartOffset + $startAdjustment,
            $length,
            $resolvedCommand)

          # Our copy of the tokens won't have been updated, so we need to
          # adjust by the difference in length
          $startAdjustment += ($resolvedCommand.Length - $length)
        }
      }
    }
  }

}


# Cycle through arguments on current line and select the text. This makes it easier to quickly change the argument if re-running a previously run command from the history
# or if using a psreadline predictor. You can also use a digit argument to specify which argument you want to select, i.e. Alt+1, Alt+a selects the first argument
# on the command line.
Set-PSReadLineKeyHandler -Key Alt+a `
  -BriefDescription SelectCommandArguments `
  -LongDescription "Set current selection to next command argument in the command line. Use of digit argument selects argument by position" `
  -ScriptBlock {
  param($key, $arg)
  
  $ast = $null
  $cursor = $null
  [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$ast, [ref]$null, [ref]$null, [ref]$cursor)
  
  $asts = $ast.FindAll( {
      $args[0] -is [System.Management.Automation.Language.ExpressionAst] -and
      $args[0].Parent -is [System.Management.Automation.Language.CommandAst] -and
      $args[0].Extent.StartOffset -ne $args[0].Parent.Extent.StartOffset
    }, $true)
  
  if ($asts.Count -eq 0)
  {
    [Microsoft.PowerShell.PSConsoleReadLine]::Ding()
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
  
  [Microsoft.PowerShell.PSConsoleReadLine]::SetCursorPosition($nextAst.Extent.StartOffset + $startOffsetAdjustment)
  [Microsoft.PowerShell.PSConsoleReadLine]::SetMark($null, $null)
  [Microsoft.PowerShell.PSConsoleReadLine]::SelectForwardChar($null, ($nextAst.Extent.EndOffset - $nextAst.Extent.StartOffset) - $endOffsetAdjustment)
}


# INFO: (https://github.com/PowerShell/PSReadLine/blob/61f598d8a733eba35810a4de6dc76f17433bbefc/PSReadLine/Options.cs#L23)
# All the options, on the code.
# Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
# Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
Set-PSReadLineOption -PredictionViewStyle ListView

# INFO: Here is the main function. To add the large chunk of keymap into shell.
$parameters = $HandlerParameters[$handler]
Set-PSReadLineKeyHandler @parameters

