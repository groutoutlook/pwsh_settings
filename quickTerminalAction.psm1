using namespace System.Collections.Generic
# import-module -Name VirtualDesktop
function Edit-Module($options = $null)
{
	Set-Location "$env:p7settingDir"
	if($options -match "[A-Z]")
	{
		neovide (Get-Location)
	} else
	{
		:v 
	}
}

Set-Alias -Name p7edit -Value Edit-Module -Scope Global

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

Set-Alias -Name cdlink -Value cdSymLink
Set-Alias -Name cdsl -Value cdSymLink

function checkFileStatus($filePath)
{
	write-host (getDateTime) "[ACTION][FILECHECK] Checking if" $filePath "is locked"
	$fileInfo = New-Object System.IO.FileInfo $filePath

	try 
	{
		$fileStream = $fileInfo.Open( [System.IO.FileMode]::Open, [System.IO.FileAccess]::Read, [System.IO.FileShare]::Read )
		write-host (getDateTime) "[ACTION][FILEAVAILABLE]" $filePath
		return $true
	} catch
	{
		write-host (getDateTime) "[ACTION][FILELOCKED] $filePath is locked"
		return $false
	}
}
	

function editNvimConfig($specific_path = "$env:LOCALAPPDATA/nvim")
{
	nvim $specific_path 
}
#set-Alias -Name viconf -Value editNvimConfig
Set-Alias -Name nvimconf -Value editNvimConfig

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
	$Env:P7AndroidDir = "D:\ProgramDataD\powershell\Proj\ADB_P7\"
	$diradd = @(
		$Env:P7AndroidDir
	)
	foreach($d in $diradd)
	{
		$Env:Path += ";"+$d;
	}
	
	Import-Module -Name ($env:p7settingDir+"ADB_BasicModule") -Scope Global
	# Import-Module -Name ($env:P7AndroidDir+"ADB_BasicModule") -Scope Global

}
Set-Alias -Name andDev -Value androidDevEnv
Add-Type -AssemblyName System.Windows.Forms

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

function getDateTime
{
	return (get-date).TimeOfDay.ToString()
}
