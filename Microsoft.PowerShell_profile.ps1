# powershell-5.1
Set-Alias -Name p5 -Value 'C:\WINDOWS\system32\WindowsPowerShell\v1.0\powershell.exe'

function Dirs
{
	Get-Location -Stack
}

$global:localPathNvim = "$env:p7settingDir\Microsoft.PowerShell_profile.ps1"
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
	Copy-Item $global:localPathNvim $($PROFILE.CurrentUserCurrentHost) -Force
	Write-Host "[$(Get-Date)] Move Profile. CurrentUserCurrentHost" -ForegroundColor Green
}
Set-Alias -Name p7Backup -Value Backup-Environment


function AppendPrompt
{
	function global:prompt
	{
		if ($null -ne $__zoxide_prompt_old)
		{
			& $__zoxide_prompt_old
		}
		$null = __zoxide_hook
	}

}

function P7()
{
	Invoke-Expression (&starship init powershell)
	# oh-my-posh init pwsh | Invoke-Expression
	Invoke-Expression (& { (zoxide init powershell | Out-String) })
	Set-Alias -Name cd -Value z -Scope Global -Option AllScope 
	Set-Alias -Name cdi -Value zi -Scope Global -Option AllScope 
	AppendPrompt
}



$global:initialModuleList=@(
	"quickWebAction",
	"quickVimAction",
	"quickPSReadLine",
	"quickPwshUtils.psm1",
	"CLI-Basic"
)

$global:extraModuleList = @(
	"CLI-Extra",
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
	Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+t' -PSReadlineChordReverseHistory 'Ctrl+r' -TabExpansion -AltCCommand $null
	Set-PSReadLineKeyHandler -Key Tab -ScriptBlock { Invoke-FzfTabCompletion }
	# Import-Module -Name VirtualDesktop -Scope Global -Verbose
	
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
		Import-Module -Name ("$env:p7settingDir$module") -Scope Global -Force
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
function cdcb(
	[Parameter(ValueFromPipeline = $true)]
	$defaultDir = (Get-Clipboard)
)
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

function Set-LocationWhere(
	[Parameter(
		# Mandatory = $true,
		ValueFromPipeline = $true
	)]
	$files = (Get-Clipboard)
)
{
	$commandInfo = (get-Command $files -ErrorAction SilentlyContinue)
	# echo ($commandInfo).psobject
	if ($null -ne $commandInfo)
	{
		switch -Exact ($commandInfo.CommandType)
		{
			"Application"
			{
				# INFO: We need something to detect executable here. Mostly exe files but there could also be other type as well.
				if ($commandInfo.Extension -match "exe")
				{
					# $listBinaries = (where.exe $files)
					$listBinaries = (Resolve-Path (scoop w $files)).ToString()
					# echo ($listBinaries).psobject
					
					# TypeNames           : {System.Object[], System.Array, System.Object}
					try
					{ $fileType = (${listBinaries}?.PsObject.TypeNames[0]) 
					} catch
					{
						Write-Host "From local dir not path." -ForegroundColor Blue
					}
					# echo ($fileType).psobject
					if ($fileType -match "Array" -or $fileType -match "Object\[\]")
					{
						Write-Host "Multiple Locations!`n" -ForegroundColor Yellow
						$finalBinariesPath = $listBinaries | fzf
					} elseif ($fileType -match "String")
					{
						$finalBinariesPath = $listBinaries
					} else
					{
						$finalBinariesPath = $files
					}
					# echo $finalBinariesPath.psobject
					Set-Location (Split-Path ($finalBinariesPath) -Parent)
				} else
				{
					echo "cdcb"
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
			default 
			{ 
				Write-Host "shim files?" -ForegroundColor Red -BackgroundColor Yellow
				$fileName = ($files)
				try
				{
					Get-Content "$env:LOCALAPPDATA/shims/$fileName.ps1" |`
							Select-Object -Index 0 |`
							Get-PathFromFiles | cdcb
				} catch
				{
				 Write-Error "Had tried, still failed on shim."
				}
			}  # optional
		} 
	}
	# INFO: deal with directory.
	elseif(($info = Get-Item $files -ErrorAction SilentlyContinue).LinkType -eq "SymbolicLink")
	{
		Set-Location $info.Target
	} else
	{
		$fileType = (($files).PsObject.TypeNames)[0]
		# echo $files
		if ($fileType -match "Array" -or $fileType -match "Object\[\]")
		{
			$finalBinariesPath = $files | fzf
			Set-Location (split-path ($finalBinariesPath) -Parent)
			# return $null;
		} else
		{
			cdcb $files
		}
	}
}

Set-Alias -Name cdw -Value Set-LocationWhere
Set-Alias -Name cdwhere -Value Set-LocationWhere

function addPath
{ 
	param (# Parameter help description
  [Parameter(
			# Mandatory = $true,
			ValueFromPipeline = $true
		)]
  [Alias("d")]
  $dirList = $pwd,

  
  [Parameter(Mandatory=$false)]
  [Alias("p")]
  $parent = $null
	)


	foreach($dir in $dirList)
	{
		if($null -ne $parent)
  {
			$dir = Split-Path $dir -Parent
		} else
		{
			$dir
		}
		$d = Resolve-Path $dir
		
		$Env:Path += ";"+$d;
	}
}

function global:initProfileEnv
{ 
	[Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.UTF8Encoding]::new()
	$PSDefaultParameterValues['Out-File:Encoding']='utf8'

	$Env:ProgramFilesD = "D:\Program Files"
	$Env:ProgramDataD = "D:\ProgramDataD"
	$Env:dotfilesRepo = "$Env:ProgramDataD\dotfiles"
	$Env:ChromeDir="$env:ProgramFiles\Google\Chrome\Application"
	$Env:p7settingDir = "$env:ProgramDataD/powershell\settings\"

	$Env:pipxLocalDir = "~\.local\bin"

	$Env:obsVault = "$Env:ProgramDataD\Notes\Obsidian\Vault_2401\"
	$Env:usrbinD="D:\usr\bin"
	$Env:edgeDir = "${env:PROGRAMFILES(X86)}\Microsoft\Edge\Application\"
	$diradd = @(
		$Env:usrbinD
		,$Env:PhotoshopDir
		,$Env:ChromeDir
		,$Env:pipxLocalDir
		,$Env:edgeDir
	)
	foreach($d in $diradd)
	{
		$Env:Path += ";"+$d;
	}
}

# INFO: cd- and cd--, same logic with cd+ and cd++
function cd-($rep = 1)
{
	foreach($i in (1..$rep))
 {
		Set-Location -
	}
}
function cd--($rep = 1)
{
	foreach($i in (1..$rep+1))
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

function cd++($rep = 1)
{
	foreach($i in (1..$rep+1))
 {
		Set-Location +
	}
}

function cd..($rep = 1)
{
	$furtherParent = $pwd
	foreach($i in (1..$rep))
 {
		$furtherParent = Split-Path -Path $furtherParent -Parent
	}
	Set-Location $furtherParent
}

function ...($rep = 1)
{
	cd.. $rep
}


function ....($rep = 1)
{
	cd.. ($rep+1)
}


# INFO: Rescue explorer function.
function Restart-Explorer
{
	Stop-Process -Name explorer 
}
Set-Alias -Name resexp -Value Restart-Explorer

initProfileEnv
initShellApp
# Import-Module PSCompletions
