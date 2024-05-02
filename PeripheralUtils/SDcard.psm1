# INFO: I have used it to load music files into SD cards, large batch of them.
function SDCardCheckAndLoad($drive_name = "E",$data_file = "D:\ProgramDataD\Audio\proj\FireworkMusic_v2.0.mp3")
{
  $sd_used = ((Get-PSDrive -PSProvider FileSystem -Name $drive_name).Used) #or we can index [2] then.
  if($sd_used -ge 1000000)
  {
    echo "have file."
  } elseif(($sd_used -le 1000000) -and ($sd_used -ne $null))
  {
    echo "no file."
    cp "$data_file" ("$drive_name"+":") 
    echo "copied"
  } else
  {
    echo "no disk."
  }
}

function LoopSDCardLoad()
{
  while($true)
  {
    SDCardCheckAndLoad
    sleep 1
  }
}


