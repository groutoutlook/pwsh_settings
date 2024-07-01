# Git quick action Powershell Modules.
#Import-Module posh-git
#Add-PoshGitToProfile -AllHosts


function quickInitGit
{
	Copy-Cliff `
		&& Copy-Just `
		&& git init && git add * && gitmoji -c `

}

function openWebRemote
{
	chrome (git remote get-url origin)
}

function gitCloneClipboard($link = (Get-Clipboard))
{
	if ($link -match "^https")
 {
		# INFO: here we trim the `?.*` queries part of the URL.
		$trimmedQueryURI = $link -replace "\?.*",""
		git clone ($trimmedQueryURI)
	} else
	{
		Write-Host "Not a link." -ForegroundColor Red
	}

}
Set-Alias -Name gccb -Value gitCloneClipboard


function copyFilesFromOnlineRepos($URI = "", $gitDoc = "" , $OutFile ="")
{
	if($URI -eq "")
	{$processedURI = [URI](Get-Clipboard)
 } else
	{$processedURI = [URI]$URI 
 }
	if($gitDoc -eq "")
	{$finalName = $processedURI.Segments[-1]
 } else
	{$finalName = $gitDoc
 }
	if($OutFile -eq "")
	{$destinationFile = $finalName
 } else
	{$destinationFile = $OutFile
 }
	Invoke-WebRequest -uri $processedURI -OutFile ./$destinationFile && bat ./$destinationFile
}
Set-Alias -Name cpGit -Value copyFilesFromOnlineRepos -Scope Global
