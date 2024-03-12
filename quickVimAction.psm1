


function :q
{
  exit
}



# Quick way to reload profile and turn back to the default pwsh
# There's some other effects, so I may need to dig further I think?
function :new
{
  pwsh && :q
}

