
$global:at_dir = "D:\ProgramDataD\Artery\Proj\TEST\src\"
$global:mm_dir = "D:\ProgramDataD\MindMotion\Proj\12_uart_irq\Project\"
$global:fmd_dir = "D:\ProgramDataD\FMD_MCU\FMD_Proj\2023_RGB_CPP\"
$global:vs_dir_debug = "D:\ProgramDataD\Visual Studio\ConsoleApplication1\x64\Debug"
$global:st_dir = "D:\ProgramDataD\ST\repo\STM32CubeH7\Projects\NUCLEO-H745ZI-Q\Examples\GPIO\GPIO_EXTI\STM32CubeIDE\CM7\RGB_SOURCE"
function copyFilestoKeil(
	$Destination, 
	$Source = "D:\ProgramDataD\Visual Studio\ConsoleApplication1\ConsoleApplication1\", 
	$paramIncluded = 0, 
	$EngineIncluded = 0,
	$SequenceIncluded = 0)
{
	$listSourceFiles = "RGB3D_FontNew.h","RGB3D_Param.h"
	if ($paramIncluded -match "Star")
	{
		$listSourceFiles+="RGB3D_Star*"
	} elseif ($paramIncluded -match "Pine")
	{
		$listSourceFiles+="RGB3D_PineTree*","RGB3D_Im*"
	} elseif ($paramIncluded -match "Tail")
	{
		$listSourceFiles+="RGB3D_Tail*","RGB3D_Im*"
	} elseif ($paramIncluded -match "Firework")
	{
		$listSourceFiles+="RGB3D_Firework*"
	} elseif ($paramIncluded -match "Panel")
	{
		$listSourceFiles+="RGB3D_Panel*","RGB3D_Im*"
	} elseif ($paramIncluded -match "Ray")
	{
		$listSourceFiles+="RGB3D_Ray*"
	}
	
	if($EngineIncluded -eq 1)
 {
		$listSourceFiles+="RGB_Object*","RGB_Multiple*","RGB_Area*","RGB_Background*"
	}
	
	if($SequenceIncluded -eq 1)
 {
		$listSourceFiles+="RGB3D_ProgramSequence*"
	}
	$vendorSpecific = $Destination.Split("\")[2]
	echo $vendorSpecific
	foreach($files in $listSourceFiles)
	{
		$constructedDir = "$Source$files"
		cp $constructedDir $Destination
		echo "files dir is $constructedDir"
	}
}


function EmbedEnv()
{
	$Env:cubeCLIdir =  "C:\Program Files\STMicroelectronics\STM32Cube\STM32CubeProgrammer\bin"
	$Env:edgeDir = "C:\Users\COHOTECH\AppData\Local\Microsoft\Edge SxS\Application"
	$Env:gotvDir = "D:\Program Files\GoTiengViet"
	$env:linuxEnvdir = "D:\ProgramDataD\Linux\proj\linux_env"
	$diradd = @(
		$Env:cubeCLIdir,$env:edgeDir,
		$Env:gotvDir
	)
	foreach($d in $diradd)
	{
		$Env:Path += ";"+$d;
	}
}
function enterp($path = "D:\ProgramDataD\Mua ban TQ VN\Electrical-23\Edited")
{
	expl $path
}
function syncthing()
{
	Start-Process https://localhost:8384
}
function discord()
{
	. "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Discord Inc\discord.lnk"
}
$global:JrnlInEnv = 0
function activateJrnl()
{
	$Env:jrnlDir = "$Env:venvsDir\jrnl"
	Set-Location "$Env:jrnlDir\Scripts"
	.\Activate.ps1
	Set-Location -
}

function Jnl
{
	if($global:JrnlInEnv -eq 0)
	{
		activateJrnl
		$global:JrnlInEnv = 1
		jrnl $args
	} else
	{
		jrnl $args
	}
}

function SDCardCheckAndLoad($drive_name = "E",$data_file = "D:\ProgramDataD\Audio\proj\FireworkMusic_v2.0.mp3")
{
	$sd_used = ((Get-PSDrive -PSProvider FileSystem -Name $drive_name).Used) #or we can index [2] then.
	if($sd_used -ge 1000000)
	{
		echo "have file."
	} elseif(($sd_used -le 1000000) -and ($sd_used -ne $null))
	{
		echo "no file."
		cp "$data_file" ("$drive_name"+":") 
		echo "copied"
	} else
	{
		echo "no disk."
	}
}

function LoopSDCardLoad()
{
	while($true)
	{
		SDCardCheckAndLoad
		sleep 1
	}
}

function keilLoad($uv4project = "$global:fmd_dir")
{
	cd $uv4project
	$project_dir = "$uv4project\2023-06-01 Project.uvprojx"
	while($true)
	{
		uv4 $project_dir -f -j0 -l "$uv4project\flash_log.txt" && sleep 3 `
			&& cat .\flash_log.txt && sleep 1
	}
}
EmbedEnv
# activateJrnl
$global:imgPath = "D:\ProgramDataD\Animation\Proj\final"

function Copy-Cliff($directory = "D:\ProgramDataD\Visual Studio\ConsoleApplication1\cliff.toml")
{
	Copy-Item $directory .
}
Set-Alias -Name cpcliff -Value Copy-Cliff 

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

function ChangeWindowTitles($oldName , $newName, $addOldTitle = 0)
{
 Get-Process | ? {$_.mainWindowTitle -and ($_.mainWindowTitle -match "$($oldName)*")} | %{
	 
		if($addOldTitle -eq 1)
  {
			$suffix  = $_.mainWindowTitle 
		} else
		{ $suffix = ""
		}
		[Win32]::SetWindowText($_.mainWindowHandle, "$newName $suffix")
	}
}



function LoopChangeWindowTitles($oldName , $newName, $addOldTitle = 0)
{

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
