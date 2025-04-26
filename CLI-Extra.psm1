# INFO: Import Completion scripts.
function Import-Completion {
    $completionsDir = "$env:p7settingDir\completions"
    $listImport = Get-ChildItem $completionsDir
    if ($args[0] -eq $null) {
        # $importScripts = $listImport.FullName | fzf 
        $importName = $listImport.BaseName | fzf
        . (Join-Path -Path $completionsDir -ChildPath "$importName.ps1")
    }
    else {
        foreach ($arg in $args) {
            $importName = $arg
            . (Join-Path -Path $completionsDir -ChildPath "$importName.ps1")
        }
    }
}
Set-Alias -Name :cp -Value Import-Completion 


function Get-Playlistmpv(
    [Parameter(Mandatory = $false)]
    [System.String[]]
    [PSDefaultValue(help = "Text/Lines that contain links, hope we can evolve it to file(s)")]
    [Alias("m")]
    $Mode = "normal",
    $last = 100,
    $first = 0,
    $videoOption = "1"
) {
    # HACK: in case we copy a chunk of text with newline.
    # echo ($listURI).PSobject
    $global:playlistTemp = "$HOME/mpv-playing.txt"
    $conditionPlaylist = Test-Path $global:playlistTemp
    if ($conditionPlaylist) {
        Remove-Item $global:playlistTemp -ErrorAction SilentlyContinue -Force
    }
    New-Item $global:playlistTemp

    if ($Mode -match "^n") {
        $playlist_file = fd --hyperlink musicj --base-directory="$(zoxide query obs)" 
        $playlist_file = Join-Path -Path "$(zoxide query obs)" -ChildPath $playlist_file
    (Get-Content -Tail $last $playlist_file) + (Get-Content -Head $first $playlist_file) |
            ForEach-Object { filterURI $_ >> $global:playlistTemp }
        mpv --playlist="$global:playlistTemp"  --ytdl-format=bestvideo[height<=?1080]+bestaudio/best --loop-playlist=1 --vid=$videoOption --ytdl-raw-options="cookies-from-browser=firefox"
    }
    elseif ($Mode -eq "b") {
        $query = 'spacing'
        rg $query -M 400 (zoxide query obs) |
            ForEach-Object { filterURI $_ >> $global:playlistTemp }
        mpv --playlist="$global:playlistTemp"  --ytdl-format=bestvideo[height<=?1080]+bestaudio/best --loop-playlist=1 --vid=no --ytdl-raw-options="cookies-from-browser=firefox"
    }
}

Set-Alias jmpv Get-Playlistmpv



# HACK: launch in different pwsh process.
function mpvc(
    [Parameter(
        # Mandatory = $true,
        ValueFromPipeline = $true
    )]
    [System.String[]]
    [Alias("s")]
    $strings = (Get-Clipboard),
	
    [Parameter(Mandatory = $false)]
    [System.Boolean]
    [PSDefaultValue(help = "Text/Lines that contain links, hope we can evolve it to file(s)")]
    [Alias("b")]
    $Background = $true

) {
    if ($Background) {
        # HACK: clean up old playlist.

        Get-Playlistmpv ($strings)
        # INFO: supress output from start-job.
    (pwsh -Command "mpv --playlist=`"$global:playlistTemp`"" &) | Out-Null
    }
    else {
        Get-Playlistmpv (Get-Clipboard)
    }
}

# HACK: wait for mpv then shutdown hibernate
function Wait-MPVHibernate() {
    while (ps -Name mpv) {
        Start-Sleep -Second 5
        Write-Host "INFO: [$(Get-Date)] mpv running"
    } 
    shutdown /h
}


# INFO: currently it's 1688 desktop chat client.
function aliim { 
    Stop-Process -Name "aliim*"
    if ($null -eq $args[0]) {
        Start-Sleep -Seconds 2
        Start-Process "C:\Program Files (x86)\Ali1688Buyer\AliIM.exe"
        Start-Process "C:\Program Files (x86)\AliWangWang\AliIM.exe"
    }
    elseif ($args[0] -eq "16") {
        Start-Sleep -Seconds 2
        Start-Process "C:\Program Files (x86)\Ali1688Buyer\AliIM.exe"
    }
    elseif ($args[0] -eq "tb") {
        Start-Sleep -Seconds 2
        Start-Process "C:\Program Files (x86)\Ali1688Buyer\AliIM.exe"
    }
    else {
        Write-Host "should be nothing" -ForegroundColor Yellow
    }
}


# INFO: Restart PowerToys due to KeyboardManager stuck keys or Run issues.
function ptoy { 
    Stop-Process -Name "powertoy*"
    if ($null -eq $args[0]) {
        Start-Sleep -Seconds 2
        Start-Process "C:\Program Files\PowerToys\PowerToys.exe"
    }
    else {
        Write-Host "should be nothing" -ForegroundColor Yellow
    }
}

function rds {
    $joinedTerm = $args -join " "
    $command = "rustup doc --std"
    Invoke-Expression $command
    if($null -ne $args){    
        Sleep -Milliseconds 350 
        Send-Key "msedge" "/$joinedTerm"
    }
}
