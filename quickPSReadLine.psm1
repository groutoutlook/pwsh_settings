

# Setup for (^G) 
$ggSearchParameters = @{
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
    [Microsoft.PowerShell.PSConsoleReadLine]::Insert("$invokeFunction ")
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
  Key = 'Ctrl+x'
  BriefDescription = 'Execute as sudo (in pwsh).'
  LongDescription = 'Call sudo on current command or latest command in history.'
  ScriptBlock = {
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



$HandlerParameters = @{
  "ggHandler"   = $ggSearchParameters
  "obsHandler"  = $omniSearchParameters
  "cdHandler"  = $cdHandlerParameters
  "escHandler"  = $quickEscParameters
  "sudoHandler"  = $sudoRunParameters
}
ForEach($handler in $HandlerParameters.Keys)
{
  $parameters = $HandlerParameters[$handler]
  Set-PSReadLineKeyHandler @parameters
}



$parameters = $HandlerParameters[$handler]
Set-PSReadLineKeyHandler @parameters



