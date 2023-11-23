Import-Module -Name Prelude


function toHex($number){
Write-Host('{0:X}' -f $number)
}


function reverse
{ 
 $arr = @($input)
 [array]::reverse($arr)
 $arr
}