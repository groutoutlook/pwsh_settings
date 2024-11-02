# INFO: Old script I use to copy files back and forth between repos.
# should not do that anymore, use `just` to run test or copy task,
# or decouple them into modules. Better to manage and faster to automate.

$global:at_dir = "D:\ProgramDataD\Artery_MCU\Proj\TEST\src\"
$global:mm_dir = "D:\ProgramDataD\MindMotion_MCU\Proj\12_uart_irq\Project\"
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
	$env:linuxEnvdir = "D:\ProgramDataD\Linux\proj\linux_env"
	$diradd = @(
		$Env:cubeCLIdir
	)
	foreach($d in $diradd)
	{
		$Env:Path += ";"+$d;
	}
}
function keilLoad($uv4project = "$global:fmd_dir", $project_dir = "$uv4project\*.uvprojx")
{
	cd $uv4project
	$project_dir = (rvpa $project_dir).Path
	while($true)
	{
		uv4 $project_dir -f -j0 -l "$uv4project\flash_log.txt" && sleep 3 `
			&& tail .\flash_log.txt && sleep 1
	}
}

function Build-Keil(

)
{
	$count = 0
	# INFO: load Keil file. Used first at $at_dir
	# HACK: A kludge for looping load files.
	# while($true){Build-Keil; sleep 5}
	uv4 (fd '.uvprojx' -HI) -f -j0 -l ./flash_log.txt 
	while( -not (rg "Programming Done" -g "*log.txt"))
	{ 
		$count += 1
		Write-Host "waiting $count"
		Start-Sleep -Milliseconds 500
		if(($count -gt 9) -and (rg "Error"))
		{
			Write-Host "Break at $count because error"
			break
		}
		if($count -gt 20)
		{
			Write-Host "Break at $count timeout"
			break
		}

	} 
	[console]::beep(500,400)
	Get-Content -Tail 10 .\flash_log.txt
}
EmbedEnv

function enterp($path = "D:\ProgramDataD\Mua ban TQ VN\Electrical-23\Edited")
{
	expl $path
}
function syncthing()
{
	Start-Process https://localhost:8384
}

function Copy-Cliff($directory = "$env:p7settingDir\cliff.toml")
{
	Copy-Item $directory .
}
function Copy-Just($directory = "$env:p7settingDir\justfile")
{
	Copy-Item $directory .
}
Set-Alias -Name cpjust -Value Copy-Just
Set-Alias -Name cpcliff -Value Copy-Cliff 
