{ pkgs,config, inputs, ... }: rec {
  home.username = inputs.local_config.username;
  home.homeDirectory = "/home/${home.username}";
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
    tree
    hyperfine
    nix-generate-from-cpan
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
    dmenu
    nodejs
    nodePackages.npm
    firefox
    openvpn
    unzip
    update-resolv-conf
    lua
    (rofi.override { plugins = [rofi-blocks]; })
    mpv
    ffmpeg
    python
  ];

  programs.gpg = {
    enable = true;
    homedir = "${config.home.homeDirectory}/.local/share/gnupg";
  };
  services.gpg-agent = {
    enable = true;
    pinentryFlavor = "gtk2";
  };

  nixpkgs.overlays = [
    inputs.kmonad.overlays.default
    inputs.rofi-blocks.overlay
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

  home.stateVersion = "22.11";
}
