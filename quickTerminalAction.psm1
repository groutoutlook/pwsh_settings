using namespace System.Collections.Generic
# import-module -Name VirtualDesktop


function isLink($currentPath = (Get-Location))
{
	$pathProperty = Get-Item $currentPath
	if($pathProperty.LinkType -eq "SymbolicLink")
	{
		Write-Host "`$PWD is SymLink"
		Write-Host $pathProperty.Target
	}
	return  $pathProperty.Target
}

function cdSymLink($currentPath = (Get-Location))
{
	$currentPath = Resolve-Path $currentPath
	if(($targetDir = isLink($currentPath)) -ne $null)
 {
		Set-Location $targetDir
	}
}
Set-Alias -Name cdsl -Value cdSymLink
	
$CommandNewWt = @{
	"win" = '-f new-tab -p "P7_OrangeBackground" pwsh -NoExit -Command "p7 && p7mod"; split-pane --size 0.5 -H -p "P7_OrangeBackground" pwsh -NoExit -Command "p7 && p7mod"'
	"and" = '-f new-tab --suppressApplicationTitle -p "P7_Android"  pwsh -NoExit -Command "p7 && p7mod && anddev"; split-pane --size 0.5 -H -p "P7_Android" pwsh -NoExit -Command "p7 && p7mod && anddev"'
	"ssh" = '-f new-tab -p "ssh" split-pane --size 0.5 -V -p "ssh_1" ; split-pane --size 0.5 -V -p "ssh_1" ; move-focus first ; split-pane --size 0.5 -V -p "ssh_1" ; move-focus first ; split-pane --size 0.5 -H -p "ssh_2" ; move-focus right ; split-pane --size 0.5 -H -p "ssh_2" ; move-focus right ; split-pane --size 0.5 -H -p "ssh_2" ; move-focus right ; split-pane --size 0.5 -H -p "ssh_2" pwsh -NoExit -Command "anddev && p7 && p7mod"'
	"lin" = '-f new-tab -p "P7_OrangeBackground" wsl'
	"obs" = '-f new-tab -p "P7_OrangeBackground" pwsh -NoExit -Command "p7 && p7mod && Set-Location $env:obsVault && jnl -3"'
}

function term($which = "win")
{
	$fetch_command = $CommandNewWt[$which]
	if($fetch_command -ne $null)
	{
		Start-Process wt $fetch_command
	} else
	{
		Write-Error "Wrong syntax"
		Write-Output $CommandNewWt
	}
}
function androidDevEnv
{
	$Env:P7AndroidDir = (Join-Path -Path $env:p7settingDir -ChildPath "adb_p7")
	Import-Module -Name (Join-Path -Path $Env:P7AndroidDir -ChildPath "ADB_BasicModule.psm1") -Scope Global 
}
Set-Alias -Name andDev -Value androidDevEnv
Add-Type -AssemblyName System.Windows.Forms

function tapscr($emulator = $global:adbDevices,$index = 0)
{
	try
	{
		$emulatorName  = $emulator[$index]
		if(($emulatorName).Length -gt 2)
		{
			adb -s $emulatorName shell input tap 600 600
		} else
		{
			adb -s $emulator shell input tap 1000 500
		}

	} catch [System.Exception] 
	{
		try
  {

			Write-Host "Import Anddev" -ForegroundColor Cyan
			anddev 
			ADB_getSerialList 
		
			$emulatorName  = $emulator[$index]
			if(($emulatorName).Length -gt 2)
			{
				adb -s $emulatorName shell input tap 600 600
			} else
			{
				adb -s $emulator shell input tap 1000 500
			}	
		} catch [ System.Management.Automation.CommandNotFoundException]
		{
			# Recursive call until it tap.
			tapscr
		}
	}
}

function explr($inputPath = (Get-Location))
{
	if($inputPath -match "This PC")
	{
		explorer.exe 
		Start-Sleep 0.5
		Set-Clipboard $inputPath
		[System.Windows.Forms.SendKeys]::SendWait("^l")
		Start-Sleep 0.2
		[System.Windows.Forms.SendKeys]::SendWait("^v{ENTER}")
		echo "ahk then?"
	} else
	{
		explorer.exe $inputPath
	}
}
Set-Alias -Name expl -Value explr -Scope Global


# INFO: A function to switch font, on CLI.
function fontsw($fontName = "Iosevka Nerd Font Propo")
{
	# HACK: Find tab's profile name then search in that chunk.
	$SettingsPath = (Resolve-Path "C:\Users\COHOTECH\AppData\Local\Packages\Microsoft.WindowsTerminalPreview_*\LocalState\settings.json")
	$CurrentFileContent = (Get-Content -Path $SettingsPath | ConvertFrom-Json)
	$TestFont = $CurrentFileContent.profiles.list[2].font.face
	echo $TestFont

	$CurrentFileContent.profiles.list[2].font.face = "$fontName"
	$fileContent = "$(ConvertTo-Json $CurrentFileContent -Depth 10)"

	Set-Content -Value $fileContent -Path $SettingsPath

}

# INFO: Swap shaders, for reloading purpose perhaps.
function swapWtShader($fileName = "orig")
{
	$SettingsPath = (Resolve-Path "C:\Users\COHOTECH\AppData\Local\Packages\Microsoft.WindowsTerminalPreview_*\LocalState\settings.json")
	$CurrentFileContent = (Get-Content -Path $SettingsPath | ConvertFrom-Json)
	$TestShaderPath = $CurrentFileContent.profiles.list[3].'experimental.pixelShaderPath'
	# INFO: switch back case.
	if ($fileName -eq "-")
	{
		if( $TestShaderPath -match "orig")
		{
			$fileName = "swap"
		} else
		{
			$fileName = "orig"
		}
	}
	$CurrentFileContent.profiles.list[3].'experimental.pixelShaderPath' = "C:\\RootConf\\$fileName.hlsl"
	$fileContent = "$(ConvertTo-Json $CurrentFileContent -Depth 10)"
	# echo $fileContent
	Set-Content -Value $fileContent -Path $SettingsPath
}

# INFO: Copy shaders from the original Terminal app. Could be somewhere else in another JSON files.
function copyWtShader($fileName = "orig")
{
	$SettingsPath = (Resolve-Path "C:\Users\COHOTECH\AppData\Local\Packages\Microsoft.WindowsTerminal_*\LocalState\settings.json")
	$CurrentFileContent = Get-Content -Path $SettingsPath | ConvertFrom-Json
	$TestShaderPath = $CurrentFileContent.profiles.defaults.'experimental.pixelShaderPath'
	$FinalShaderPath = "C:\\RootConf\\$fileName.hlsl"

	Copy-Item $TestShaderPath $FinalShaderPath
}



