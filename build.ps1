Get-ChildItem ".\Assets" | ForEach-Object {
    $Filename = $_.BaseName
    echo "Working on Building for $Filename"

    (Get-Content MainWindow.axaml) | ForEach-Object {
        $_ -replace "Peter", $Filename
    } | Set-Content MainWindow.axaml

    (Get-Content GooberAlert.csproj) | ForEach-Object {
        $_ -replace "Peter", $Filename
    } | Set-Content GooberAlert.csproj

    dotnet publish GooberAlert.csproj -c Release --sc true /p:PublishSingleFile=true /p:IncludeNativeLibrariesForSelfExtract=true /p:IncludeAllContentForSelfExtract=true -o "./build/$Filename"

    git reset --hard
}