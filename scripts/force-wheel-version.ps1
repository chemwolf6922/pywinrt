param(
    [Parameter(Mandatory=$true)]
    [string]$Version
)

$Folder = "$PSScriptRoot\\..\\projection"

# Find all matching files recursively
$files = Get-ChildItem -Path $Folder -Recurse -File -Filter pywinrt-version.txt

foreach ($file in $files) {
    Set-Content -Path $file.FullName -Value $Version -Force
    Write-Host "Overwritten: $($file.FullName)"
}

$Files = Get-ChildItem -Path $Folder -Recurse -File |
    Where-Object { $_.Name -eq 'requirements.txt' -or $_.Name -eq 'all-requirements.txt' }

foreach ($File in $files) {
    $Content = Get-Content $File.FullName -Raw

    if ($Content -match "~=`?0\.0\.0\.0") {
        # Replace all occurrences
        $NewContent = $Content -replace "~=`?0\.0\.0\.0", "==${Version}"

        # Write content back to file
        Set-Content $File.FullName $NewContent

        Write-Output "Updated: $($File.FullName)"
    }
}