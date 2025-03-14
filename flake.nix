{
  description = "My NixOS Configuration with Flakes";

  # Define the inputs (Nixpkgs, flake-utils, etc.)
  inputs = {
    # Nixpkgs is the standard Nix package set
    nixpkgs.url = "nixpkgs/nixos-24.11";  # Or the version you want

    # Optional: Home Manager if you want to configure user environments
    home-manager.url = "github:nix-community/home-manager/release-24.11";

    # Optionally add more inputs like your own NixOS modules or packages
  };

  # Outputs is where the configuration happens
  outputs = { self, nixpkgs, home-manager, ... }:
    let
      # Import the nixpkgs and home-manager modules
      system = "x86_64-linux";  # Adjust for your architecture
    in {
      # Define the NixOS system configuration
      nixosConfigurations = {
        hostname = nixpkgs.lib.nixosSystem {
          system = system;
          modules = [
            ../system/configuration.nix  # Include your NixOS config here
            home-manager.nixosModules.home-manager  # If using Home Manager
          ];
          specialArgs = { inherit system; };
        };
      };
    };
}
