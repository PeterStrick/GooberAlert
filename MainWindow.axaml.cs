using System;
using Avalonia.Controls;
using Avalonia.Interactivity;

namespace GooberAlert;

public partial class MainWindow : Window
{
    public MainWindow()
    {
        InitializeComponent();
    }

    private void Button_OnClick(object? sender, RoutedEventArgs e)
    {
        Environment.Exit(0);
    }
}