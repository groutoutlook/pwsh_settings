

$global:lookupSite = @{
  "reddit" =  "site%3Areddit.com"
  "rd" =  "site%3Areddit.com"
  "hackernews" =  "site%3Anews.ycombinator.com"
  "hn" =  "site%3Anews.ycombinator.com"
  "sov" = "site%3Astackoverflow.com"
  "stex" = "site%3Astackexchange.com"
  "su" = "site%3Asuperuser.com"
}

function Search-Google
{
  if($args[0] -match "^yt")
  {
    if ($args[1] -match "^gcb")
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
    if ($args[0] -match "^gcb")
    {
      $args[0] = (Get-Clipboard)
    }
    $appendix = $global:lookupSite[$args[-1]]
    if( $appendix -ne $null)
    {
      $args[-1] = $appendix
    } 
		
    $query = 'https://www.google.com/search?q='
    $args | % { $query = $query + "$_+" }
  }
  $url = $query.Substring(0, $query.Length - 1)
  Start-Process "$url"
}

Set-Alias -Name gos -Value Search-Google



function DuckDuckGo
{

  if ($args[0] -match "^gcb")
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



