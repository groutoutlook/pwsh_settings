



$global:at_dir = "C:\ProgramDataD\Artery\Repos\AT32F435RGT7 Demo\project\at_start_f435\examples_v37\TEST\TEST\src\"
$global:mm_dir = "C:\ProgramDataD\MindMotion\Repos\DshanMCU-PitayaLite-master\2_temp_proj\pitaya-c\12_uart_irq\Project\"

function copyFilestoKeil($Destination, $Source = "C:\ProgramDataD\Visual Studio\ConsoleApplication1\ConsoleApplication1\")
{
	$listSourceFiles = "RGB3D_Im*","RGB3D_FontNew.h","RGB_LargeStar.cpp"
	$vendorSpecific = $Destination.Split("\")[2]
	echo $vendorSpecific
	foreach($files in $listSourceFiles){
		$constructedDir = "$Source$files"
		cp $constructedDir $Destination
		echo "files dir is $constructedDir"
	}
}

Set-Alias -Name cpKeil -Value copyFilestoKeil -Scope Global
