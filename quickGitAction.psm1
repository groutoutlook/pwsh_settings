# Git quick action Powershell Modules.
#Import-Module posh-git
#Add-PoshGitToProfile -AllHosts


function quickInitGit{
	git init && git add * && gitmoji -c
}

function openWebRemote{
	chrome (git remote get-url origin)
}




function copyFilesFromOnlineRepos($URI = "", $gitDoc = "" , $OutFile =""){
	if($URI -eq ""){$processedURI = [URI](Get-Clipboard)}
	else{$processedURI = [URI]$URI }
	if($gitDoc -eq ""){$finalName = $processedURI.Segments[-1]}
	else{$finalName = $gitDoc}
	if($OutFile -eq ""){$destinationFile = $finalName}
	else{$destinationFile = $OutFile}
	iwr -uri $processedURI -OutFile ./$destinationFile && bat ./$destinationFile
}
Set-Alias -Name cpGit -Value copyFilesFromOnlineRepos -Scope Global
