function Format-PowerShellFile {
    <#
    .SYNOPSIS
        Formats a .ps1 or .psm1 file using Invoke-Formatter.
    .PARAMETER FilePath
        Path to the .ps1 or .psm1 file.
    .PARAMETER SettingsPath
        Optional. Path to PSScriptAnalyzer settings file (.psd1).
    .EXAMPLE
        Format-PowerShellFile -FilePath "C:\Scripts\MyScript.ps1"
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [ValidateScript({ Test-Path $_ -PathType Leaf })]
        [string]$FilePath,
        [ValidateScript({ Test-Path $_ -PathType Leaf })]
        [string]$SettingsPath
    )

    if (-not (Get-Module -Name PSScriptAnalyzer -ListAvailable)) {
        Write-Error "PSScriptAnalyzer required. Install with: Install-Module PSScriptAnalyzer"
        return
    }

    if ([System.IO.Path]::GetExtension($FilePath).ToLower() -notin @('.ps1', '.psm1')) {
        Write-Error "File must be .ps1 or .psm1"
        return
    }

    try {
        # Backup file
        # Copy-Item -Path $FilePath -Destination "$FilePath.bak" -Force

        # Read and format
        $content = Get-Content -Path $FilePath -Raw
        $params = @{ ScriptDefinition = $content }
        if ($SettingsPath) { $params['SettingsPath'] = $SettingsPath }
        $formatted = Invoke-Formatter @params

        # Remove any trailing newlines (CR, LF) or white space
        $trimmedContent = $formatted.TrimEnd("`r", "`n", " ")

        # Save the trimmed, formatted content
        $trimmedContent | Set-Content -Path $FilePath
    }
    catch {
        Write-Error "Failed to format $FilePath : $_"
    }
}
