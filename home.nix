{ pkgs, ... }: {
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
    nix-generate-from-cpan
    rxvt_unicode
    (perl.withPackages(ps: [ ps.Appcpanminus ]))
  ];

  home.file = {
    ".local/bin" = { # custom scripts
      source = ./bin;
    };
  };
  programs.urxvt = import ./config/urxvt;
}