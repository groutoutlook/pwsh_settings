

# Setup for (^G) 
$parameters = @{
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

Set-PSReadLineKeyHandler @parameters



