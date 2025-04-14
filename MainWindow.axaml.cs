using System;
using Avalonia.Controls;
using Avalonia.Interactivity;
using Avalonia.Platform;
using Mpv.NET;

namespace GooberAlert;

public partial class MainWindow : Window
{
    public MainWindow()
    {
        InitializeComponent();

         //Replace_with_audio
        PlayAudio();
    }

    private void Button_OnClick(object? sender, RoutedEventArgs e)
    {
        Environment.Exit(0);

        PlayAudio();
    }

    public static void PlayAudio() {
        var a = new Mpv.NET.Player.MpvPlayer();
        var hi = AssetLoader.Open(new Uri("avares://Peter Alert/Assets/audio.mp3"));
        a.AddAudio(new Uri("avares://Peter Alert/Assets/audio.mp3").ToString());

        // var b = new HanumanInstitute.LibMpv.MpvContextBase();

        // b.Initialize();
        // var c = new HanumanInstitute.LibMpv.MpvContext();

        // // c.-
        
        
    }
}