# Import-Module -Name Prelude





function toHex($number)
{
 Write-Host('{0:X}' -f $number)
}


function reverse
{ 
 param([String[]] $inputArr)
 $arr = @($inputArr)
 [array]::reverse($arr)
 [string]$resarr = $arr -join  ","
 echo $resarr
}
