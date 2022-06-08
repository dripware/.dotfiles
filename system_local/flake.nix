{
  description = "local flake only used to keep some extra variable for this nixos install";
  outputs = { self, nixpkgs }: {
    disk = "/dev/sda";
    hardware-configuration = import ./hardware-configuration.nix;
          };
        }
