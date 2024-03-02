using namespace System.Collections.Generic
# import-module -Name VirtualDesktop
Import-Module $env:ChocolateyInstall\helpers\chocolateyProfile.psm1 # for RefreshEnv

function SetBufferWidthToScreenWidth
{
	$h = Get-Host
	$ui = $h.UI.RawUI
	$bufferSize = $ui.BufferSize
	$windowSize = $ui.WindowSize
	$bufferSize.Width = $windowSize.Width
	$ui.BufferSize = $bufferSize
}

function p7edit($options = "")
{
	if($options -match "quick")
	{
		$fileName = "quickTerminalAction.psm1"
	} elseif($options -match "file")
	{
		$fileName = "quickFilePathAction.psm1"
	} elseif($options -match "and")
	{
		$fileName = "ADB_BasicModule.psm1"
	} else
	{
		cd $env:p7settingDir
		nvim .
		return
	}
	cd "$env:p7settingDir"
	nvim ".\$fileName"
	#hx ".\$fileName"
}

Set-Alias -Name npp7 -Value p7edit -Scope Global

function cdClip($demandURI = (Get-Clipboard))
{
	$finalURI = (([URI]($demandURI)).LocalPath) | Split-path -PipelineVariable $_ -parent
	cd $finalURI
}
function cdcb
{
	cd (gcb) #Get-Clipboard default alias.
}


function hvdic(
	$phrase,
	$space_split = 1
)
{	
	$query = 'https://hvdic.thivien.net/whv/'
	
	if($space_split -eq 1)
 {
		$phrase.ToCharArray() | % { 
			$link = $query + "$_" 
			$url = $link.Substring(0, $link.Length)
			start "$url"
		}
	}
}

function getDateTime
{
	return (get-date).TimeOfDay.ToString()
}

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
	hx $specific_path 
}
#set-Alias -Name viconf -Value editNvimConfig
Set-Alias -Name nvimconf -Value editNvimConfig

function term($which = "win")
{
	if($which -eq "and")
	{
		$command = '-f new-tab --suppressApplicationTitle -p "P7_Android"  pwsh -NoExit -Command "p7 && p7mod && anddev"; split-pane --size 0.5 -H -p "P7_Android" pwsh -NoExit -Command "p7 && p7mod && anddev"'
		start wt "$command"
	} elseif($which -eq "win")
	{
		start wt '-f new-tab -p "P7_OrangeBackground" pwsh -NoExit -Command "p7 && p7mod"; split-pane --size 0.5 -H -p "P7_OrangeBackground" pwsh -NoExit -Command "p7 && p7mod"'
	} elseif($which -eq "ssh")
	{
		start wt '-F new-tab -p "ssh" split-pane --size 0.5 -V -p "ssh_1" ; split-pane --size 0.5 -V -p "ssh_1" ; move-focus first ; split-pane --size 0.5 -V -p "ssh_1" ; move-focus first ; split-pane --size 0.5 -H -p "ssh_2" ; move-focus right ; split-pane --size 0.5 -H -p "ssh_2" ; move-focus right ; split-pane --size 0.5 -H -p "ssh_2" ; move-focus right ; split-pane --size 0.5 -H -p "ssh_2" pwsh -NoExit -Command "anddev && p7 && p7mod"'
	} elseif($which -eq "lin")
	{
		start wt '-F new-tab -p "ssh_3" split-pane --size 0.5 -V -p "ssh_3" ; move-focus first ; split-pane --size 0.5 -H -p "ssh_4" ; move-focus right ; split-pane --size 0.5 -H -p "ssh_4" pwsh -NoExit -Command "p7 && p7mod"'
	} elseif($which -eq "obs")
	{
		start wt '-F new-tab -p "P7_OrangeBackground" pwsh -NoExit -Command "p7 && p7mod && jnl"'
	}
	
	#kawt "P7_P"	
}
function androidDevEnv
{
	$Env:P7AndroidDir = "D:\ProgramDataD\powershell\Proj\ADB_P7\"
	$Env:BinAndroidDir = "D:\ProgramDataD\pyhelpers\ADB_Scrcpy\bin\scrcpy\"
	$diradd = @(
		$Env:P7AndroidDir,$Env:BinAndroidDir
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

function explr($inputPath = (pwd))
{
	if($inputPath -match "This PC")
	{
		explorer 
		Start-Sleep 0.5
		scb $inputPath
		[System.Windows.Forms.SendKeys]::SendWait("^l")
		Start-Sleep 0.2
		[System.Windows.Forms.SendKeys]::SendWait("^v{ENTER}")
		echo "ahk then?"
	} else
	{
		explorer $inputPath
	}
}

Set-Alias -Name expl -Value explr -Scope Global




