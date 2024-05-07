# powershell-5.1
Set-Alias -Name p5 -Value 'C:\WINDOWS\system32\WindowsPowerShell\v1.0\powershell.exe'
function zsh
{
	wsl --cd ~
}
function Dirs
{
	Get-Location -Stack
}

function initAutomate
{
	Set-Alias -Name ditto -Value "$env:ProgramFilesD\Ditto\Ditto" -Scope Global
	Set-Alias -Name copyq -Value "$env:ProgramFilesD\CopyQ\copyq" -Scope Global
	Set-Alias -Name spy -Value "$env:ProgramFiles\AutoHotkey\UX\WindowSpy.ahk" -Scope Global
	Set-Alias -Name ahk -Value "$env:ProgramFiles\AutoHotkey\UX\ui-dash.ahk" -Scope Global
	Set-Alias -Name mousekey -Value "$env:ahkDirD\proj\MouseKeysPlusPlus\MouseKeys++.exe" -Scope Global
	Set-Alias -Name keydell -Value "$env:ahkDirD\proj\PersonalAHKScripts\DellKeyboardRemap.ahk"  -Scope Global
}
function initIDE
{
	# visual studio
	Set-Alias -Name devenv -Value 'C:\Program Files\Microsoft Visual Studio\2022\Community\Common7\IDE\devenv.exe' -Scope Global #-Option AllScope
	# keil UV4
	Set-Alias -Name uv4 -Value 'C:\Keil_v5\UV4\uv4.exe' -Scope Global #-Option AllScope
}
function initGuiApp
{
	Set-Alias -Name VDhelper -Value "${env:ProgramFiles(x86)}\Windows Virtual Desktop Helper\WindowsVirtualDesktopHelper" -Scope Global
	Set-Alias -Name VDcreate -Value "$env:ProgramFiles\VirtualDisplayDriver\bin\VirtualDisplayDriverControl" -Scope Global
	Set-Alias -Name dsview -Value $env:ProgramFiles\DSView\DSView.exe -Scope Global	# Set-Alias -Name ptoy -Value "$env:ProgramFiles\PowerToys\PowerToys.exe" -Scope Global
	Set-Alias -Name libload -Value "$env:ProgramData\Microsoft\Windows\Start Menu\Programs\Library Loader\Library Loader.lnk" -Scope Global
}
function Restart-ForceApp($fileDir)
{
	$fileName = (Split-Path $fileDir -Leaf) -replace "\.exe$"
	$currentSearchingProcess = (Get-Process -Name $fileName -ErrorAction Ignore)
	if($currentSearchingProcess.Id -eq $null)
	{
		Write-Host "Haven't started the $fileName yet." -ForegroundColor Red
		Start-Process $fileDir
	} else
	{
		Stop-Process -Id $currentSearchingProcess.Id 
		Start-Process $fileDir
	}
}
function goviet()
{
	$fileDir = "$env:GoTiengVietDir/GoTiengViet.exe"
	Restart-ForceApp -fileDir $fileDir	
}
function pentab()
{
	$fileDir = "$env:ProgramFiles\Pentablet\PenTablet.exe"
	Restart-ForceApp -fileDir $fileDir	
}
$localPathNvim = "$env:p7settingDir\Microsoft.PowerShell_profile.ps1"
$global:p7Profile = $localPathNvim
function global:p7Env
{
	$LastWrite = (Get-ItemProperty ($localPathNvim)).LastWriteTimeString
	nvim $localPathNvim
	$NewLastWrite = (Get-ItemProperty ($localPathNvim)).LastWriteTimeString
	if($NewLastWrite -ne $LastWrite)
	{
		Backup-Environment
		Write-Host "Env change, jump to backup." -ForegroundColor Green
	}
}

function Format-LimitLength($String,$limitString = 50)
{
	if($String.Length -gt $limitString)
	{
		$String = "(...)"+$String.Substring($String.Length - $limitString)
	}
	return $String
}
function global:Backup-Environment($Verbose = $null)
{
	Copy-Item $localPathNvim "$PROFILE"
	Write-Host "[$(Get-Date)] Move Profile. CurrentUserCurrentHost" -ForegroundColor Green
}
Set-Alias -Name p7Backup -Value Backup-Environment


function yy
{
	$tmp = [System.IO.Path]::GetTempFileName()
	yazi $args --cwd-file="$tmp"
	$cwd = Get-Content -Path $tmp
	if (-not [String]::IsNullOrEmpty($cwd) -and $cwd -ne $PWD.Path)
	{
		Set-Location -Path $cwd
	}
	Remove-Item -Path $tmp
}
Set-Alias -Name dd -Value yy

function P7()
{
	Invoke-Expression (&starship init powershell)
	Invoke-Expression (& { (zoxide init powershell --hook pwd | Out-String) })
	Set-Alias -Name cd -Value z -Scope Global -Option AllScope 
}

$global:initialModuleList=@(
	"quickWebAction",
	"quickVimAction",
	"quickPSReadLine"
)

$global:extraModuleList = @(
	"ExtraCLIApp",
	"quickMathAction",
	"quickGitAction",
	"quickTerminalAction",
	"quickFilePathAction"
)
$global:personalModuleList = $global:initialModuleList + $global:extraModuleList
function MoreTerminalModule
{
	#External pwsh module
	# Import-Module -Name F7History -Scope Global 
	Import-Module -Name PSFzf -Scope Global 
	# replace 'Ctrl+t' and 'Ctrl+r' with your preferred bindings:
	Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+t' -PSReadlineChordReverseHistory 'Ctrl+r'
	Set-PsFzfOption -TabExpansion
	Set-PSReadLineKeyHandler -Key Tab -ScriptBlock { Invoke-FzfTabCompletion }
	#Import-Module -Name VirtualDesktop -Scope Global -Verbose
	
	# $Env:sourceTreePath = "$env:LOCALAPPDATA\SourceTree\"
	$Env:SMergePath = "C:\Program Files\Sublime Merge\"
	$diradd = @(
		$Env:SMergePath
		# $Env:sourceTreePath,
	)
	foreach($d in $diradd)
	{
		$Env:Path += ";"+$d;
	}
	foreach($module in $global:extraModuleList)
	{
		Import-Module -Name ("$env:p7settingDir$module") -Scope Global 
		# echo "$module here"
	}
}
Set-Alias -Name p7mod -Value MoreTerminalModule

function initShellApp()
{
	# echo $initialModuleList
	foreach($module in $global:initialModuleList)
 {
		# echo "$module here."
		Import-Module -Name ("$env:p7settingDir$module") -Scope Global 
	}
}
function Restart-ModuleList()
{
	param (
		[array]$ModuleList = $global:personalModuleList,
		[string]$ModulePath = $env:p7settingDir
	)
	foreach($ModuleName in $ModuleList)
	{
		Remove-Module -Name "$ModulePath$ModuleName" -ErrorAction SilentlyContinue
		Import-Module -Name "$ModulePath$ModuleName" -Force 
		Write-Output "$ModuleName reimported"
	}
}
function global:Restart-Profile($option = "env")
{
	if ($option -match "^all")
	{
		Restart-ModuleList
		. $PROFILE
		Write-Output "Restart profile and All module."
	} else
	{
		. $PROFILE
		Write-Output "Restart pwsh Profile."
	}
}
Set-Alias -Name repro -Value Restart-Profile
function cdcb($defaultDir = (Get-Clipboard))
{
	$copiedPath = ($defaultDir -replace '"')
	$property = Get-Item $copiedPath
	if ($property.PSIsContainer -eq $true)
	{
		Set-Location $copiedPath
	} else
	{
		Set-Location (Split-Path -Path $copiedPath -Parent)
	}
}
function Set-LocationWhere($files = (Get-Clipboard))
{
	$commandInfo = (get-Command $files -ErrorAction SilentlyContinue)
	
	if ($null -ne $commandInfo)
	{
		switch -Exact ($commandInfo.CommandType)
		{
			"Application"
			{
				# for global executable files.
				# We need something to detect executable here. Mostly exe files but there could also be other type as well.
				if ($commandInfo.Extension -match "exe")
				{
					$listBinaries = (where.exe $files) 
					if ($listBinaries.GetType().BaseType.Name -eq "Array")
					{
						Write-Host "There are 2 Location!`n" -ForegroundColor Yellow
						$finalBinariesPath = $listBinaries | fzf
					} else
					{
						$finalBinariesPath = $listBinaries
					}
					Set-Location (split-path ($finalBinariesPath) -Parent)
				} else
				{
					# other extensions 
					cdcb $files
				}
				; break; 
			}
			"Alias"
			{
				Set-Location (split-path (($commandInfo).Definition) -Parent)
				; break;
			}
		} 
	} else
	{
		if(($info = Get-Item $files).LinkType -eq "SymbolicLink")
		{
			cd $info.Target
		} else
		{
			cdcb $files
		}
	}
}
Set-Alias -Name cdw -Value Set-LocationWhere
Set-Alias -Name cdwhere -Value Set-LocationWhere
function addPath($dirList)
{
	foreach($d in $dirList)
	{
		$d = Resolve-Path $d
		$Env:Path += ";"+$d;
	}
}

function global:initProfileEnv
{ 
	$Env:ProgramFilesD = "D:\Program Files"
	$Env:ProgramDataD = "D:\ProgramDataD"
	$env:dotfilesRepo = "$Env:ProgramDataD\dotfiles"
	$Env:ChromeDir="$env:ProgramFiles\Google\Chrome\Application"
	$Env:p7settingDir = "$env:ProgramDataD/powershell\settings\"
	$Env:CommercialDir = "$env:ProgramDataD/Mua ban TQ - VN\"
	$Env:ahkDirD = "$env:ProgramDataD\ahk\"
	$Env:SysInternalSuite = "$env:ProgramFilesD\SysinternalsSuite\"
	$Env:kicadDir = "$env:ProgramFilesD\KiCad\8.0\bin"
	$Env:kicadSettingDir = "$env:APPDATA\kicad\8.0"
	$env:pipxLocalDir = "~\.local\bin"

	$env:obsVault = "D:\ProgramDataD\Notes\Obsidian\Vault_2401\"
	$env:VulkanSDK="C:\VulkanSDK\*\"
	$Env:cargoDir = "~\.cargo\bin"
	$env:usrbinD="D:\usr\bin"
	$diradd = @(
		$env:usrbinD,
		$Env:PhotoshopDir,
		$Env:ChromeDir,
		$Env:kicadDir,
		$env:pipxLocalDir,
		$Env:cargoDir,
		$Env:SysInternalSuite
	)
	foreach($d in $diradd)
	{
		$Env:Path += ";"+$d;
	}
	# $Env:PSModulePath += ";" + $Env:p7settingDir 
}

function Show-Window
{
	param(
		[Parameter(Mandatory)]
		[string] $ProcessName
	)
	$ProcessName = $ProcessName -replace '\.exe$'
	$procId = (Get-Process -ErrorAction Ignore $ProcessName).Where({ $_.MainWindowTitle }, 'First').Id

	if (-not $procId)
	{ Throw "No $ProcessName process with a non-empty window title found." 
	 return 1
	}
	$null = (New-Object -ComObject WScript.Shell).AppActivate($procId)
}

function Show-Neovide
{
	Show-Window("Neovide.exe")
}
Set-Alias -Name shw -Value Show-Window
Set-Alias -Name shv -Value Show-Neovide

function omniSearchObsidian
{
	$query = ""
	$args | % {
		$query = $query + "$_%20"
	}
	Start-Process "obsidian://omnisearch?query=$query" &
}


function cd-($rep = 1)
{
	foreach($i in (1..$rep))
 {
		Set-Location -
	}
}

function cd+($rep = 1)
{
	foreach($i in (1..$rep))
 {
		Set-Location +
	}
}

# INFO: Rescue explorer function.
function Restart-Explorer
{
	Stop-Process -Name explorer `
		&& Stop-Process -Name "WindowsVirtualDesktopHelper" `
		&& Start-Sleep -Milliseconds 1000 
	# && VDhelper
}
Set-Alias -Name resexp -Value Restart-Explorer

initProfileEnv
initShellApp
initIDE
initAutomate
initGuiApp
# P7
# Import-Module PSCompletions
