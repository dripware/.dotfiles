{ pkgs, ... }: {
  imports = [
    ./config/urxvt.nix
  ];
  programs.home-manager.enable = true;
  home.packages = with pkgs; [
    neofetch
    brave
    feh
    imagemagick
    graphicsmagick
    libfaketime
    neovim
    gimp
    htop
    ncdu
    git
    wezterm
    tree
    hyperfine
  ];

  home.file = {
    ".local/bin" = {
      source = ./bin;
    };
  };
}
