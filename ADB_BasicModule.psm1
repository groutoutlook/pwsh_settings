# Declare global.
$global:mainphone = "d5664d5e"
$global:auxphone = "R3CN90L0VFB"
#oppoA9


function ADB_getSerialList(){
		$list = (adb devices | Select-String -Pattern "device")
		$serialList = $list[1..$list.count] | % {$_ -replace ".device",""} # since before device, we have a whitespace(tab).
		return $serialList
}

Set-Alias -Name adbList -Value ADB_getSerialList -Scope Global

function checkLocalIP($devs = $global:srl){
	$iplist=@()
	foreach($emulator in $devs){
		$iplist += (adb -s $emulator shell 'ifconfig | grep -o "addr:.*Bcast" | grep -Eo "[0-9].*\ "').Trim() # -> https://devblogs.microsoft.com/scripting/trim-your-strings-with-powershell/
	}
	return $iplist
}
($global:srl = adbList)
($global:iplist = checkLocalIP)

function newDev{
	($global:srl = adblist)
}


function offscr(){
		adb shell input keyevent 26
}



function connectAllIP($devs = $global:iplist){
	$iplist=@()
	foreach($emulator in $devs){
		(adb connect ("${emulator}:5555"))
	}
	 return $iplist
}


function SSH_getHostName(){
	
}


function castADBShell($command){
	foreach($emulator in $global:srl){adb -s $emulator shell $command}
}

function initSSH($sshlist = $global:iplist){
	# powershell sendkeys. -> https://stackoverflow.com/questions/19824799/how-to-send-ctrl-or-alt-any-other-key
	# https://learn.microsoft.com/en-us/windows/terminal/customize-settings/actions
	
	foreach($emuhost in $sshlist){
		(ssh -s $emuhost -p8022)
	}
}

function scrAll($devs = $global:srl, $x_space = 450){
	$ind=0
	$width=$x_space
	foreach($emuhost in $devs){
		$xcoor = $ind*$width
		Start-Job ( scrcpy -s $emuhost --video-codec=h265 --video-bit-rate=1M --window-x="$xcoor" --window-y=0 --window-borderless  &) # start a job, detach the process from the terminal.
		$ind+=1
	}
}

function castSSH($command){
	foreach($emulator in $global:srl){adb -s $emulator shell $command}
}

function checkadb($options = "bat"){
	if ($options -match "bat"){
		foreach($emulator in $global:srl){adb -s $emulator shell "dumpsys battery | grep -e level"}
	}
	elseif ($options -match "temp"){
		foreach($emulator in $global:srl){adb -s $emulator shell "dumpsys battery | grep -e temperature"}
	}
}


function installAllApk($filepath){
	foreach($emulator in $global:srl){
	(adb -s $emulator install $filepath )
}
}

function invokeShizuku($installed = 1){
	
	if($installed -eq 0){
		installallApk "D:\ProgramDataD\pyhelpers\ADB_Scrcpy\repos\shizuku-v13.5.1.r1025.ebb2a30-release.apk"
	}
	
	foreach($emulator in $srl){
		adb -s $emulator shell sh /storage/emulated/0/Android/data/moe.shizuku.privileged.api/start.sh
	}
}

function pushpullAllFiles($method = "push" , $src,  $dst){
	foreach($emulator in $global:srl){
		
		if ($method -match "push"){
			$filename = (Split-Path $src -Leaf)
			(adb -s $emulator $method $src ($dst + "/" + $filename))
		}
		else{
			$filename = ($emulator+"_") +  (Split-Path $src -Leaf)
			(adb -s $emulator $method $src (Join-Path $dst $filename))
		}
	}
}

Set-Alias -Name offs -Value offscr -Scope Global


function ScrOff($devs = $global:srl){
	foreach ($emulator in $devs){
		(adb -s $emulator shell 'CLASSPATH=/storage/emulated/0/DisplayToggle.dex app_process / DisplayToggle 0')
	}
}

function ScrMain($emulator = $global:mainphone,  $xcoor = 1300){
		#1450
		if($emulator -eq $global:mainphone){ $winTitle = "OppoA9"}
		else{
			$winTitle = $emulator
		}
		(scrcpy -s $emulator --video-codec=h264 --video-bit-rate=2M --audio-output-buffer=20 --window-x="$xcoor" --window-y=0  --window-borderless --window-title $winTitle --raw-key-events &) | Out-Null
}


function ScrAux($emulator = $global:auxphone,  $xcoor = 0){
		#
	if($emulator -eq $global:auxphone){ $winTitle = "ZFold2_1"}
	else{
		$winTitle = $emulator
	}
	(scrcpy -s $emulator --video-codec=h265 --video-bit-rate=2M --audio-output-buffer=25 `
	--window-x="$xcoor" --window-y=0  --window-borderless --window-title $winTitle `
	--raw-key-events &) | Out-Null
}

function camAux($emulator = $global:auxphone,  $xcoor = 0){
	if($emulator -eq $global:auxphone){ $winTitle = "Camera_ZFold2_1"}
	else{
		$winTitle = $emulator
	}
	(scrcpy -s $emulator --video-source=camera --camera-id=1 `
	--audio-output-buffer=25 --window-x="$xcoor" --window-y=0 `
	 --window-borderless --window-title $winTitle &) | Out-Null
}

function ScrNoti($emulator = $global:mainphone,  $xcoor = 1300){
		#1450
		if($emulator -eq $global:mainphone){ $winTitle = "OppoA9"}
		else{
			$winTitle = $emulator
		}
		$winTitle = "Noti_"+$winTitle
		(scrcpy -s $emulator --video-codec=h265 --video-bit-rate=2M --no-audio --window-x="$xcoor" --window-y=0  --crop=580:120:0:0 --window-borderless --window-title $winTitle --raw-key-events &)
		sleep -ms 1000
		$jobList = (Get-Job)
		foreach($job in $jobList){
			if($job.command -match "--crop"){
				if($job.State -eq "Running"){
					Write-host "ok noti ran"
				}
				else{
					Write-host "no noti end."
				}
			} 
		}
}




function forwardUSBADB($emulator = $global:mainphone,  $remoteport = "tcp:8022",  $localport = "tcp:8022"){
	 (adb -s $emulator forward $localport  $remoteport )
}

function typevn {
	$string = ""
	$srgs_ind = 0
	if ($args[-1]  -match '^\d+$' ){
		$emulator = $global:srl[$args[-1]];
	}
	else{
		$emulator = $global:mainphone;
		$srgs_ind = -1
	}
	
	foreach($ar in $args){
		$srgs_ind += 1;
		if($srgs_ind -eq $args.Count) {
			break;
		}
		$string = $string + "$ar ";# + "\ ";
		
	}
	# $args | % { $string = $string + "$_" + "\ " }
	# $text=$string.replace(" ","\ ");
	$text = $string
	# echo $emulator;
	set-clipboard $text
	adb -s $emulator  shell input keyevent 279
	# (adb -s $emulator shell am broadcast -a ADB_INPUT_TEXT --es msg $text);
	adb -s $emulator  shell input keyevent KEYCODE_ENTER; #Keyevent enter.
}


Set-Alias -Name vntype -Value typevn -Scope Global
Set-Alias -Name vnty -Value typevn -Scope Global
Set-Alias -Name tyvn -Value typevn -Scope Global


function typewe{
	$string = ""
	$srgs_ind = 0
	if ($args[-1]  -match '^\d+$' ){
		$emulator = $global:srl[$args[-1]];
	}
	else{
		$emulator = $global:mainphone;
		$srgs_ind = -1
	}
	
	foreach($ar in $args){
		$srgs_ind += 1;
		if($srgs_ind -eq $args.Count) {
			break;
		}
		$string = $string + "$ar" + "\ ";
		
	}
	# $args | % { $string = $string + "$_" + "\ " }
	# $text=$string.replace(" ","\ ");
	$text = $string
	# echo $text
	adb -s $emulator shell "input tap 180 1450" # position of textbox,  could detect through uiautomator dump.
	(adb -s $emulator shell am broadcast -a ADB_INPUT_TEXT --es msg $text);
	adb -s $emulator  shell "input keyevent KEYCODE_TAB && input keyevent KEYCODE_TAB && input keyevent KEYCODE_ENTER"; 
}

Set-Alias -Name wetype -Value typewe -Scope Global
Set-Alias -Name wety -Value typewe -Scope Global
Set-Alias -Name tywe -Value typewe -Scope Global
