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

function tapscr($emulatorList = $global:adbDevices)
{
	try
	{
		adb -s $emulatorList[0] shell input tap 600 600

	} catch [System.Exception] 
	{
		Write-Host "Import Anddev" -ForegroundColor Cyan
		anddev 
		ADB_getSerialList && `
			adb -s $global:adbDevices[0] shell input tap 600 600
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
