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
    Write-Host "This is required to be either a png, jpg, bmp or ico"
    Write-Host ""
    return Read-Host "Selected Icon"
}

# Get App Icon
function Get-AppImage {
    Clear-Host
    Write-Host "Enter the Path for the App Image"
    Write-Host ""
    Write-Host "This has to be inside the Assets folder. Eg: /Assets/goober.gif"
    Write-Host "This is required to be a GIF"
    Write-Host ""
    return Read-Host "Selected Image"
}

# Get If Image is animated
function Get-IfAnimated {
    if ([System.IO.Path]::GetExtension($AppImage).ToLower() -eq ".gif" ) {
        return $true
    } else {
        return $false
    }
}

# Get Music
function Get-Music {
    Clear-Host
    Write-Host "Enter the Path for a Music File to loop in the background"
    Write-Host "Or hit enter without providing anything to skip the Music"
    Write-Host ""
    Write-Host "This has to be inside the Assets folder. Eg: /Assets/music.mp3"
    Write-Host ""
    return Read-Host "Selected Music"
}

$Platform = Show-Menu
$Name = Get-Name
$ButtonName = Get-ButtonName
$AppIcon = Get-AppIcon
$AppImage = Get-AppImage
$IsAnimated = Get-IfAnimated
$Music = Get-Music

# Final Notes
function Get-CheckResults {
    $icon_extensions = ".bmp",".jpg",".jpeg",".png",".ico"
    $image_extensions = ".bmp",".jpg",".jpeg",".png",".gif"
    $music_extensions = ".mp3",".wav",".ogg",".flac"

    if ($Platform -contains "linux" -and ![String]::IsNullOrWhiteSpace($Music)) {
        Write-Warning "[Warning] Audio on Linux requires the sfml and csfml system packages to be installed or the Application will not run."
    }

    if (!$icon_extensions -contains [System.IO.Path]::GetExtension($AppIcon).ToLower()) {
        Write-Error "[Error] App Icon File is not a valid file format. Please use either a bmp, jpg, jpeg, png, or ico File"
        Exit
    }

    if (!$image_extensions -contains [System.IO.Path]::GetExtension($AppImage).ToLower()) {
        Write-Error "[Error] App Image File is not a valid file format. Please use either a bmp, jpg, jpeg, png, or gif File"
        Exit
    }

    if (![String]::IsNullOrWhiteSpace($Music) -and !$music_extensions -contains [System.IO.Path]::GetExtension($Music).ToLower()) {
        Write-Error "[Error] Music File is not a valid file format. Please use either a mp3, wav, ogg, or flac File"
        Exit
    }

    Write-Host "[Info] If you have any unused Assets in the Assets folder, then please remove them before continuing, as they will increase the Application File Size otherwise"
    Write-Host ""
    Write-Host "Press any Key to continue."
    $null = Read-Host
}

Get-CheckResults

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
    $_ -replace "Icon='/Assets/Peter.png'", "Icon='$($AppIcon)'"
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

# Music
if (![String]::IsNullOrWhiteSpace($Music)) { 
    # Enable Audio Function
    (Get-Content MainWindow.axaml.cs) | ForEach-Object {
        $_ -replace "//Replace_with_audio", "PlayAudio();"
    } | Set-Content MainWindow.axaml.cs -Encoding UTF8

    # Replace Audio Namespace
    (Get-Content MainWindow.axaml.cs) | ForEach-Object {
        $_ -replace "avares://Peter Alert/", "avares://$($Name)/"
    } | Set-Content MainWindow.axaml.cs -Encoding UTF8

    # Replace Audio URI
    (Get-Content MainWindow.axaml.cs) | ForEach-Object {
        $_ -replace "/Assets/audio.mp3", $Music
    } | Set-Content MainWindow.axaml.cs -Encoding UTF8
}

dotnet publish GooberAlert.csproj -c Release -r $Platform --sc true -o "./build/$Name"

git reset --hard
