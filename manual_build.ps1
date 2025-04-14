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

# Get Name
function Get-Name {
    Clear-Host
    Write-Host "Enter the Name for the Goober Alert"
    Write-Host ""
    return Read-Host "Selected Name"
}

# Get Button Name
function Get-ButtonName {
    Clear-Host
    Write-Host "Enter the Button Name for the Goober Alert"
    Write-Host ""
    return Read-Host "Selected Button Name"
}

# Get App Icon
function Get-AppIcon {
    Clear-Host
    Write-Host "Enter the Path for the App Icon"
    Write-Host "This has to be inside the Assets folder. Eg: /Assets/goober.png"
    Write-Host ""
    return Read-Host "Selected Asset"
}

# Get App Icon
function Get-AppImage {
    Clear-Host
    Write-Host "Enter the Path for the App Image"
    Write-Host "This has to be inside the Assets folder. Eg: /Assets/goober.gif"
    Write-Host ""
    return Read-Host "Selected Asset"
}

# Get If Image is animated
function Get-IfAnimated {
    if ([System.IO.Path]::GetExtension($AppImage).ToLower() -eq ".gif" ) {
        return $true
    } else {
        return $false
    }
}

$Platform = Show-Menu
$Name = Get-Name
$ButtonName = Get-ButtonName
$AppIcon = Get-AppIcon
$AppImage = Get-AppImage
$IsAnimated = Get-IfAnimated

# Replace Name
(Get-Content MainWindow.axaml) | ForEach-Object {
    $_ -replace 'Peter Alert', $Name
} | Set-Content MainWindow.axaml -Encoding UTF8
(Get-Content GooberAlert.csproj) | ForEach-Object {
    $_ -replace 'Peter Alert', $Name
} | Set-Content GooberAlert.csproj -Encoding UTF8

# Replace Button Name
(Get-Content MainWindow.axaml) | ForEach-Object {
    $_ -replace 'OK', $ButtonName
} | Set-Content MainWindow.axaml -Encoding UTF8

# Replace App Icon
(Get-Content MainWindow.axaml) | ForEach-Object {
    $_ -replace 'Icon="/Assets/Peter.png"', "Icon='$($AppIcon)'"
} | Set-Content MainWindow.axaml -Encoding UTF8

# App Image switch

switch ($IsAnimated) {
    $true {
        # Replace Source Tag
        (Get-Content MainWindow.axaml) | ForEach-Object {
            $_ -replace "Source=", "anim:ImageBehavior.AnimatedSource="
        } | Set-Content MainWindow.axaml -Encoding UTF8

        # Replace App Image
        (Get-Content MainWindow.axaml) | ForEach-Object {
            $_ -replace "avares://$($Name)/Assets/Peter.png", "avares://$($Name)$($AppImage)"
        } | Set-Content MainWindow.axaml -Encoding UTF8
    } $false {
        # Replace App Image
        (Get-Content MainWindow.axaml) | ForEach-Object {
            $_ -replace "avares://$($Name)/Assets/Peter.png", "avares://$($Name)$($AppImage)"
        } | Set-Content MainWindow.axaml -Encoding UTF8
    }
}

dotnet publish GooberAlert.csproj -c Release -r $Platform --sc true -o "./build/$Name"

git reset --hard
