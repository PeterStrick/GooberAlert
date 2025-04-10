Get-ChildItem ".\Assets" | ForEach-Object {
    $Filename = $_.BaseName
    echo $Filename

    (Get-Content MainWindow.axaml) | ForEach-Object {
        $_ -replace "Peter", $Filename
    } | Set-Content MainWindow.axaml -Encoding UTF8

    (Get-Content GooberAlert.csproj) | ForEach-Object {
        $_ -replace "Peter", $Filename
    } | Set-Content GooberAlert.csproj -Encoding UTF8

    dotnet publish GooberAlert.csproj -c Release --sc true /p:PublishSingleFile=true /p:IncludeNativeLibrariesForSelfExtract=true /p:IncludeAllContentForSelfExtract=true -o "./build/$Filename"

    git reset --hard
}