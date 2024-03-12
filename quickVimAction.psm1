


function :q
{
  exit
}



# Quick way to reload profile and turn back to the default pwsh
# There's some other effects, so I may need to dig further I think?
function :n($p7 = 0) 
{
  if($p7 -eq 0)
  {
    pwsh && :q
  } else
  {
    pwsh -Noexit -Command "p7 && p7mod" && :q
  }
}

function :nm
{
  :n 7
}

