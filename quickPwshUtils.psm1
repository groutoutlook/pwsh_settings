
function buildIndex
{
  Param( [Object[]]$inputArray, [string]$keyName) 

  $index = @{};
  foreach($row in $inputArray)
  {
    $key = $row.($keyName);
    if($key -eq $null -or $key.Equals([DBNull]::Value) -or $key.Length -eq 0)
    {
      $key = "<empty>"
    }
    $data = $index[$key];
    if ($data -is [System.Collections.Generic.List[PSObject]])
    {
      $data.Add($row)
    } elseif ($data)
    {
      $index[$key] = New-Object -TypeName System.Collections.Generic.List[PSObject]
      $index[$key].Add($data, $row)
    } else
    {
      $index[$key] = $row
    }
  }
  $index
}

