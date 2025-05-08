# Git quick action Powershell Modules.
# Import-Module posh-git
# Add-PoshGitToProfile -AllHosts

function quickInitGit($repo_name = "$(Split-Path $pwd -Leaf)", $remote_branch_name = "origin", $remote = "gh", $default_user = "groutoutlook") {
    # Copy-Item "$(zoxide query pwsh)/.github" $pwd -Recurse
    Copy-Just && git init && git add * && git commit -m "feat: genesis"
    gh repo create $repo_name -d "$repo_name description" --source=. --remote "$remote_branch_name" --push --private
}

function quickDeInitGit($repo_name = "$(Split-Path $pwd -Leaf)", $remote = "gh", $default_user = "groutoutlook") {
    Remove-FullForce .git
    Set-Clipboard "$default_user/$repo_name"
    gh repo delete $repo_name
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
