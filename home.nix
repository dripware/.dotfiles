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
    (perlPackages.buildPerlModule rec {
      pname = "Text-Bidi";
      version = "2.16";
      src = fetchurl {
        url = "mirror://cpan/authors/id/K/KA/KAMENSKY/${pname}-${version}.tar.gz";
	sha256 = "0000000000000000000000000000000000000000000000000000";
      };
    })
  ];

  home.file = {
    ".local/bin" = { # custom scripts
      source = ./bin;
    };
    ".urxvt/ext" = { # urxvt extensions
      source = ./config/urxvt/ext;
    };
  };
  programs.urxvt = import ./config/urxvt;
}
