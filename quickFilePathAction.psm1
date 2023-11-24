



$global:at_dir = "C:\ProgramDataD\Artery\Proj\TEST\src\"
$global:mm_dir = "C:\ProgramDataD\MindMotion\Proj\12_uart_irq\Project\"

function copyFilestoKeil($Destination, $Source = "C:\ProgramDataD\Visual Studio\ConsoleApplication1\ConsoleApplication1\", $paramIncluded = 0)
{
	$listSourceFiles = "RGB3D_Im*","RGB3D_FontNew.h","RGB_LargeStar.cpp"
	if ($paramIncluded -eq 1){$listSourceFiles+="RGB3D_StarParam.h","RGB3D_Param.h"}
	$vendorSpecific = $Destination.Split("\")[2]
	echo $vendorSpecific
	foreach($files in $listSourceFiles){
		$constructedDir = "$Source$files"
		cp $constructedDir $Destination
		echo "files dir is $constructedDir"
	}
}

Set-Alias -Name cpKeil -Value copyFilestoKeil -Scope Global
