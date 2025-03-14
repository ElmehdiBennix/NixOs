{ pkgs, ... }:

{
  home.username = "rambeau";
  home.homeDirectory = "/home/rambeau";

  # Set up some basic environment variables and programs
  programs.zsh.enable = true;
  programs.git.enable = true;

  # You can add your personal configurations here
}
