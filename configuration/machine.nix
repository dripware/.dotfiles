{ config, pkgs, system_local, ...}:{
  imports = [ ./base.nix ];
  services.picom = {
    enable = true;
    fade   = true;
    experimentalBackends = true;
    backend = "glx";
    vsync = true;
    settings = {
      fade-delta = 3;
    };
  };
}
