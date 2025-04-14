# Goober Alert

A fork of [PeterAlert](https://github.com/NumixAvali/PeterAlert) which allows multiple Goober Alerts to be created from their respective PNG File in the Assets Folder.

# Simple Usage

1. Clone the Github Repo to somewhere
2. Add/Replace PNGs in the Assets Folder
3. Run the `build.ps1` PowerShell Script

# Advanced Usage

1. Clone the Github Repo to somewhere
2. Add/Replace Images / Audio in the Assets Folder
3. Run the `manual_build.ps1` PowerShell Script

## Note on `build.ps1`

`build.ps1` is now demoted to a quick generation of a multitude of Goober Alerts. 

### For a more advanced, customized and recommended approach use `manual_build.ps1`

The produced executables Name generated from `build.ps1` depend on the Name of the PNG File in the Assets Folder, eg having a `Lu The Shiny Thing.png` File in the Assets Folder, will produce a "Lu The Shiny Thing Alert"

## Building Infos for `manual_build.ps1`

- Git and the .Net 8 SDK are required to Build the project
- The Project Namespace, Window Title, and Assembly File Name is named according to $Name
  - This is done by a general replace of "Peter Alert" to $Name
- The OK Button is named according to $ButtonName
  - This is done by a general replace of "OK" to $Name
- The App Icon is defined accoridng to $AppIcon
  - This is done by a general replace of `Icon='/Assets/Peter.png'` to `Icon='$($AppIcon)'`
- The App Image is defined according to $AppImage
  - This is done by a general replace of `avares://$($Name)/Assets/Peter.png` to `avares://$($Name)$($AppImage)`
  - If a GIF was provided then `Source=` is replaced by `anim:ImageBehavior.AnimatedSource=`
- The Music Location is defined according to $Music
  - This is done by a general replace of the following:
    - The Namespace is replaced from `avares://Peter Alert/` to `avares://$($Name)/`
    - The Audio Location is replaced from `/Assets/audio.mp3` to $Music
    - The Code comment `//Replace_with_audio` is replaced by `PlayAudio();` to enable the Audio Function
- Audio on Linux requires the `sfml` and `csfml` System packages to be installed
  - I tried to include them as a NuGet package but this only solves the Library Issue on Windows, if you found a fix for this on Linux feel free to contribute
    - The specific library that it can't find on Linux is `csfml-audio`

## Building Infos for `build.ps1`

- Git and the .Net 8 SDK are required to Build the project
- The use of the `build.ps1` Script is to automatically replace each instance of the Word `Peter` with the File name of the PNG File, this can be rewritten in another Language eg Bash or done manually as the Word `Peter` only appears inside of `MainWindow.axaml` and `GooberAlert.csproj`
  - After those words were replaced and dotnet published the executable, a `git reset --hard` is done to revert the renaming and move onto the next PNG File
- Audio on Linux requires the `sfml` and `csfml` System packages to be installed
