Get-ChildItem ".\Assets" | ForEach-Object {
    $Filename = $_.BaseName

    (Get-Content MainWindow.axaml) | ForEach-Object {
        $_ -replace "Peter", $Filename
    } | Set-Content MainWindow.axaml

    (Get-Content PeterAlert.csproj) | ForEach-Object {
        $_ -replace "Peter", $Filename
    } | Set-Content PeterAlert.csproj

    dotnet publish -c Release --sc true /p:PublishSingleFile=true /p:IncludeNativeLibrariesForSelfExtract=true /p:IncludeAllContentForSelfExtract=true

    git reset --hard
}