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
function initTypicalEditor
{	
	Set-Alias -Name np -Value 'C:\Program Files\Notepad++\notepad++.exe' -Scope Global #-Option AllScope
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
$localPathNvim = "D:\ProgramDataD\powershell\settings\Microsoft.PowerShell_profile.ps1"
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
	$terminalSettings = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminalPreview_*\LocalState\settings.json"
	$dotfiles = @(
		"~/.gitconfig",
		"~/.gitignore_global"
		$terminalSettings
	)

	foreach($dotfile in $dotfiles)
	{
		(Copy-Item $dotfile "$Env:dotfilesRepo")
		if($Verbose -le 0)
		{
			$dotfile = Format-LimitLength -String $dotfile
		}
		Write-Host "$dotfile backed up." -ForegroundColor Yellow
	}
	Copy-Item $localPathNvim "$PROFILE"
	Write-Host "Move Profile. CurrentUserCurrentHost" -ForegroundColor Green
}
Set-Alias -Name p7Backup -Value Backup-Environment

# Extra color for the terminal.
Set-Alias -Name zz -Value yazi
function P7()
{
	# oh-my-posh -> https://ohmyposh.dev/docs/installation/customize
	Invoke-Expression (& { (zoxide init powershell | Out-String) })
	Invoke-Expression (&starship init powershell)
	initGuiApp
}
	
function clockWindowsApp()
{
	Start-Process (Resolve-Path "C:\Program Files\WindowsApps\Microsoft.WindowsAlarms*x64*\Time.exe")[-1]
}
Set-Alias -Name clock -Value clockWindowsApp
function Start-TerminalUserMode
{
	$TerminalPath =	(Resolve-Path "C:\Program Files\WindowsApps\Microsoft.WindowsTerminal_*x64*\wt.exe")[-1]
	$terminalArgument = "$TerminalPath $args"
	Start-Process explorer.exe -ArgumentList ($terminalArgument)
}
Set-Alias -Name wtuser -Value Start-TerminalUserMode
$global:initialModuleList=@(
	"quickWebAction",
	"quickVimAction",
	"quickPSReadLine"
)
$global:extraModuleList = @(
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
	Set-PSReadLineKeyHandler -Key Tab -ScriptBlock { Invoke-FzfTabCompletion }
	# Set-PsFzfOption -TabExpansion
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
					Set-Location (split-path (where.exe $files) -Parent)
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
{ #for environment variable.

	#If not set ProgramFilesD
	#[Environment]::SetEnvironmentVariable('ProgramFilesD', "D:\Program Files",'Machine') 
	#$Env:GoDir = "C:\Program Files\Go\bin\"
	$Env:ProgramFilesD = "D:\Program Files"
	$Env:ProgramDataD = "D:\ProgramDataD"
	$env:dotfilesRepo = "$Env:ProgramDataD\dotfiles"
	$Env:VSDir = "$env:ProgramDataD\Visual Studio"
	$Env:mozillaDir = "$Env:ProgramFilesD\Mozilla Firefox\"
	$Env:ChromeDir="$env:ProgramFiles\Google\Chrome\Application"
	# $Env:PhotoshopDir = "C:\Program Files\Adobe\Adobe Photoshop 2023\"
	# $Env:vlcDir = "$env:ProgramFiles\VideoLAN\VLC\"
	$Env:GoTiengVietDir = "D:\Program Files\GoTiengViet"
	$Env:p7settingDir = "$env:ProgramDataD/powershell\settings\"
	$Env:CommercialDir = "$env:ProgramDataD/Mua ban TQ - VN\"
	$Env:ahkDirD = "$env:ProgramDataD\ahk\"
	$Env:SysInternalSuite = "$env:ProgramFilesD\SysinternalsSuite\"
	$Env:kicadDir = "$env:ProgramFilesD\KiCad\8.0\bin"
	$Env:kicadSettingDir = "$env:APPDATA\kicad\8.0"
	# $Env:venvsDir = "$env:LOCALAPPDATA\pipx\pipx\venvs\"
	$env:pipxLocalDir = "~\.local\bin"

	$env:obsVault = "D:\ProgramDataD\Notes\Obsidian\Vault_2401\"
	$env:cmakedir = "C:\Program Files\CMake\bin\"
	$env:VulkanSDK="C:\VulkanSDK\*\"
	$env:LuaJitDir = "$Env:ProgramFilesD\LuaJit\luajit\src\"
	$Env:sqlite3Dir = "$env:ProgramFilesD\sqlite3\"
	$Env:cargoDir = "~\.cargo\bin"
	$env:weztermDir = "C:\Program Files\WezTerm\"
	# $Env:hledgerDir = "$env:ProgramFilesD\hledger"
	# $Env:ImageMagickDir = "C:\Program Files\ImageMagick-7.1.1-Q16-HDRI\"
	$diradd = @(
		$Env:PhotoshopDir,$env:vlcDir,
		$Env:ChromeDir,$Env:kicadDir,$Env:SysInternalSuite
		$Env:sqlite3Dir,
		$Env:cargoDir,
		$env:weztermDir,
		$env:pipxLocalDir,
		$env:cmakedir,
		$Env:gotvDir
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

function Switch-Obsidian
{
	Show-Window("Obsidian.exe")
}
Set-Alias -Name shw -Value Show-Window

function omniSearchObsidian
{
	$query = ""
	$args | % {
		$query = $query + "$_%20"
	}
	Start-Process "obsidian://omnisearch?query=$query" &
}

# Set-Alias -Name obs -Value omniSearchObsidian

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

initProfileEnv
initTypicalEditor
initShellApp
initIDE
initAutomate
