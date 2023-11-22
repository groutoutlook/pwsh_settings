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

function  TerminalStartDev($myconfig = 0){
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
		<#
		foreach($dt in $dtopList){
			Switch-Desktop $dt
			#$TerminalInDesktop = [PaneManager]::new("P7_android","P7_OrangeBackground");
			start wt $TerminalInDesktop;
		}
		#>
	}
}

Set-alias -Name TSDev -Value TerminalStartDev 











