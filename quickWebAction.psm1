$global:lookupSite = @{
    "reddit"     =  "site%3Areddit.com"
    "rd"         =  "site%3Areddit.com"
    "hackernews" =  "site%3Anews.ycombinator.com"
    "hn"         =  "site%3Anews.ycombinator.com"
    "gh"         =  "site%3Agithub.com"
    "gist"       =  "site%3Agist.github.com"
    "gits"       =  "site%3Agist.github.com"
    "so"         = "site%3Astackoverflow.com"
    "st"         = "site%3Astackexchange.com"
    "su"         = "site%3Asuperuser.com"
    "elec"       = "site%3Aelectronic.stackexchange.com"
    "ms"         = "site%3Alearn.microsoft.com"
    "pwsh"       = "site%3Alearn.microsoft.com" # NOTE: Since it's the same to search pwsh in msdoc.
}
# FIXME: Reason I have to use that variable because of the broken state of some browser could..
# affect my speed for accessing things.
$global:defaultBrowser = "msedge"

# reason to make this function is, I may need some kind of initial or something to do some opreataion after firing the query
function hashmapMatch($argsToMatch) {
    $appendix = $global:lookupSite[$argsToMatch]
    if ( $appendix -ne $null) {
        $argsToMatch = $appendix
    } 
    return $argsToMatch

}

function hvdic(
    $phrase,
    $space_split = 1
) {	
    $query = 'https://hvdic.thivien.net/whv/'
    if ($null -eq $phrase) {
        $phrase = (Get-Clipboard)
    }
    if ($space_split -eq 1) {
        $phrase.ToCharArray() | % { 
            $link = $query + "$_" 
            $url = $link.Substring(0, $link.Length)
            Invoke-Expression "$global:defaultBrowser $url"
        }
    }
}

# INFO: Bang! syntax is useful. You could always search for it.
# 
function Search-DuckDuckGo {
    # TODO: Should make a list of abbrev about what to saerch here.
    # For example, $args[0] -eq ok --> $args[0] = placeholder
    if ($args[0] -match "^(?:cb|gcb)") {
        $args[0] = (Get-Clipboard)
    }
    elseif ($args[0] -match "^ok$") {
        $args[0] = "PlaceholderQuery"
    }
  
    $args[-1] = hashmapMatch($args[-1])
    $global:oldQuery = $args
			
    $query = 'https://www.duckduckgo.com/?q='
    $args | % { $query = $query + "$_+" }
    $url = $query.Substring(0, $query.Length - 1)
    Invoke-Expression "$global:defaultBrowser $url"
}

Set-Alias -Name ddg -Value Search-DuckDuckGo
Set-Alias -Name dg -Value Search-DuckDuckGo
Set-Alias -Name gos -Value Search-DuckDuckGo
Set-Alias -Name gg -Value Search-DuckDuckGo

function compSearch {
    $query = 'https://componentsearchengine.com/search?term='
    $args | % { $query = $query + "$_+" }
    $url = $query.Substring(0, $query.Length - 1)
    Start-Process "$url"

}
Set-Alias -Name comps -Value compSearch

Add-Type -AssemblyName System.Windows.Forms
function pwshOcr {
    Start-Process "https://translate.google.com/?sl=zh-CN&tl=en&op=images"
    Start-Sleep -Milliseconds 1000
    [System.Windows.Forms.SendKeys]::SendWait("^v")
}

# HACK: abbreviate translation function to this.
function tra {
    $isClipboardString = (Get-Clipboard).Length
    if ($isClipboardString -eq 0) {
        # INFO: pwsh-ocr definitely.
        pwshOcr 

    }
    else {
        if ($args[0] -eq "zh") {
            $translateFragment = "sl=en&tl=zh-CN"
        }
        else {
            $translateFragment = "sl=zh-CN&tl=en"
        }
        $uri = "https://translate.google.com/?$translateFragment&text="
    (Get-Clipboard).ToCharArray() | % { $uri += $_ }
        $finalUri = $uri + '&op=translate'
        Start-Process $finalUri
    }
}


function Get-CodeStats($webui = 0) {
    $timeNow = Get-Date
    if ($webui -ne 0) {
        msedge https://codestats.net/users/groutlloyd
    }
    else {
        $global:currentCodeStats = (`
                Invoke-RestMethod -Method GET -Uri http://codestats.net/api/users/groutlloyd -HttpVersion 1.1
        )
		
        Write-Host "new_xp which is on streak: " -ForegroundColor Green -NoNewline
        Write-Host " $($global:currentCodeStats.new_xp)" -ForegroundColor Red
        Write-Output $global:currentCodeStats.languages
        # $XPbyDate = $currentCodeStats.dates.PSobject.Members | Where { $_.MemberType -eq "NoteProperty" }
        # $LatestDate = (Get-Date $XPbyDate[-1].Name)	
     
        $yesterday = (Get-Date).AddDays(-1)
        $dateKeyvalue = ($yesterday).Date.ToString("yyyy-MM-dd")
        $yesterdayXP = $global:currentCodeStats.dates.$dateKeyvalue
        if ($yesterdayXP -lt 1000) {
            Write-Output "Haven't code for a whole day you lazy ass."
        }
        else {
            Write-Host "Yesterday XP " -NoNewline; Write-Host "$yesterdayXP" -ForegroundColor Red
        }
    }
} 

Set-Alias -Name cst -Value Get-CodeStats 
# INFO: Streaming services quick-access
# Twitch and Youtube.
$dictStreamPage = @{
    "tw" = "https://www.twitch.tv/groutnotout"
    "yt" = "https://www.youtube.com/@dell_p1/streams"
}

function obss {
    Show-Window obs64
}
function Start-Streaming($defaultPages = "tw") {
  
    $streamingHomepageURI = $dictStreamPage[$defaultPages] 
    $streamingHomepageURI ??= $dictStreamPage["tw"] 
    # INFO: Basically wrapping around the `obs-cmd` executable.
    # Or just simply invoke the shortcut.
    try {
    (Get-Process -Name obs64 -ErrorAction Stop) `
            && obs-cmd streaming start && obs-cmd replay start

    }
    catch [Microsoft.PowerShell.Commands.ProcessCommandException] {
        Write-Host "Havent started OBS Studio yet." -ForegroundColor Red
        Start-Process "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Scoop Apps\OBS Studio.lnk"
    }
}
Set-Alias sstream Start-Streaming
function Stop-Streaming {
    # HACK: This is too linear though. Maybe we need them to express more information, or clean the output...
    # Havent thought of it yet.
    obs-cmd streaming stop
    obs-cmd recording stop
    obs-cmd replay save
    obs-cmd replay stop
}

Set-Alias kstream Stop-Streaming

function Test-Stream(
    $defaultPages = "tw",
    $checkStatus = "cli" 
) {
    # Since chrome have my account registered, better automate it here.
    $defaultStreamingBrowser = "msedge" 
    # HACK: It's relying on replay status since I toggled it on the same time as streaming.
    # Should be changed when we have a command like `streaming status` available.
    $outputCheck = (obs-cmd replay status) | Select-String -Pattern "not"
    if ($null -ne $outputCheck) {
        Write-Host "Stream havent started." -ForegroundColor Red
    }
    else {
        Write-Host "Stream started." -ForegroundColor Green
    }

    if ($checkStatus -match "^cli") {
        # there may be elegant ways to do this, just implemented something as `obs-cmd streaming status`
        Write-Host "Check web portal." -ForegroundColor Yellow
        # $checkStatus = "web"
    } 
    if ($checkStatus -match "^w") {
        $streamingHomepageURI = $dictStreamPage[$defaultPages] 
        $streamingHomepageURI ??= $dictStreamPage["tw"] 

        Invoke-Expression "$defaultStreamingBrowser $streamingHomepageURI"
    }
}
Set-Alias ckstream Test-Stream
