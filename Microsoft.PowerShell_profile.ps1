# powershell-5.1
Set-Alias -Name p5 -Value 'C:\WINDOWS\system32\WindowsPowerShell\v1.0\powershell.exe'
# powershell-7.4
Set-Alias -Name pw -Value "C:\Program Files\PowerShell\7\pwsh.exe"

function initTypicalEditor{	
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

function initAutomate{
	Set-Alias -Name dto -Value "D:\Program Files\Ditto\Ditto" -Scope Global
	Set-Alias -Name ahk -Value "C:\Program Files\AutoHotkey\UX\ui-dash.ahk" -Scope Global
}

function initIDE{
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

function initShellApp{
	#Set-Alias -Name tran -Value transInArch -Scope Global
}
function initSSH{
	
}

function initGuiApp{
	# #clean keyboard?
	# Set-alias -Name iwck -Value "D:\ProgramData\Visual Studio\ahk\repos\I-wanna-clean-keyboard\iwck-VNT.exe" -Scope Global
	# # WingetUI?
	# Set-Alias -Name wgui -Value "D:\Program Files\WingetUI\wingetui.exe" -Scope Global
	# Devtoys
	#Set-Alias -Name devt -Value "C:\Program Files\WindowsApps\64360VelerSoftware.DevToys_1.0.13.0_x64__j80j2txgjg9dj\DevToys.exe"
	Set-Alias -Name devt -Value "start-Process -FilePath devtoys://" -Scope Global
	# WSL Toolbox
	Set-Alias -Name wslt -Value "D:\Program Files\WSL Toolbox\toolbox.exe" -Scope Global
	# btop4win. there is ntop as well.
	Set-Alias -Name btop -value "C:\Program Files\btop4win\btop4win.exe" -Scope Global
	# # psexec
	# Set-Alias -Name psexec -Value "D:\ProgramData\PSTools\psexec.exe" -Scope Global
	# AdvancedRun
	# Set-Alias -Name adrun -Value "D:\Program Files\AdvancedRun\AdvancedRun.exe" -Scope Global
	# # taskbar activate
	# Set-alias -name tbhide -Value "D:\Program Files\Taskbar Activate\TaskbarActivate.exe" -Scope Global
	#
}

function initMediaPlayer{
	# # Everyonepiano
	# Set-Alias -Name piano -Value "D:\Program Files\EveryonePiano\EveryonePiano.exe" -Scope Global
Set-Alias -Name mousekey -Value "${env:ahkDirD}proj\MouseKeysPlusPlus\MouseKeys++.exe" -Scope Global
	# VLC
	Set-Alias -Name vlc -Value "vlc.exe" -Scope Global
	# ifranview
	Set-Alias -Name iview -Value "C:\Program Files\IrfanView\i_view64.exe" -Scope Global
}


function google-search {
	if($args[0] -match "yt"){
		$query = 'https://www.youtube.com/results?search_query='
		$reargs = $args | Select-Object -Skip 1
		foreach($ar in $reargs){
			$query = $query + "$ar+"
		}
	}
	else{
		$query = 'https://www.google.com/search?q='
		$args | % { $query = $query + "$_+" }
	}
	$url = $query.Substring(0, $query.Length - 1)
	start "$url"
}

#https://translate.google.com/?sl=en&tl=zh-CN&op=translate
function google-translate-tab(
	$text = "Placeholder",
	$sourceLang = "zh-CN",
	$resLang = "en",
	$opWord = "translate")
{
	if($sourceLang -eq "en"){
		if($resLang -eq "en"){
			$resLang = "zh-CN"
		}
	}
	$query = 'https://translate.google.com/'
	$url = ('{0}?sl={1}&tl={2}&text={3}&op={4}' -f $query,$sourceLang,$resLang,$text,$opWord)
	start "$url"
	
}
Set-Alias -Name gos -Value google-search


Set-Alias -Name gotr -Value google-translate-tab
Set-Alias -Name trans -Value google-translate-tab

function transInArch{
	wsl -d arch2308 bash -c 'gawk -f <(curl -Ls --compressed https://git.io/translate) -- -shell'
	#wsl -d arch2308 bash -c 'gawk -f < (trans) > -shell'
}
function P7{
	#oh-my-posh -> https://ohmyposh.dev/docs/installation/customize
	Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete
	Invoke-Expression (& { (zoxide init powershell | Out-String) })
	Invoke-Expression (&starship init powershell)
	cd $env:VSDir
	initGuiApp
	initChat
	initMediaPlayer
}
Set-Alias -Name p7in -Value p7 -Scope Global #-Option AllScope
	

function MoreTerminalModule{
	#External pwsh module
	Import-Module -Name F7History -Scope Global
	Import-Module -Name Terminal-Icons -Scope Global
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
	foreach($d in $diradd){
		$Env:Path += ";"+$d;
	}
	
	
	# Self-made module
	Import-Module -Name ($env:p7settingDir+"quickMathAction") -Scope Global
	Import-Module -Name ($env:p7settingDir+"quickGitAction") -Scope Global
	Import-Module -Name ($env:p7settingDir+"quickTerminalAction") -Scope Global
	Import-Module -Name ($env:p7settingDir+"quickFilePathAction") -Scope Global
	#clear
}
Set-Alias -Name p7mod -Value MoreTerminalModule

#open system shell
function syssh{
	# AdvancedRun
	Set-Alias -Name adrun -Value "D:\Program Files\AdvancedRun\AdvancedRun.exe" -Scope Global
	adrun /exefilename "C:\Program Files\PowerShell\7\pwsh.exe" /runas 4 /run
}

$text_arr = "np","subl","jopl"
$ide_arr  = "brk","codi","vsco","vist"


function return_alias_def ($str = "np",$name_only = 1){
	$path_prog = (GET-ALIAS | WHERE {$_.NAME -eq $str}).Definition
	$name_prog = ($name_only -eq 1) ? [System.IO.Path]::GetFileNameWithoutExtension($path_prog) : $path_prog
	return $name_prog
}

Set-Alias -Name rals -Value return_alias_def

function closedIfopened($name_prog = "np"){
	$p = rals ($name_prog)
	$p = Get-Process -Name ($p+"*") 
	Stop-Process -InputObject $p  -ErrorAction SilentlyContinue
	$res = (Get-Process | Where-Object {$p.HasExited})
	if ($res -eq $null) {
		return 0;
	}
	else{
		return 1;
	}
}

Set-Alias -Name kipo -Value closedIfopened

function makeDev ($lightweight = 1, $prog_list = $text_arr){	

	$opened_list = New-Object System.Collections.Generic.List[System.Object]
	$ide_opening_list = $prog_list.Where{ 
		$_ -ne (($lightweight -eq 1) ? "vist" : "vsco") 
	}
	<#
	$ide_opening_list = $prog_list.Where{ 
		$_ -ne (($lightweight -eq 1) ? "vist" : "vsco") 
	}
	#>
	foreach ($element in $ide_opening_list) {
		Start-Process -FilePath (gal -Name $element).Definition
		$opened_list.Add($name_prog)
	}
	return $opened_list

}
Set-Alias -Name mdev -Value makeDev

function killDev ($lightweight = 1, $prog_list = $text_arr){
	$closed_list = New-Object System.Collections.Generic.List[System.Object]

	$ide_opening_list = $prog_list.Where{ $_ -ne (($lightweight -eq 1)? "vist" : "vsco") }
	foreach ($element in $ide_opening_list) {
		if ((kipo $element) -eq 1){ 
			$closed_list.Add($element)
		}
	}
	return $closed_list
}

Set-Alias -Name kdev -Value killDev

function cdwhere($files = "~"){
	cd (split-path (where.exe $files) -parent)
}

function killProcess($str = "p5"){
	#kill all running powershell.
	if($str -eq "all"){
		endDev
	}
	elseif ($str -ne $null) {
		kipo  $str
	}
}

Set-Alias -Name kpo -Value killProcess

function profileHelper{
	
	if((get-module -name "profile_*") -eq $null){
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

function initProfileEnv{ #for environment variable.

	#If not set ProgramFilesD
	#[Environment]::SetEnvironmentVariable('ProgramFilesD', "D:\Program Files",'Machine') 
	$Env:VSDir = "D:\ProgramDataD\Visual Studio"
	#$Env:GoDir = "C:\Program Files\Go\bin\"
	$Env:ProgramFilesD = "C:\ProgramFilesD"
	$Env:mozillaDir = $Env:ProgramFilesD + "/Mozilla Firefox/"
	$Env:ChromeDir="C:\Program Files\Google\Chrome\Application"
	$Env:PhotoshopDir = "C:\Program Files\Adobe\Adobe Photoshop 2023\"
	$Env:vlcDir = "C:\Program Files\VideoLAN\VLC\"
	$Env:p7settingDir = "D:\ProgramDataD\powershell\settings\"
	$Env:CommercialDir = "D:\ProgramDataD\Mua ban TQ - VN\"
	$Env:ahkDirD = "D:\ProgramDataD\ahk\"
	$Env:OfficeDir = "C:\Program Files\Microsoft Office\Office16\"
	# $Env:komorebiDir = "C:\Program Files\komorebi\bin\"
	$Env:ngrokDir = "D:\ProgramDataD\Visual Studio\ssh_http\bin\"
	$Env:ImageMagickDir = "C:\Program Files\ImageMagick-7.1.1-Q16-HDRI\"
	$diradd = @(
	$Env:mozillaDir,$Env:PhotoshopDir,$env:vlcDir,
	$Env:CommercialDir,$Env:ahkDirD,$Env:OfficeDir,
	$Env:ChromeDir,$Env:ngrokDir
	# ,$Env:komorebiDir
	)
	foreach($d in $diradd){
		$Env:Path += ";"+$d;
	}
	$Env:PSModulePath += ";" + $Env:p7settingDir 
}

function initChat{ #for environment variable.
	$Env:ZaloDir = "C:\Users\ADMIN\AppData\Local\Programs\Zalo/"
	$Env:WeChatDir = "C:\Program Files (x86)\Tencent\WeChat"
	$Env:Path += ";"+$env:ZaloDir+";"+$env:WeChatDir #add firefox to path.

	Set-Alias -Name zl -Value "zalo.exe" -Scope Global #-Option AllScope
	Set-Alias -Name wec -Value "wechat.exe" -Scope Global #-Option AllScope

}
#p7in
initProfileEnv
initTypicalEditor
initShellApp
initIDE
initAutomate
initSSH