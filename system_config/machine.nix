{ config, pkgs, system_local, ...}:{
  imports = [ ./base.nix ];
  services.picom = {
    enable = true;
    experimentalBackends = true;
    backend = "glx";
    vSync = true;
  };
}
