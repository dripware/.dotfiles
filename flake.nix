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
      username = system_local.username;
    in {
      nixosConfigurations.main = nixpkgs.lib.nixosSystem {
        inherit system;
	specialArgs = { inherit system_local; };
        modules = [ ./configuration/${system_local.configuration}.nix ];
      };
      homeConfigurations.main = home-manager.lib.homeManagerConfiguration {
        inherit system username;
        configuration = import ./home/${username}.nix;
        homeDirectory = "/home/${username}";
        stateVersion = "21.11";
      };
    };
}
