using namespace System.Collections.Generic
import-module -Name VirtualDesktop


# Encapsulate an arbitrary command
class PaneCommand {
    [string]$Command

    PaneCommand() {
        $this.Command = "";
    }

    PaneCommand([string]$command) {
        $this.Command = $command
    }

    [string]GetCommand() {
        return $this.Command
    }

    [string]ToString() {
        return $this.GetCommand();
    }
}

# A proxy for Split Pane which takes in a command to run inside the pane
class Pane : PaneCommand {
    [string]$ProfileName;
    [string]$Orientation
    [decimal]$Size;

    Pane([string]$command) : base($command) {
        $this.Orientation = '';
        $this.ProfileName = "P7_OrangeBackground"
        $this.Size = 0.5;
    }

    Pane([string]$command, [string]$orientation) : base($command) {
        $this.Orientation = $orientation;
        $this.ProfileName = "P7_OrangeBackground"
        $this.Size = 0.5;
    }

    Pane([string]$command, [string]$orientation, [decimal]$size) : base($command) {
        $this.Orientation = $orientation;
        $this.ProfileName = "P7_OrangeBackground"
        $this.size = $size;
    }
    
    Pane([string]$ProfileName, [string]$command, [string]$orientation, [decimal]$size) : base($command) {
        $this.Orientation = $orientation;
        $this.ProfileName = $ProfileName;
        $this.size = $size;
    }

    [string]GetCommand() {
        return 'split-pane --size {0} {1} -p "{2}" -c {3}' -f $this.Size, $this.Orientation, $this.ProfileName, $this.Command
    }
}

class TargetPane : PaneCommand {
    [int]$SelectedIndex;

    TargetPane([int]$index) {
        $this.SelectedIndex = $index;
    }

    [string]GetCommand() {
        return "focus-pane --target={0}" -f $this.SelectedIndex;
    }
}

class MoveFocus : PaneCommand {
    [string]$direction;

    MoveFocus([string]$direction) {
        $this.direction = $direction;
    }

    [string]GetCommand() {
        return 'move-focus --direction {0}' -f $this.direction;
    }
}

class PaneManager : PaneCommand {
    [string]$InitialCommand;
    [List[PaneCommand]]$PaneCommands;
    [string]$ProfileName;
    [string]$FirstInTab;
    [string]$DefaultOrientation;
    [double]$DefaultSize;

    PaneManager() {
        $this.PaneCommands = [List[PaneCommand]]::new();
        $this.ProfileName = "P7_OrangeBackground";
        $this.DefaultOrientation = '-H';
        $this.DefaultSize = 0.5;
		$this.FirstInTab = "arch2308"
        $this.InitialCommand = [string]::Format("-F new-tab -p {0}",($this.FirstInTab))#"--maximized"
    }

    PaneManager([string]$ProfileName) {
        $this.ProfileName = $ProfileName;
        $this.DefaultOrientation = '-H';
        $this.DefaultSize = 0.5;
    }

    PaneManager([string]$ProfileName,[string]$FirstPane) {
        $this.ProfileName = $ProfileName;
        $this.FirstInTab = $FirstPane;
        $this.DefaultOrientation = '-H';
        $this.DefaultSize = 0.5;
        $this.InitialCommand = [string]::Format("-F new-tab -p {0}",($this.FirstInTab))#"--maximized"
    }


    [PaneManager]SetInitialCommand([string]$command) {
        $this.InitialCommand = $command;
        return $this;
    }

    [PaneManager]SetProfileName([string]$name) {
        $this.ProfileName = $name;
        return $this;
    }

    [PaneManager]SetDefaultOrientation([string]$orientation) {
        $this.DefaultOrientation = $orientation;
        return $this;
    }

    [PaneManager]SetDefaultSize([double]$size) {
        $this.DefaultSize = $size;
        return $this;
    }

    [PaneManager]SetOptions([string]$name, [string]$orientation, [double]$size) {
        return $this.SetProfileName($name)
                .SetDefaultOrientation($orientation)
                .SetDefaultSize($size);

    }

    [PaneManager]AddPane([PaneManager]$manager) {
        $manager.SetInitialCommand('');
        $this.AddCommand($manager);
        return $this;
    }

    [PaneManager]AddCommand([PaneCommand]$command) {
        $this.PaneCommands.Add($command);
        return $this;
    }

    [PaneManager]AddPane([string]$command, [string]$orientation, [decimal]$size) {
        $newPane = $this.MakePane(
            $this.ProfileName, 
            $command, 
            $orientation,
            $size
        );

        $this.AddCommand($newPane);
        return $this;
    }

    [Pane]MakePane($ProfileName, $command, $orientation, $size) {
        $newPane = [Pane]::new($ProfileName, $command, $orientation, $size);
        return $newPane;
    }

    [PaneManager]TargetPane([int]$index) {
        $targetCommand = [TargetPane]::new($index)
        $this.AddCommand($targetCommand)
        return $this;
    }

    [PaneManager]MoveFocus([string]$direction) {
        $targetCommand = [MoveFocus]::new($direction)
        $this.AddCommand($targetCommand)
        return $this;
    }

    [int]GetPaneCount() {
        $count = 0;
        
        foreach ($command in $this.PaneCommands)
        {
            if ($command -is [PaneManager]) {
                $count += $command.GetPaneCount();
            } elseif ($command -is [PaneCommand]) {
                $count += 1;
            }
        }

        return $count;
    }

    [string]GetCommand() {
        
        $joinedCommands = $this.PaneCommands -join "; ";
        
        if ($joinedCommands -eq "") {
            return $this.InitialCommand;
        }

        $finalCommand =  if ($this.InitialCommand -ne "") { "{0}; {1}" -f $this.InitialCommand, $joinedCommands} else { $joinedCommands };
        return $finalCommand
    }
}

function  MakeAllTerminal($myconfig = 2){
	if($myconfig -eq 0){
		# Your script here; see Gist comments -> https://gist.github.com/codebykyle/b241e723ddd495aac4eaad9b8aa7c6bc
		# About_pwsh ->  https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_pwsh?view=powershell-7.3
		(0..10).foreach{md ("d:/"+$_) -ErrorAction SilentlyContinue}
		$rbpRow1 = ([PaneManager]::new()).
						AddPane("pwsh -WorkingDirectory d:/1", '-H', 0.75).
						AddPane("pwsh -WorkingDirectory d:/2",  '-V', 0.5);

		$rbpRow2 = ([PaneManager]::new()).
						MoveFocus("left").
						AddPane("pwsh -WorkingDirectory d:/3",  '-H', 0.66).
						MoveFocus("right").
						AddPane("pwsh -WorkingDirectory d:/4", '-H', 0.66);

		$rbpRow3 = ([PaneManager]::new()).
						MoveFocus("left").
						AddPane("pwsh -WorkingDirectory d:/5", '-H', 0.5).
						MoveFocus("right"). 
						AddPane("pwsh -WorkingDirectory d:/6", '-H', 0.5);

		$piManagers = ([PaneManager])::new().
						AddPane($rbpRow1).
						AddPane($rbpRow2).
						AddPane($rbpRow3)

		$topRow =  ([PaneManager]::new()).
						SetInitialCommand("--maximized").
						AddPane("pwsh -NoExit -Command cd d:/7", '-V', 0.75);

		$bottomRow = ([PaneManager]::new()).
						AddPane("pwsh -NoExit -Command cd d:/8", '-H', 0.1).
						TargetPane(1).
						AddPane($piManagers);

		$paneManager = ([PaneManager]::new()).
						AddPane($topRow).
						TargetPane(0).
						AddPane($bottomRow);

		#echo $paneManager.ToString();
		start wt $paneManager;
		#(0..10).foreach{rm $_}
	} elseif ($myconfig -eq 1){
		(0..10).foreach{rm ("d:/"+$_) -ErrorAction SilentlyContinue}
		Get-ChildItem D:/
	} elseif ($myconfig -eq 2){
		$dtopList = get-desktoplist
		#$ExistedName = New-Object System.Collections.Generic.List[System.Object] #list in powershell.
		$nameList = @("Commercial","TextEditor","Windows","Android","Arch","Ubuntu")
		#$androidHostName = "user@192.168.1.148" 
		$movingProcessTable	=@{	
							"Commercial" = @("vlc","wechat","zalo");
							"TextEditor" = @();
							"Windows" = @();
							"Android" = @();
							"Arch" = @();
							"Ubuntu"  = @(); #"-p ubuntu2307"
							}
		$windowsSplit = (' --size {0} {1} -p "{2}" -c {3}' -f "0.5", "-V", "P7_PurpleBackground", "pwsh -NoExit -Command p7 `n ntop")
		$androidSplit = (' --size {0} {1} -p "{2}" -c {3}' -f "0.5", "-V", "P7_Android", "pwsh -NoExit -Command p7 `n ls `n anddev ")
		$archSplit = (' --size {0} {1} -p "{2}" -c {3}' -f "0.5", "-V", "arch2308", "pwsh -NoExit -Command wsl -d arch2308")
		$ubuntuSplit = (' --size {0} {1} -p "{2}" -c {3}' -f "0.5", "-V", "P7_PurpleBackground", "pwsh -NoExit -Command p7 `n (cd '.\powershell\repos\PowerShell\Scripts\') `n .\write-clock.ps1");
		$splittingPaneTable	=@{	
		 #-f $this.Size, $this.Orientation, $this.ProfileName, $this.Command
							"Commercial" = "";
							"TextEditor" = "";
							"Windows" = $windowsSplit;
							"Android" = $androidSplit;
							"Arch" = $archSplit;
							"Ubuntu"  = $UbuntuSplit; #"-p ubuntu2307"
							}
		$screenSettingTable =@{	
							"Commercial" = "-f";
							"TextEditor" = "-f";
							"Windows" = "-F";
							"Android" = "-F";
							"Arch" = "-F";
							"Ubuntu"  = "-F"; #"-p ubuntu2307"
							}
		 
		$mainTabTable = @{	"Commercial" = "P7_OrangeBackground pwsh -NoExit -Command p7 `n p7mod `n vlc .\Music `n cd '$env:CommercialDir' `n ls `n ";
							"TextEditor" = "P7_PurpleBackground pwsh -NoExit -Command p7 `n p7mod `n ls `n mdev `n";
							"Windows" = "P7_OrangeBackground pwsh -NoExit -Command p7 `n p7mod `n ls";
							"Android" = "P7_Android pwsh -NoExit -Command p7 `n p7mod `n anddev `n adblist";
							#"Android" = "P7_Android pwsh -NoExit -Command p7 `n p7mod `n ssh $androidHostName -p 8022 ";
							"Arch" = "arch2308 pwsh -NoExit -Command wsl -d arch2308"; # -e bash -c 'cd /mnt/d & ls & zsh -c ls & zsh' ";
							"Ubuntu"  = "P7_OrangeBackground pwsh -NoExit -Command p7 `n (cd '.\powershell\repos\PowerShell\Scripts\') `n  .\write-motd.ps1 `n .\write-animated.ps1" #"-p ubuntu2307"
							}
		$DTTable = @{}#hashtable, make a dict with key = desktop name.
		$mainDtop_index = Get-CurrentDesktop | Get-desktopIndex
		
		
		#set name first.
		foreach($dt in $dtopList){ 
			$dtid = $dt.Number
			$dtname = $nameList[$dtid]
			Set-DesktopName -Desktop $dtid -Name $dtname -PassThru | Out-Null ##Get-CurrentDesktop #Switch-Desktop $dtid
		}
		#create wt session.
		foreach($dt in $dtopList){ 
			$dtid = $dt.Number
			$CreatedInfo = Get-Date -Format "yyMM"
			$dtname = $nameList[$dtid]
			$finalDTName = $dtname #($CreatedInfo+$nameList[$dtid])
			$terminalName = $dtname+"wterm"
			$MainProfile = $mainTabTable[$dtname]
			$scrset = $screenSettingTable[$dtname]
			$splitPanes = $splittingPaneTable[$dtname]
			if($splitPanes -ne ""){
				$otherParam = " ; split-pane  --title $terminalName "+ $splitPanes
			}
			(start-process wt "$scrset new-tab --title $terminalName --suppressApplicationTitle  -p $MainProfile $otherParam " -passthru)
			#(get-process | where-object {$_.MainWindowTitle -match "wterm"})
			
			Start-Sleep -Seconds 3
			$TitleToMove = $terminalName
			$terminalHandle = (get-process | where-object {$_.MainWindowTitle -match $TitleToMove})[0].MainWindowHandle 
			Move-Window -Desktop (Get-Desktop $dtid) -Hwnd $terminalHandle | Out-Null
			
			#$DTTable.add($dtid,$terminalName)
			
			#$ExistedName.add($dt.Name)
		}
		<#
		Move windows to the correct desktop.
		#(get-process | where-object {$_.MainWindowTitle -match "wterm"})
			
		foreach($dt in $dtopList){ 
			$dtid = $dt.Number
			$dtname = $nameList[$dtid]
			$terminalName = $dtname+"wterm"
			$TitleToMove = $terminalName
			$terminalHandle = (get-process | where-object {$_.MainWindowTitle -match $TitleToMove})[0].MainWindowHandle 
			$terminalHandle
			#Move-Window -Desktop (Get-Desktop $dtid) -Hwnd $terminalHandle | Out-Null
			#Start-Sleep -Seconds 1 

		}
		#>
		Switch-Desktop $mainDtop_index
		kawt "P7_"
		
	}
}



function KillAllTerminal([String]$Info = "wterm" , [int]$procToKill = 999){
		if(($Info -eq "wterm") -band ($procToKill -eq 999)){
			start-process wt '-f new-tab -p P7_OrangeBackground pwsh -NoExit -Command p7 & p7mod `n'
		}
		$TitleToKill = $Info
		get-process | where-object {$_.MainWindowTitle -match $TitleToKill} | stop-process

		
		<#
		Start-Sleep -Seconds 2
		foreach($dt in $dtopList){
			$wtid = $DTTable[$dt]
			$wtid
			#Stop-Process -Name $wtid
		}
		#>
}

Set-alias -Name mat -Value MakeAllTerminal 
Set-alias -Name kawt -Value KillAllTerminal











