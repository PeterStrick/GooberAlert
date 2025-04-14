using System;
using System.Threading;
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
    }

    private static void Button_OnClick(object? sender, RoutedEventArgs e)
    {
        Environment.Exit(0);
    }

    public static void PlayAudio() {
        // Stream Audio from Avalonia into SFML
        var audio = new SFML.Audio.Music(AssetLoader.Open(new Uri("avares://Peter Alert/Assets/audio.mp3")));

        // A Thread is required or otherwise the Audio object will get disposed causing playback to abruptly stop??
        // Also thanks to my cute bf for finding this out :3
        new Thread(() => {
            while (true) {
                if (audio.Status != SFML.Audio.SoundStatus.Playing) audio.Play();
                Thread.Sleep(100);
            }
        }).Start();

        // Play the Audio
        audio.Play();
    }
}