{ pkgs, inputs, ... }:{
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
    ueberzug
    kmonad
    zsh
    gh
    lsd # better ls
    xclip # clipboard integration in terminal
    fzf
    asciinema
    navi
    cheat
  ];

  nixpkgs.overlays = [
    inputs.kmonad.overlays.default
  ];
  home.file = with builtins; 
    let
      dirs = attrNames (readDir ../home);
      fn = (name: {inherit name; value = { source = ../home + "/${name}"; recursive = true; };});
      fnWithOnChange = (item: (pkgs.lib.recursiveUpdate { value.onChange = (elemAt item 1); } (fn (elemAt item 0)) ));
      arr = map fn dirs;
      onChange = (arr: (listToAttrs (map fnWithOnChange arr)));
    in
      (pkgs.lib.recursiveUpdate (listToAttrs arr) (onChange [
	# [ ".config/zsh" "zsh -ic zert-update" ]
      ]));
}
