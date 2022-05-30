{ pkgs, ... }: {
  programs.home-manager.enable = true;
  
  nixpkgs.overlays = [
    (self: super: {
      TextBidi = pkgs.perlPackages.buildPerlPackage {
        pname = "Text-Bidi";
        version = "2.16";
        src = pkgs.fetchurl {
          url = "mirror://cpan/authors/id/K/KA/KAMENSKY/Text-Bidi-2.16.tar.gz";
          sha256 = "2e82ce323929a3f8bc9086a375058e1216d514ade2657da48899a1fe12d0c6e5";
        };
        meta = {
          homepage = "https://github.com/mkamensky/Text-Bidi";
          description = "Unicode bidi algorith using libfribidi";
          license = with pkgs.lib.licenses; [ artistic1 gpl1Plus ];
        };
        propagatedBuildInputs = with pkgs.perlPackages; [ ExtUtilsPkgConfig ];
        buildInputs = with pkgs; [ fribidi ];
      };
    })
  ];

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
    TextBidi
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
