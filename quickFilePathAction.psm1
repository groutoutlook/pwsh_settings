function EmbedEnv() {
    # $Env:cubeCLIdir = "C:\Program Files\STMicroelectronics\STM32Cube\STM32CubeProgrammer\bin"
    # $env:linuxEnvdir = "D:\ProgramDataD\Linux\proj\linux_env"
    $diradd = @(
        $Env:cubeCLIdir
    )
    foreach ($d in $diradd) {
        $Env:Path += ";" + $d;
    }
}
function keilLoad($uv4project = "$pwd", $project_dir = "$uv4project\*.uvprojx") {
    cd $uv4project
    if(fd -HI "uvprojx"){
        $project_metabuild_path = rvpa $project_dir 
        while ($true) {
            uv4 $project_metabuild_path -f -j0 -l "$uv4project\flash_log.txt" && sleep 3 `
                && Get-Content -Tail 10 .\flash_log.txt && sleep 1
        }
    }
}
function Invoke-BatchFlash() {
    $count = 0
    $logfile = "flash_log.txt"
    uv4 (fd '.uvprojx' -HI) -f -j0 -l $logfile
    while ( -not (rg "Programming Done" -g $logfile)) { 
        Write-Host "waiting $count"
        Start-Sleep -Milliseconds 500
        if (($count -gt 9) -and (rg "Error")) {
            Write-Host "Break at $count because error"
            break
        }
        if ($count -gt 15) {
            Write-Host "Break at $count timeout"
            break
        }
        $count += 1
    } 
    [console]::beep(500, 400)
    Get-Content -Tail 10 $logfile
    # rm ./flash_log.txt 
}
function Build-FromKeil($clean = $null) {
    $count = 0
    $logfile = "build_log.txt"
    $buildflag = $clean ? "-c" : "-b" 
    Invoke-Expression('uv4 ' + $buildflag + ' -j0 (fd ".uvprojx" -HI) -l "$logfile"')

    $parsedString = $clean ? "Clean done" : "Build Time"
	
    while (-not (rg $parsedString -g $logfile)) {
        Write-Host "Waiting for $count..."
        Start-Sleep -Milliseconds 500	
        $count += 1
    }
    Get-Content -Tail 10 $logfile
}
function Copy-Just($directory = "$(zq newplus templates)\justfile") {
    Copy-Item $directory .
}
Set-Alias -Name cpjust -Value Copy-Just
# EmbedEnv
