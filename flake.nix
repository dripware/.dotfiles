{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    home-manager = {
      url = github:nix-community/home-manager;
      inputs.nixpkgs.follows = "nixpkgs";
    };
    system_local.url = "path:./system_local";
  };
  outputs = { self, nixpkgs, home-manager, system_local }@inputs:
    let 
      system = "x86_64-linux";
      username = "dripware";
    in {
      nixosConfigurations.machine = nixpkgs.lib.nixosSystem {
        inherit system;
	specialArgs = { inherit system_local; };
        modules = [ ./configuration.nix ];
      };
      homeConfigurations.${username} = home-manager.lib.homeManagerConfiguration {
        inherit system username;
        configuration = import ./home.nix;
        homeDirectory = "/home/${username}";
        stateVersion = "21.11";
      };
    };
}
