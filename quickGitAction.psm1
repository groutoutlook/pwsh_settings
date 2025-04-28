# Git quick action Powershell Modules.
# Import-Module posh-git
# Add-PoshGitToProfile -AllHosts

function quickInitGit($remote = "gh") {
    # Copy-Item "$(zoxide query pwsh)/.github" $pwd -Recurse
    gh repo create --source=. --remote=origin --push
    Copy-Just  && git init && git add * && git cif 
}

function openWebRemote {
    chrome (git remote get-url origin)
}

function gitCloneClipboard(
    $finalDir = $null
) {
    $link = (Get-Clipboard)
    # HACK: Real hack is extracting links from the Markdown links.
    if ($link -match '^\[') {
        $processedLink = $link -replace '^\[(.*)\]\(', "" -replace '\)$', ""
    }
    else {
        $processedLink = $link
    }

    # INFO: match http at start.
    # HACK: in my vimium settings it's pressing `Y`
    if ($processedLink -match "^https") {
        # INFO: here we trim the `?.*` queries part of the URL.
        $trimmedQueryURI = $processedLink -replace "\?.*", "" -replace "/tree/.*", ""
        git clone  "--recursive" ($trimmedQueryURI) $finalDir
    }
    else {
        echo ($link).psobject
        Write-Host "Not a link." -ForegroundColor Red
    }

}
Set-Alias -Name gccb -Value gitCloneClipboard


function copyFilesFromOnlineRepos($URI = "", $gitDoc = "" , $OutFile = "") {
    if ($URI -eq "") {
        $processedURI = [URI](Get-Clipboard)
    }
    else {
        $processedURI = [URI]$URI 
    }
    if ($gitDoc -eq "") {
        $finalName = $processedURI.Segments[-1]
    }
    else {
        $finalName = $gitDoc
    }
    if ($OutFile -eq "") {
        $destinationFile = $finalName
    }
    else {
        $destinationFile = $OutFile
    }
    Invoke-WebRequest -Uri $processedURI -OutFile ./$destinationFile && bat ./$destinationFile
}
Set-Alias -Name cpGit -Value copyFilesFromOnlineRepos -Scope Global








