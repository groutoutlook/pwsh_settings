
function retty {
    Set-Buffer-Width-To-Screen-Width
    Clear-Host
}

function Set-Buffer-Width-To-Screen-Width {
    $h = Get-Host
    $ui = $h.UI.RawUI
    $bufferSize = $ui.BufferSize
    $windowSize = $ui.WindowSize
    $bufferSize.Width = $windowSize.Width
    $ui.BufferSize = $bufferSize
}

function pipi($control_string){
	Start-Process "py -m pip install $controll_stirng"
}

function term($which = "win"){
	if($which -eq "and"){
		$command = '-f new-tab --suppressApplicationTitle -p "P7_Android"  pwsh -NoExit -Command "anddev && p7 && p7mod"; split-pane --size 0.5 -H -p "P7_Android" pwsh -NoExit -Command "anddev && p7 && p7mod"'
		start wt "$command"
	}
	elseif($which -eq "win"){
		start wt '-f new-tab -p "P7_OrangeBackground" pwsh -NoExit -Command "p7 && p7mod"; split-pane --size 0.5 -H -p "P7_OrangeBackground" pwsh -NoExit -Command "p7 && p7mod"'
	}
	elseif($which -eq "ssh"){
		start wt '-F new-tab -p "ssh" split-pane --size 0.5 -V -p "ssh_1" ; split-pane --size 0.5 -V -p "ssh_1" ; move-focus first ; split-pane --size 0.5 -V -p "ssh_1" ; move-focus first ; split-pane --size 0.5 -H -p "ssh_2" ; move-focus right ; split-pane --size 0.5 -H -p "ssh_2" ; move-focus right ; split-pane --size 0.5 -H -p "ssh_2" ; move-focus right ; split-pane --size 0.5 -H -p "ssh_2" pwsh -NoExit -Command "anddev && p7 && p7mod"'
	}
	elseif($which -eq "lin"){
		start wt '-F new-tab -p "ssh_3" split-pane --size 0.5 -V -p "ssh_3" ; move-focus first ; split-pane --size 0.5 -H -p "ssh_4" ; move-focus right ; split-pane --size 0.5 -H -p "ssh_4" pwsh -NoExit -Command "p7 && p7mod"'
	}
	#kawt "P7_P"	
}
function androidDevEnv{
	$Env:P7AndroidDir = "C:\ProgramDataD\Visual Studio\powershell\Proj\ADB_P7\"
	$Env:BinAndroidDir = "C:\ProgramDataD\Visual Studio\pyhelpers\ADB_Scrcpy\bin\scrcpy\"
	$diradd = @($Env:P7AndroidDir,$Env:BinAndroidDir)
	foreach($d in $diradd){
		$Env:Path += ";"+$d;
	}
	
	Import-Module -Name ($env:P7AndroidDir+"ADB_BasicModule") -Scope Global

}
Set-Alias -Name andDev -Value androidDevEnv