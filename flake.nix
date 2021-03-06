{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    home-manager = {
      url = github:nix-community/home-manager;
      inputs.nixpkgs.follows = "nixpkgs";
    };
    kmonad = { # keyboard moddification
      url = "github:kmonad/kmonad?dir=nix";
    };
    rofi-blocks = { # rofi scripts on steroids
      url = "github:dripware/rofi-blocks-nix";
    };

    # local config flake contains bunch of information about this specific
    # installation of nixos. it's generated automatically by install.sh
    # it also contains hardware-configuration.nix
    local_config = {
      url = "path:./local_config";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = { self, nixpkgs, home-manager, local_config, kmonad, rofi-blocks }@inputs:
    let 
      system = "x86_64-linux";
      username = local_config.username;
      pkgs = import nixpkgs {
        inherit system;
      	allowUnfree = true;
      };
    in {
      # configuration are named "main" because the specific configuration for each user
      # is dynamically loaded by local_config.user_config and local_config.system_config
      # that makes adding new configurations easier
      nixosConfigurations.main = nixpkgs.lib.nixosSystem {
        inherit system pkgs;
	specialArgs = { inherit local_config; };
        modules = [ ./system_config/${local_config.system_config}.nix ];
      };
      homeConfigurations.main = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
	modules = [
	  ./user_config/${local_config.user_config}.nix
	];
	extraSpecialArgs = { inherit inputs; };
      };
    };
}
