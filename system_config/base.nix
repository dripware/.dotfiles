# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, local_config, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      (local_config.hardware-configuration)
    ];
  boot.loader.grub = {
    enable = true;
    version = 2;
    device = local_config.disk;
  };

  nix.extraOptions = "experimental-features = nix-command flakes";

  networking.hostName = local_config.machine_name; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "Asia/Tehran";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkbOptions in tty.
  # };

  # Enable the X11 windowing system.
  services = {
    xserver = {
      enable = true;
      layout = "us,ir(pes_keypad)";
      xkbOptions = "grp:lalt_lshift_toggle,caps:swapescape"; # map caps to escape.
      displayManager = {
        defaultSession = "none+xmonad";
        sddm = {
	  enable = true;
	  autoNumlock = true;
	};
      };
      windowManager = {
	xmonad = {
          enable = true;
	  enableContribAndExtras = true;
	  extraPackages = hp: [
	    hp.xmonad-contrib
	    hp.xmonad-extras
	    hp.xmonad
	  ];
	}; 
        qtile = {
          enable = true;
        };
      };
      # Enable touchpad support (enabled default in most desktopManager).
      libinput.enable = true;
    };
    # Enable CUPS to print documents.
    printing.enable = true;
  };

  systemd.services.vpnd = {
    path= [ pkgs.openvpn pkgs.gawk ];
    unitConfig = {
      Description = "rofi openvpn - allows starting vpn as unprivileged";
    };
    serviceConfig = {
      Restart="no";
      Type="simple";
      ExecStart="${pkgs.bash}/bin/bash /home/${local_config.username}/.local/bin/vpnd";
      StandardInput="socket";
      StandardError="journal";
    };
  };
  systemd.sockets.vpnd = {
    enable = true;
    wantedBy = [ "sockets.target" ];
    unitConfig = {
      Description = "something socket";
    };
    socketConfig = {
      ListenFIFO="%T/vpnd.stdin";
      Service="vpnd.service";
    };
  };

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Define a user account.
  users.users."${local_config.username}" = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ]; # Enable ‘sudo’ for the user.
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim 
    wget
    git
  ];
  fonts.fonts = with pkgs; [
    noto-fonts-emoji
    vazir-fonts
    vazir-code-font
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
    jetbrains-mono
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;
  system.stateVersion = "21.11";
}

