# Import-Module -Name Prelude





function toHex($number)
{
 Write-Host('{0:X}' -f $number)
}

function toBin($number)
{
 Write-Host('{0:B}' -f $number)
}


function expressionArray()
{
 $finalArray = @()
 $args -split "," | %{$finalArray += iex $_}
 return $finalArray
}

function Format-ReverseArray()
{
 $returnArray = @()
 $array = $args -split "," 
 [array]::Reverse($array); 
 $returnArray = $array

 return $returnArray
}



function reverse
{ 
 param([String[]] $inputArr)
 $arr = @($inputArr)
 [array]::reverse($arr)
 [string]$resarr = $arr -join  ","
 echo $resarr
}
