
$global:at_dir = "C:\ProgramDataD\Artery\Proj\TEST\src\"
$global:mm_dir = "C:\ProgramDataD\MindMotion\Proj\12_uart_irq\Project\"
$global:fmd_dir = "C:\ProgramDataD\FMD_MCU\FMD_Proj\2023_RGB_CPP\"

function copyFilestoKeil($Destination, $Source = "C:\ProgramDataD\Visual Studio\ConsoleApplication1\ConsoleApplication1\", $paramIncluded = 0, $EngineIncluded = 0)
{
	$listSourceFiles = "RGB3D_Im*","RGB3D_FontNew.h","RGB3D_Param.h"
	if ($paramIncluded -match "Star"){
		$listSourceFiles+="RGB_LargeStar.cpp","RGB3D_StarParam.h"
	}
	elseif ($paramIncluded -match "Pine"){
		$listSourceFiles+="RGB3D_PineTree*"
	}
	elseif ($paramIncluded -match "Tail"){
		$listSourceFiles+="RGB3D_Tail*"
	}
	elseif ($paramIncluded -match "Firework"){
		$listSourceFiles+="RGB3D_Firework*"
	}
	elseif ($paramIncluded -match "Panel"){
		$listSourceFiles+="RGB3D_Panel*"
	}
	
	if($EngineIncluded -eq 1){
		$listSourceFiles+="RGB_Object*","RGB_Multiple*","RGB_Area*","RGB_Background*"
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

function ChangeWindowTitles($oldName , $newName, $addOldTitle = 0){
 Get-Process | ? {$_.mainWindowTitle -and ($_.mainWindowTitle -match "$($oldName)*")} | %{
	 
	if($addOldTitle -eq 1){
		$suffix  = $_.mainWindowTitle 
	}
	else{ $suffix = ""}
    [Win32]::SetWindowText($_.mainWindowHandle, "$newName $suffix")
  }
}



function LoopChangeWindowTitles($oldName , $newName, $addOldTitle = 0){

	$interval = 1000

	$timer = New-Object System.Timers.Timer

	$timer.Enabled = $true
	$timer.Interval = $interval
	$timer.AutoReset = $true


	Register-ObjectEvent -InputObject $timer -EventName Elapsed -Action {
		ChangeWindowTitles $oldName $newName $addOldTitle
	}
}



Set-Alias -Name cpKeil -Value copyFilestoKeil -Scope Global
