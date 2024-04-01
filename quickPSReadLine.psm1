

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
    $SearchWithQuery = "$searchFunction $line"
    #Store to history for future use.
    [Microsoft.PowerShell.PSConsoleReadLine]::AddToHistory($line)
    Invoke-Expression $SearchWithQuery
    # Can InvertLine() here to return empty line.
    [Microsoft.PowerShell.PSConsoleReadLine]::BeginningOfLine()
      
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
    $searchFunction = "omniSearchObsidian"
    $SearchWithQuery = "$searchFunction $line"
    #Store to history for future use.
    [Microsoft.PowerShell.PSConsoleReadLine]::AddToHistory($line)
    Invoke-Expression $SearchWithQuery
    # Can InvertLine() here to return empty line.
    [Microsoft.PowerShell.PSConsoleReadLine]::BeginningOfLine()
      
  }
}

$quickEscParameters = @{
  Key = 'jk'
  BriefDescription = 'Obsidian Mode'
  LongDescription = 'Search Obsidian.'
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
$HandlerParameters = @{
  "ggHandler"   = $ggSearchParameters
  "obsHandler"  = $omniSearchParameters
  "escHandler"  = $quickEscParameters
}
ForEach($handler in $HandlerParameters.Keys)
{
  $parameters = $HandlerParameters[$handler]
  Set-PSReadLineKeyHandler @parameters
}



