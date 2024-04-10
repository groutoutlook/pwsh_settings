

$global:lookupSite = @{
  "reddit" =  "site%3Areddit.com"
  "rd" =  "site%3Areddit.com"
  "hackernews" =  "site%3Anews.ycombinator.com"
  "hn" =  "site%3Anews.ycombinator.com"
  "gh" =  "site%3Agithub.com"
  "sov" = "site%3Astackoverflow.com"
  "stex" = "site%3Astackexchange.com"
  "su" = "site%3Asuperuser.com"
  "cst" = "site%3Acodestats.net"
  "codestat" = "site%3Acodestats.net"
  "elec" = "site%3Aelectronic.stackexchange.com"
}

function Search-Google
{
  if($args[0] -match "^yt")
  {
    if ($args[1] -match "^(?:cb|gcb)")
    {
      $args[1] = (Get-Clipboard)
    }
    $query = 'https://www.youtube.com/results?search_query='
    $reargs = $args | Select-Object -Skip 1
    foreach($ar in $reargs)
    {
      $query = $query + "$ar+"
    }
  } else
  {
    if ($args[0] -match "^(?:cb|gcb)")
    {
      $args[0] = (Get-Clipboard)
    }
    $appendix = $global:lookupSite[$args[-1]]
    if( $appendix -ne $null)
    {
      $args[-1] = $appendix
    } 
    $global:oldQuery = $args
		
    $query = 'https://www.google.com/search?q='
    $args | ForEach-Object { $query = $query + "$_+" }
  }
  $url = $query.Substring(0, $query.Length - 1)
  Start-Process "$url"
}

Set-Alias -Name gos -Value Search-Google
Set-Alias -Name gg -Value Search-Google


function hvdic(
  $phrase,
  $space_split = 1
)
{	
  $query = 'https://hvdic.thivien.net/whv/'
  if ($phrase -match "^(?:cb|gcb)")
  {
    $phrase = (Get-Clipboard)
  }
  if($space_split -eq 1)
  {
    $phrase.ToCharArray() | % { 
      $link = $query + "$_" 
      $url = $link.Substring(0, $link.Length)
      start "$url"
    }
  }
}


function DuckDuckGo
{

  if ($args[0] -match "^(?:cb|gcb)")
  {
    $args[0] = (Get-Clipboard)
  }
  $appendix = $global:lookupSite[$args[-1]]
  if( $appendix -ne $null)
  {
    $args[-1] = $appendix
  } 
		
  $query = 'https://www.duckduckgo.com/?q='
  $args | % { $query = $query + "$_+" }
  $url = $query.Substring(0, $query.Length - 1)
  Start-Process "$url"
}

Set-Alias -Name ddg -Value DuckDuckGo
Set-Alias -Name dg -Value DuckDuckGo


function compSearch
{
  $query = 'https://componentsearchengine.com/search?term='
  $args | % { $query = $query + "$_+" }
  $url = $query.Substring(0, $query.Length - 1)
  Start-Process "$url"

}
Set-Alias -Name comps -Value compSearch



function ocr
{
  Start-Process "https://translate.google.com/?sl=zh-CN&tl=en&op=images"
}


function Get-CodeStats($webui = 0)
{
  $timeNow = Get-Date
  if($webui -ne 0)
  {
    msedge https://codestats.net/users/groutlloyd
  } else
  {
    $global:currentCodeStats = (Invoke-restMethod -Method GET -URI http://codestats.net/api/users/groutlloyd -HttpVersion 1.1)
		
    Write-Output $global:currentCodeStats
    Write-Output $global:currentCodeStats.languages
    $XPbyDate = $currentCodeStats.dates.PSobject.Members | Where { $_.MemberType -eq "NoteProperty" }
    $LatestDate = (Get-Date $XPbyDate[-1].Name)	
    if(($timeNow-$LatestDate).Hours -gt 24)
    {
      Write-Output "Haven't code for a whole day you lazy ass."
    } else
    {
      $yesterdayXP = $XPbyDate[-2].Value
      Write-Output "Yesterday XP $yesterdayXP"
    }
  }
} 
Set-Alias -Name cst -Value Get-CodeStats 

