# Get Platform to build the Goobers for
function Show-Menu {
    Clear-Host
    Write-Host "Please enter the respective Number of a Platform to build for"
    Write-Host ""
    Write-Host "(1) Windows x64"
    Write-Host "(2) Linux x64"
    Write-Host "(3) Mac x64"
    Write-Host ""
    Write-Host "(4) Windows Arm (64-bit)"
    Write-Host "(5) Linux Arm (64-bit)"
    Write-Host "(6) Mac Arm (64-bit)"
    Write-Host ""
    $selection = Read-Host "Selected Platform"

    switch ($selection)
    {
        '1' {
            return "win-x64"
        } '2' {
            return "linux-x64"
        } '3' {
            return "osx-x64"
        } '4' {
            return "win-arm64"
        } '5' {
            return "linux-arm64"
        } '6' {
            return "osx-arm64"
        } default {
            Show-Menu
        }
    }
}

$Platform = Show-Menu

# Build a goober alert for each PNG File
Get-ChildItem ".\Assets" | ForEach-Object {
    $Filename = $_.BaseName
    echo $Filename

    (Get-Content MainWindow.axaml) | ForEach-Object {
        $_ -replace "Peter", $Filename
    } | Set-Content MainWindow.axaml -Encoding UTF8

    (Get-Content GooberAlert.csproj) | ForEach-Object {
        $_ -replace "Peter", $Filename
    } | Set-Content GooberAlert.csproj -Encoding UTF8

    dotnet publish GooberAlert.csproj -c Release -r $Platform --sc true -o "./build/$Filename"

    git reset --hard
}