# normal user profile installed on real metal
{ pkgs, ... }: {
  imports = [ ./base.nix ];
  home.packages = with pkgs; [
    rxvt-unicode-emoji
  ];
}
