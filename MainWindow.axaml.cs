using System;
using System.ComponentModel;
using System.Threading;
using Avalonia.Controls;
using Avalonia.Interactivity;
using Avalonia.Platform;

namespace GooberAlert;

public partial class MainWindow : Window {
    public static BackgroundWorker AudioBG;

    public MainWindow() {
        InitializeComponent();

        // Background Worker
        AudioBG = new BackgroundWorker();
        AudioBG.WorkerSupportsCancellation = true;
        AudioBG.DoWork += AudioBG_DoWork;

        //Replace_with_audio
    }

    private static void Button_OnClick(object? sender, RoutedEventArgs e) {
        Environment.Exit(0);
    }

    // A Thread is required or otherwise the Audio object will get disposed causing playback to abruptly stop??
    // Also thanks to my cute bf for finding this out :3
    private void AudioBG_DoWork(object sender, System.ComponentModel.DoWorkEventArgs e) {
        // Stream Audio from Avalonia into SFML
        var audio = new SFML.Audio.Music(AssetLoader.Open(new Uri("avares://Peter Alert/Assets/audio.mp3")));
        
        while (true) {
            if (AudioBG.CancellationPending) {
                audio.Stop();
                audio.Dispose();
                e.Cancel = true;
                return;
            }

            if (audio.Status != SFML.Audio.SoundStatus.Playing) audio.Play();
                Thread.Sleep(100);
            }
    }

    public static void PlayAudio() {
        // Start Audio Thread
        AudioBG.RunWorkerAsync();
    }

    private static void Window_OnClosing(object? sender, WindowClosingEventArgs e) {
       if (AudioBG.IsBusy) AudioBG.CancelAsync();
       Environment.Exit(0);
    }
}
