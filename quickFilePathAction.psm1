
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
	$env:linuxEnvdir = "D:\ProgramDataD\Linux\proj\linux_env"
	$diradd = @(
		$Env:cubeCLIdir,$env:edgeDir
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
function keilLoad($uv4project = "$global:fmd_dir", $project_dir = "$uv4project\2023-06-01 Project.uvprojx")
{
	cd $uv4project
	while($true)
	{
		uv4 $project_dir -f -j0 -l "$uv4project\flash_log.txt" && sleep 3 `
			&& cat .\flash_log.txt && sleep 1
	}
}
EmbedEnv

function Copy-Cliff($directory = "$env:p7settingDir\cliff.toml")
{
	Copy-Item $directory .
}
Set-Alias -Name cpcliff -Value Copy-Cliff 


function Copy-Just($directory = "$env:p7settingDir\justfile")
{
	Copy-Item $directory .
}
Set-Alias -Name cpjust -Value Copy-Just


# INFO: Import Completion scripts.
function Import-Completion
{
	$completionsDir = "$env:p7settingDir\completions"
	$listImport = Get-ChildItem $completionsDir
	if($args[0] -eq $null)
	{
		# $importScripts = $listImport.FullName | fzf 
		$importName = $listImport.BaseName | fzf
		. (Join-Path -Path $completionsDir -ChildPath "$importName.ps1")
	} else
	{
		foreach($arg in $args)
  {
			$importName = $arg
			. (Join-Path -Path $completionsDir -ChildPath "$importName.ps1")
		}
	}
}



Set-Alias -Name :cp -Value Import-Completion 

# INFO: Default completion import.
Import-Completion just
