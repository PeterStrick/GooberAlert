# Goober Alert

A fork of [PeterAlert](https://github.com/NumixAvali/PeterAlert) which allows multiple Goober Alerts to be created from their respective PNG File in the Assets Folder.

# Usage

1. Clone the Github Repo to somewhere
2. Add/Replace PNGs in the Assets Folder
3. Run the `build.ps1` PowerShell Script

## Note

The produced executables Name depends on the Name of the PNG File in the Assets Folder, eg having a `Lu The Shiny Thing.png` File in the Assets Folder, will produce a "Lu The Shiny Thing Alert"

## Building

- Git and .Net 7 are required to Build the project
- The use of the build.ps1 Script is to automatically replace each instance of the Word `Peter` with the File name of the PNG File, this can be rewritten in another Language eg Bash or done manually as the Word `Peter` only appears inside of `MainWindow.axaml` and `GooberAlert.csproj`
  - After those words were replaced and dotnet published the executable, a `git reset --hard` is done to revert the renaming and move onto the next PNG File