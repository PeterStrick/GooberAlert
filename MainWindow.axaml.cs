using System;
using Avalonia.Controls;
using Avalonia.Interactivity;
using Avalonia.Platform;

namespace GooberAlert;

public partial class MainWindow : Window
{
    public MainWindow()
    {
        InitializeComponent();

        //Replace_with_audio
        PlayAudio();
    }

    private static void Button_OnClick(object? sender, RoutedEventArgs e)
    {
        Environment.Exit(0);
    }

    public static void PlayAudio() {
        var audio = new SFML.Audio.Music(AssetLoader.Open(new Uri("avares://Peter Alert/Assets/audio.mp3")));
        audio.Loop = true;
        audio.Play();
    }
}