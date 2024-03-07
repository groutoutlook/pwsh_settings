# powershell-5.1
Set-Alias -Name p5 -Value 'C:\WINDOWS\system32\WindowsPowerShell\v1.0\powershell.exe'
# powershell-7.4
Set-Alias -Name pw -Value "C:\Program Files\PowerShell\7\pwsh.exe"

function initTypicalEditor
{	
	#joplin
	Set-Alias -Name jopl -Value 'C:\Program Files\Joplin\Joplin.exe' -Scope Global
	# sublime - python in android.
	Set-Alias -Name subl -Value 'D:\ProgramFileNoSpace\Sublime Text\subl' -Scope Global #-Option AllScope
	# notepad++ - editing powershell file
	Set-Alias -Name np -Value 'C:\Program Files\Notepad++\notepad++.exe' -Scope Global #-Option AllScope
	Set-Alias -Name npp -Value np -Scope Global #-Option AllScope
	# notepad2 - edit single powershell files
	Set-Alias -Name np2 -Value 'C:\Program Files\Notepad2\Notepad2.exe' -Scope Global #-Option AllScope
	# notepad3 - edit single powershell files
	Set-Alias -Name np3 -Value 'C:\Program Files\Notepad3\Notepad3.exe' -Scope Global #-Option AllScope
}

function initAutomate
{
	Set-Alias -Name dto -Value "D:\Program Files\Ditto\Ditto" -Scope Global
	Set-Alias -Name ahk -Value "C:\Program Files\AutoHotkey\UX\ui-dash.ahk" -Scope Global
}

function initIDE
{
	# vscode, but maybe we don't need that.
	Set-Alias -Name vsco -Value 'C:\Users\grout\AppData\Local\Programs\Microsoft VS Code\bin\code' -Scope Global #-Option AllScope
	# visual studio
	# Set-Alias -Name vist -Value 'C:\Program Files\Microsoft Visual Studio\2022\Community\Common7\IDE\devenv.exe' -Scope Global #-Option AllScope
	Set-Alias -Name devenv -Value 'C:\Program Files\Microsoft Visual Studio\2022\Community\Common7\IDE\devenv.exe' -Scope Global #-Option AllScope
	# keil UV4
	Set-Alias -Name uv4 -Value 'C:\Keil_v5\UV4\uv4.exe' -Scope Global #-Option AllScope
	# pms
	Set-alias -name pms -Value "C:\PADAUK_Tool\0.97C9\FPPA IDE.exe" -Scope Global
}

function initShellApp
{
	#Set-Alias -Name tran -Value transInArch -Scope Global
}
function initSSH
{
	
}

function initGuiApp
{
	# #clean keyboard?
	# Set-alias -Name iwck -Value "D:\ProgramData\Visual Studio\ahk\repos\I-wanna-clean-keyboard\iwck-VNT.exe" -Scope Global
	# # WingetUI?
	# Set-Alias -Name wgui -Value "D:\Program Files\WingetUI\wingetui.exe" -Scope Global
	# Devtoys
	# Set-Alias -Name devt -Value "C:\Program Files\WindowsApps\64360VelerSoftware.DevToys_1.0.13.0_x64__j80j2txgjg9dj\DevToys.exe"
	# Set-Alias -Name devt -Value "start-Process -FilePath devtoys://" -Scope Global
	# WSL Toolbox
	# Set-Alias -Name wslt -Value "D:\Program Files\WSL Toolbox\toolbox.exe" -Scope Global
	# btop4win. there is ntop as well.
	# Set-Alias -Name btop -value "C:\Program Files\btop4win\btop4win.exe" -Scope Global
	# # psexec
	# Set-Alias -Name psexec -Value "D:\ProgramData\PSTools\psexec.exe" -Scope Global
	# AdvancedRun
	# Set-Alias -Name adrun -Value "D:\Program Files\AdvancedRun\AdvancedRun.exe" -Scope Global
	# # taskbar activate
	# Set-alias -name tbhide -Value "D:\Program Files\Taskbar Activate\TaskbarActivate.exe" -Scope Global
	#
	
}

function initMediaPlayer
{
	# # Everyonepiano
	# Set-Alias -Name piano -Value "D:\Program Files\EveryonePiano\EveryonePiano.exe" -Scope Global
	Set-Alias -Name mousekey -Value "${env:ahkDirD}proj\MouseKeysPlusPlus\MouseKeys++.exe" -Scope Global
	# VLC
	Set-Alias -Name vlc -Value "vlc.exe" -Scope Global
	# ifranview
	Set-Alias -Name iview -Value "C:\Program Files\IrfanView\i_view64.exe" -Scope Global
}

$global:p7Profile = $PROFILE.AllUsersCurrentHost
function p7Env
{
	nvim $p7Profile
}

function backupEnv
{
	$terminalSettings = "C:\Users\COHOTECH\AppData\Local\Packages\Microsoft.WindowsTerminalPreview_8wekyb3d8bbwe\LocalState\settings.json"
	$dotfiles = @(
		$p7Profile,
		"~/.gitconfig",
		$terminalSettings
	)
	foreach($dotfile in $dotfiles)
	{
		(cp $dotfile "$Env:p7settingDir")
		echo "$dotfile backed up"
	}
}
Set-Alias -Name p7Backup -Value backupEnv

function google-search
{
	if($args[0] -match "yt")
	{
		$query = 'https://www.youtube.com/results?search_query='
		$reargs = $args | Select-Object -Skip 1
		foreach($ar in $reargs)
		{
			$query = $query + "$ar+"
		}
	} else
	{
		$query = 'https://www.google.com/search?q='
		$args | % { $query = $query + "$_+" }
	}
	$url = $query.Substring(0, $query.Length - 1)
	start "$url"
}

Set-Alias -Name gos -Value google-search
Set-Alias -Name gso -Value google-search

function P7
{
	#oh-my-posh -> https://ohmyposh.dev/docs/installation/customize
	Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete
	# Invoke-Expression (& { (zoxide init powershell | Out-String) })
	Invoke-Expression (&starship init powershell)
	cd $env:VSDir
	initGuiApp
	initChat
	initMediaPlayer
}
Set-Alias -Name p7in -Value p7 -Scope Global #-Option AllScope
	
function Invoke-Tere()
{
	$result = . (Get-Command -CommandType Application tere) $args
	if ($result)
	{
		Set-Location $result
	}
}
Set-Alias tere Invoke-Tere

function clockWindowsApp()
{
	Start-Process "C:\Program Files\WindowsApps\Microsoft.WindowsAlarms*x64*\Time.exe"
}
Set-Alias -Name clock -Value clockWindowsApp
function todoWindowsApp()
{
	Start-Process "C:\Program Files\WindowsApps\Microsoft.Todos*x64*\Todo.exe"
}
Set-Alias -Name todo -Value todoWindowsApp
function MoreTerminalModule
{
	#External pwsh module
	Import-Module -Name F7History -Scope Global 
	# Import-Module -Name Terminal-Icons -Scope Global
	Import-Module -Name PSFzf -Scope Global 
	# replace 'Ctrl+t' and 'Ctrl+r' with your preferred bindings:
	Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+t' -PSReadlineChordReverseHistory 'Ctrl+r' 
	Set-PSReadLineKeyHandler -Key Tab -ScriptBlock { Invoke-FzfTabCompletion }
	Set-PsFzfOption -TabExpansion
	#Import-Module -Name VirtualDesktop -Scope Global -Verbose
	#example (get-process notepad*)[0].MainWindowHandle | Move-Window (Get-CurrentDesktop) | Out-Null
	
	$Env:gkPath = "$env:LOCALAPPDATA\gitkraken\"
	# $Env:sourceTreePath = "$env:LOCALAPPDATA\SourceTree\"
	$Env:SMergePath = "C:\Program Files\Sublime Merge"
	$diradd = @($Env:gkPath,
		$Env:SMergePath
		# $Env:sourceTreePath,
	)
	foreach($d in $diradd)
	{
		$Env:Path += ";"+$d;
	}
	
	
	# Self-made module
	Import-Module -Name ($env:p7settingDir+"quickMathAction") 
	Import-Module -Name ($env:p7settingDir+"quickGitAction") -Scope Global 
	Import-Module -Name ($env:p7settingDir+"quickTerminalAction") -Scope Global
	Import-Module -Name ($env:p7settingDir+"quickFilePathAction") -Scope Global
	#clear
}
$global:personalModuleList = @(
	"quickMathAction",
	"quickGitAction",
	"quickTerminalAction",
	"quickFilePathAction"
)

function Reload-Module-List
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


Set-Alias -Name p7mod -Value MoreTerminalModule

#open system shell
function syssh
{
	# AdvancedRun
	Set-Alias -Name adrun -Value "D:\Program Files\AdvancedRun\AdvancedRun.exe" -Scope Global
	adrun /exefilename "C:\Program Files\PowerShell\7\pwsh.exe" /runas 4 /run
}

$text_arr = "np","subl","jopl"
$ide_arr  = "brk","codi","vsco","vist"


function return_alias_def ($str = "np",$name_only = 1)
{
	$path_prog = (GET-ALIAS | WHERE {$_.NAME -eq $str}).Definition
	$name_prog = ($name_only -eq 1) ? [System.IO.Path]::GetFileNameWithoutExtension($path_prog) : $path_prog
	return $name_prog
}

Set-Alias -Name rals -Value return_alias_def

function closedIfopened($name_prog = "np")
{
	$p = rals ($name_prog)
	$p = Get-Process -Name ($p+"*") 
	Stop-Process -InputObject $p  -ErrorAction SilentlyContinue
	$res = (Get-Process | Where-Object {$p.HasExited})
	if ($res -eq $null)
	{
		return 0;
	} else
	{
		return 1;
	}
}

Set-Alias -Name kipo -Value closedIfopened

function makeDev ($lightweight = 1, $prog_list = $text_arr)
{	

	$opened_list = New-Object System.Collections.Generic.List[System.Object]
	$ide_opening_list = $prog_list.Where{ 
		$_ -ne (($lightweight -eq 1) ? "vist" : "vsco") 
	}
	<#
	$ide_opening_list = $prog_list.Where{ 
		$_ -ne (($lightweight -eq 1) ? "vist" : "vsco") 
	}
	#>
	foreach ($element in $ide_opening_list)
	{
		Start-Process -FilePath (gal -Name $element).Definition
		$opened_list.Add($name_prog)
	}
	return $opened_list

}
Set-Alias -Name mdev -Value makeDev

function killDev ($lightweight = 1, $prog_list = $text_arr)
{
	$closed_list = New-Object System.Collections.Generic.List[System.Object]

	$ide_opening_list = $prog_list.Where{ $_ -ne (($lightweight -eq 1)? "vist" : "vsco") }
	foreach ($element in $ide_opening_list)
	{
		if ((kipo $element) -eq 1)
		{ 
			$closed_list.Add($element)
		}
	}
	return $closed_list
}

Set-Alias -Name kdev -Value killDev

function cdwhere($files = "~")
{
	cd (split-path (where.exe $files) -parent)
}

function killProcess($str = "p5")
{
	#kill all running powershell.
	if($str -eq "all")
	{
		endDev
	} elseif ($str -ne $null)
	{
		kipo  $str
	}
}

Set-Alias -Name kpo -Value killProcess

function profileHelper
{
	
	if((get-module -name "profile_*") -eq $null)
 {
		$old_path = pwd
		$a = $PROFILE | Select-Object *Host*
		$profile_ps1 = ($a).AllUsersCurrentHost 
		cd ([System.IO.Directory]::GetParent($profile_ps1).ToString())
		$module_name = "profile_p7_md"
		$module_ext = ".psm1"
		cp $profile_ps1 ((pwd).ToString() + "\" + $module_name + $module_ext)
		Import-Module ((pwd).ToString() + "\" + $module_name + $module_ext)
		cd $old_path
	}
	get-command -module profile_*
	get-command -Module *profile* | % {get-alias -Definition $_.name -ea 0}
}
Set-Alias -Name pHelp -Value profileHelper
function addPath($dirList)
{
	
	foreach($d in $dirList)
 {
		$d = Resolve-Path $d
		$Env:Path += ";"+$d;
	}
}

function initProfileEnv
{ #for environment variable.

	#If not set ProgramFilesD
	#[Environment]::SetEnvironmentVariable('ProgramFilesD', "D:\Program Files",'Machine') 
	$Env:VSDir = "D:\ProgramDataD\Visual Studio"
	#$Env:GoDir = "C:\Program Files\Go\bin\"
	$Env:ProgramFilesD = "D:\ProgramFilesD"
	$Env:ProgramDataD = "D:\ProgramDataD"
	$Env:mozillaDir = $Env:ProgramFilesD + "/Mozilla Firefox/"
	$Env:ChromeDir="C:\Program Files\Google\Chrome\Application"
	# $Env:PhotoshopDir = "C:\Program Files\Adobe\Adobe Photoshop 2023\"
	$Env:vlcDir = "C:\Program Files\VideoLAN\VLC\"
	$Env:p7settingDir = "D:\ProgramDataD\powershell\settings\"
	$Env:CommercialDir = "D:\ProgramDataD\Mua ban TQ - VN\"
	$Env:ahkDirD = "D:\ProgramDataD\ahk\"
	$Env:SysInternalSuite = "D:\Program Files\SysinternalsSuite\"
	$Env:OfficeDir = "C:\Program Files\Microsoft Office\Office16\"
	$Env:kicadDir = "D:\Program Files\KiCad\8.0\bin"
	$Env:venvsDir = "C:\Users\COHOTECH\AppData\Local\pipx\pipx\venvs\"


	$Env:sqlite3Dir = "D:\Program Files\sqlite3\"
	$Env:cargoDir = "C:\Users\COHOTECH\.cargo\bin"
	$Env:hledgerDir = "D:\Program Files\hledger"
	# $Env:ImageMagickDir = "C:\Program Files\ImageMagick-7.1.1-Q16-HDRI\"
	$diradd = @(
		$Env:mozillaDir,$Env:PhotoshopDir,$env:vlcDir,
		$Env:CommercialDir,$Env:ahkDirD,$Env:OfficeDir,
		$Env:ChromeDir,$Env:kicadDir,$Env:SysInternalSuite
		$Env:hledgerDir,$Env:sqlite3Dir,$Env:venvsDir,
		$Env:cargoDir
	)
	foreach($d in $diradd)
	{
		$Env:Path += ";"+$d;
	}
	$Env:PSModulePath += ";" + $Env:p7settingDir 
}

function Show-Window
{
	param(
		[Parameter(Mandatory)]
		[string] $ProcessName
	)
	

	# As a courtesy, strip '.exe' from the name, if present.
	$ProcessName = $ProcessName -replace '\.exe$'

	# Get the ID of the first instance of a process with the given name
	# that has a non-empty window title.
	# NOTE: If multiple instances have visible windows, it is undefined
	#       which one is returned.
	$procId = (Get-Process -ErrorAction Ignore $ProcessName).Where({ $_.MainWindowTitle }, 'First').Id

	if (-not $procId)
	{ Throw "No $ProcessName process with a non-empty window title found." 
	 return 1
	}

	# Note: 
	#  * This can still fail, because the window could have been closed since
	#    the title was obtained.
	#  * If the target window is currently minimized, it gets the *focus*, but is
	#    *not restored*.
	#  * The return value is $true only if the window still existed and was *not
	#    minimized*; this means that returning $false can mean EITHER that the
	#    window doesn't exist OR that it just happened to be minimized.
	$null = (New-Object -ComObject WScript.Shell).AppActivate($procId)
}

function obs
{
	Show-Window("Obsidian.exe")	
}
Set-Alias -Name shw -Value Show-Window


function initChat
{ #for environment variable.
	$Env:ZaloDir = "C:\Users\ADMIN\AppData\Local\Programs\Zalo/"
	$Env:WeChatDir = "C:\Program Files\Tencent\WeChat"
	$Env:Path += ";"+$env:ZaloDir+";"+$env:WeChatDir #add firefox to path.

	Set-Alias -Name wec -Value "wechat.exe" -Scope Global #-Option AllScope
	#Set-Alias -Name zl -Value "zalo.exe" -Scope Global #-Option AllScope
}
function zl()
{
	chrome https://chat.zalo.me
} 

function hn()
{
	Start-Process https://news.ycombinator.com/

}

function cd-
{
	Set-Location -
}

function cd+
{
	Set-Location +
}


. C:\Users\COHOTECH\AppData\Roaming\dystroy\broot\config\launcher\powershell\br.ps1
#p7in
initProfileEnv
initTypicalEditor
initShellApp
initIDE
initAutomate
initSSH
