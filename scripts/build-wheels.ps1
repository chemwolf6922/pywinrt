$pythonVersions = @(
    "cp39"
    "cp310"
    "cp311"
    "cp312"
    "cp313"
)

$platforms = @(
    "win_amd64"
    "win_arm64"
)

$scriptDir = Split-Path -Parent $PSCommandPath

foreach ($pythonVersion in $pythonVersions) {
    foreach ($platform in $platforms) {
        python ${scriptDir}\\build-bdist.py --only ${pythonVersion}-${platform}
    }
}
