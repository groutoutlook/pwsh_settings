# powershell-5.1
# Set-Alias -Name p5 -Value 'C:\WINDOWS\system32\WindowsPowerShell\v1.0\powershell.exe'
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

# function initSSH
# {
# 	
# }

function initGuiApp
{
	Set-Alias -Name dsview -Value $env:ProgramFiles\DSView\DSView.exe -Scope Global
	Set-Alias -Name pentab -Value "$env:ProgramFiles\Pentablet\PenTablet.exe" -Scope Global
	Set-Alias -Name ptoy -Value "$env:ProgramFiles\PowerToys\PowerToys.exe" -Scope Global
	Set-Alias -Name libload -Value "$env:ProgramData\Microsoft\Windows\Start Menu\Programs\Library Loader\Library Loader.lnk" -Scope Global
}

function initChat
{ #for environment variable.
	$Env:WeChatDir = "C:\Program Files\Tencent\WeChat"
	Set-Alias -Name wec -Value "$env:ProgramFiles\Tencent\WeChat\wechat.exe" -Scope Global #-Option AllScope
	Set-Alias -Name discord -Value "$env:APPDATA\Roaming\Microsoft\Start Menu\Programs\Discord Inc\discord.lnk"
	$Env:TelegramDir = 'D:\Program Files\Telegram'
	Set-Alias -Name teleg -Value "$Env:TelegramDir\Telegram.exe" -Scope Global #-Option AllScope
}
function zl()
{
	Write-Output "do you want to open zlc instead? It's in Chrome."
	Start-Process "$env:LOCALAPPDATA\Programs\Zalo\zalo.exe"
}
function Browse-CodeStats($webui = 0)
{
	$timeNow = Get-Date
	if($webui -ne 0)
 {
		msedge https://codestats.net/users/groutlloyd
	} else
	{
		$global:currentCodeStats = (Invoke-restMethod -Method GET -URI http://codestats.net/api/users/groutlloyd -HttpVersion 1.1)
		
		Write-Output $global:currentCodeStats
		Write-Output $global:currentCodeStats.languages
		$XPbyDate = $currentCodeStats.dates.PSobject.Members | Where { $_.MemberType -eq "NoteProperty" }
		$LatestDate = (Get-Date $XPbyDate[-1].Name)	
		if(($timeNow-$LatestDate).Hours -gt 24)
		{
			Write-Output "Haven't code for a whole day you lazy ass."
		} else
		{
			$yesterdayXP = $XPbyDate[-2].Value
			Write-Output "Yesterday XP $yesterdayXP"
		}
	}
} 
Set-Alias -Name cst -Value Browse-CodeStats 
function goviet
{
	$currentGTVProcess = (Get-Process -Name GoTiengViet)
	if($currentGTVProcess.Id -eq $null)
	{
		Start-Process "$env:GoTiengVietDir/GoTiengViet.exe"
	} else
	{
		Stop-Process -Id $currentGTVProcess.Id 
		Start-Process "$env:GoTiengVietDir/GoTiengViet.exe"
	}
}
function initMediaPlayer
{
	# # Everyonepiano
	# Set-Alias -Name piano -Value "$env:ProgramFilesD\EveryonePiano\EveryonePiano.exe" -Scope Global
}

$global:p7Profile = $PROFILE.AllUsersCurrentHost
function global:p7Env
{
	$LastWrite = (Get-ItemProperty ($PROFILE.AllUsersCurrentHost)).LastWriteTimeString
	nvim $p7Profile
	$NewLastWrite = (Get-ItemProperty ($PROFILE.AllUsersCurrentHost)).LastWriteTimeString
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
	Copy-Item $p7Profile "$env:p7settingDir"
	Push-Location $env:p7settingDir
	Push-Location $env:dotfilesRepo

	Set-Location $env:dotfilesRepo
}
Set-Alias -Name p7Backup -Value Backup-Environment

function P7
{
	# oh-my-posh -> https://ohmyposh.dev/docs/installation/customize
	# Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete
	# Invoke-Expression (& { (zoxide init powershell | Out-String) })
	Invoke-Expression (&starship init powershell)
	initGuiApp
	initChat
	initMediaPlayer
}
Set-Alias -Name p7in -Value p7 -Scope Global #-Option AllScope
	
function clockWindowsApp()
{
	Start-Process (Resolve-Path "C:\Program Files\WindowsApps\Microsoft.WindowsAlarms*x64*\Time.exe")[-1]
}
Set-Alias -Name clock -Value clockWindowsApp
# function todoWindowsApp()
# {
# 	Start-Process (Resolve-Path "C:\Program Files\WindowsApps\Microsoft.Todos*x64*\Todo.exe")[-1]
# }
# Set-Alias -Name todo -Value todoWindowsApp
#
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
		# echo "Done here"
	}
}
Set-Alias -Name p7mod -Value MoreTerminalModule
function initShellApp
{
	foreach($module in $global:initialModuleList)
 {
		Import-Module -Name ("$env:p7settingDir$module") -Scope Global 
		# echo Nope.
	}
}
function Reload-Module-List
{
	param (
		[array]$ModuleList = $global:personalModuleList,
		[string]$ModulePath = $env:p7settingDir
	)
	foreach($ModuleName in $ModuleList)
	{
		# Write-Output $ModuleName
		Remove-Module -Name "$ModulePath$ModuleName" -ErrorAction SilentlyContinue
		Import-Module -Name "$ModulePath$ModuleName" -Force 
		Write-Output "$ModuleName reimported"
	}
}

function global:Reload-Profile($option = "env")
{
	if ($option -match "^all")
	{
		Reload-Module-List
		. $PROFILE.AllUsersCurrentHost
		Write-Output "Reload profile and All module."
	} else
	{
		. $PROFILE.AllUsersCurrentHost
		Write-Output "Reload pwsh Profile."
	}
}
Set-Alias -Name repro -Value Reload-Profile
Set-Alias -Name p7pro -Value Reload-Profile
function Set-LocationWhere($files = "~")
{
	$commandInfo = (get-Command $files)
	switch -Exact ($commandInfo.CommandType)
	{
		"Application"
		{
			Set-Location (split-path (where.exe $files) -Parent)
			; break; 
		}
		"Alias"
		{
			Set-Location (split-path (($commandInfo).Definition) -Parent)
			; break;
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
	# $Env:hledgerDir = "$env:ProgramFilesD\hledger"
	# $Env:ImageMagickDir = "C:\Program Files\ImageMagick-7.1.1-Q16-HDRI\"
	$diradd = @(
		$Env:PhotoshopDir,$env:vlcDir,
		$Env:ChromeDir,$Env:kicadDir,$Env:SysInternalSuite
		$Env:sqlite3Dir,
		$Env:cargoDir,
		# $env:LuaJitDir,
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

Set-Alias -Name obs -Value omniSearchObsidian

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
