# Delete log files when processed
set-variable -name KILL_LOG -value ([boolean]$TRUE) -option Constant

<#
.DESCRIPTION
    Initialize variables
#>
function initialize() {
    # Name of the Powershell script
    $global:me = $PSCommandPath

    # Name of the resulting file
    $global:currDir = Get-Location

    $global:logs = "$currDir\*.*"
    $global:outFile = "$currDir\all_APIs.log"

    # Pattern to search for
    $global:searchRegex = ".*BOSA\/.*\/api\/.*"
}

<#
.DESCRIPTION
    Get all log files and append them to a big one.
    Only lines that match a given pattern (see $global:searchRegex)
#>
function concatLogFiles() {

    $bFirst = ([boolean]$TRUE)

    # Get all files in the current folder and concatenate them
    # in a single, out, file
    Get-ChildItem -Recurse *.* | ForEach-Object {
        if (($_.FullName -ne $global:me) -And ($_.FullName -ne $global:outFile)) {

            if ($bFirst) {
                # Remove the previous file on the first call
                if (Test-Path $global:outFile) {
                    Remove-Item $global:outFile
                }
                $bFirst = ([boolean]$FALSE)
            }

            # Small echo

            $logFile = $_.FullName

            Write-Output "Process $logFile"

            Select-String -Path $logFile -Pattern $global:searchRegex -AllMatches | `
                % { $_.Matches } | % { $_.Value } >> $global:outFile

            if ($KILL_LOG -eq $TRUE) {
                Remove-Item -Path $logFile
            }
        }
    }
}

initialize

Write-Output "========================================================"
Write-Output "= Process all HTTP logs, retrieve lines matching a     ="
Write-Output "= given pattern and consolidate lines in a result file ="
Write-Output "========================================================"
Write-Output ""
Write-Output "Processing $global:logs"
Write-Output "Create     $global:outFile"
Write-Output "Pattern    $global:searchRegex"
Write-Output ""

concatLogFiles

Write-Output "File $global:outFile has been created. Enjoy!"
