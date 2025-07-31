# Clean generated files from projection directories

# Define the directories to clean
$directories = @(
    "../_tools",
    "../projection/winrt",
    "../projection/winui2",
    "../projection/winui3"
)

# Process each directory
foreach ($dir in $directories) {
    # Convert to absolute path
    $fullPath = Resolve-Path -Path $dir -ErrorAction SilentlyContinue
    
    if ($fullPath -and (Test-Path $fullPath)) {
        Write-Host "Cleaning directory: $fullPath" -ForegroundColor Yellow
        
        try {
            # Remove all files and subdirectories
            Get-ChildItem -Path $fullPath -Recurse | Remove-Item -Force -Recurse
            Write-Host "Successfully cleaned: $fullPath" -ForegroundColor Green
        }
        catch {
            Write-Host "Error cleaning $fullPath : $_" -ForegroundColor Red
        }
    }
    else {
        Write-Host "Directory not found: $dir" -ForegroundColor Red
    }
}

Write-Host "Cleanup complete!" -ForegroundColor Cyan