{ pkgs,... }:{
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
    wezterm
    tree
    hyperfine
    nix-generate-from-cpan
    rxvt-unicode-emoji
    tmux
    nixos-option
    (perl.withPackages(ps: [ ps.Appcpanminus ]))
  ];
  home.file = with builtins; 
    let
      dirs = attrNames (readDir ../home);
      arr  = map (name: {inherit name; value = { source = ../home + "/${name}"; recursive = true; };}) dirs;
      extra = {
        ".Xresources".onChange = "xrdb -merge .Xresources";
      };
    in
      extra // (listToAttrs arr);
}
