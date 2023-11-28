



$global:at_dir = "C:\ProgramDataD\Artery\Proj\TEST\src\"
$global:mm_dir = "C:\ProgramDataD\MindMotion\Proj\12_uart_irq\Project\"

function copyFilestoKeil($Destination, $Source = "C:\ProgramDataD\Visual Studio\ConsoleApplication1\ConsoleApplication1\", $paramIncluded = 0)
{
	$listSourceFiles = "RGB3D_Im*","RGB3D_FontNew.h","RGB3D_Param.h"
	if ($paramIncluded -match "Star"){
		$listSourceFiles+="RGB_LargeStar.cpp","RGB3D_StarParam.h"
	}
	elseif ($paramIncluded -match "Pine"){
		$listSourceFiles+="RGB3D_PineTree*"
	}
	$vendorSpecific = $Destination.Split("\")[2]
	echo $vendorSpecific
	foreach($files in $listSourceFiles){
		$constructedDir = "$Source$files"
		cp $constructedDir $Destination
		echo "files dir is $constructedDir"
	}
}

<#
# Prefix to add to window titles.
$prefix = "Top Secret"

# How often to update window titles (in milliseconds).
$interval = 1000

$timer = New-Object System.Timers.Timer

$timer.Enabled = $true
$timer.Interval = $interval
$timer.AutoReset = $true

function Add-Prefix-Titles($prefix) {
  Get-Process | ? {$_.mainWindowTitle -and $_.mainWindowTitle -notlike "$($prefix)*"} | %{
    [Win32]::SetWindowText($_.mainWindowHandle, "$prefix - $($_.mainWindowTitle)")
  }
}

Register-ObjectEvent -InputObject $timer -EventName Elapsed -Action {
  Add-Prefix-Titles $prefix
}

#>

Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;

public static class Win32 {
  [DllImport("User32.dll", EntryPoint="SetWindowText")]
  public static extern int SetWindowText(IntPtr hWnd, string strTitle);
}
"@

function Change-Window-Titles($oldName , $newName, $addOldTitle = 0){
 Get-Process | ? {$_.mainWindowTitle -and $_.mainWindowTitle -match "$($oldName)*"} | %{
	 
	if($addOldTitle -eq 1){
		$suffix  = $_.mainWindowTitle 
	}
	else{ $suffix = ""}
    [Win32]::SetWindowText($_.mainWindowHandle, "$newName $suffix")
  }
}





Set-Alias -Name cpKeil -Value copyFilestoKeil -Scope Global
