{ config, pkgs, system_local, ...}:{
  imports = [ ./base.nix ];
  services.picom = {
    enable = true;
  };
}
