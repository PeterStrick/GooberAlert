using System;
using Avalonia.Controls;
using Avalonia.Interactivity;
using Avalonia.Platform;
using LibVLCSharp.Shared;

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
    }

    public static void PlayAudio() {
        // Load libVLC libraries
        Core.Initialize();

        using var libVLC = new LibVLC(enableDebugLogs: true);
        using var media = new Media(libVLC, new StreamMediaInput(AssetLoader.Open(new Uri("avares://Peter Alert/Assets/audio.mp3"))));
        using var mediaPlayer = new MediaPlayer(media);
        mediaPlayer.Play();
    }
}