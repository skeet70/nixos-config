{
  description = "mumu nixos system configuration";

  nixConfig = {
    bash-prompt = "";
    bash-prompt-suffix = "(nixflake)#";
  };

  inputs = {
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs-unstable";
    nur.url = "github:nix-community/NUR";
    ironhide.url = "github:IronCoreLabs/ironhide";
    matui.url = "github:pkulak/matui";
    nixpkgs-wayland.url = "github:nix-community/nixpkgs-wayland";
    nixpkgs-wayland.inputs.nixpkgs.follows = "nixpkgs-unstable";
    helix.url = "github:helix-editor/helix";
  };

  outputs = inputs @ {
    self,
    nixpkgs-unstable,
    home-manager,
    nixpkgs-wayland,
    nur,
    ...
  }: let
    username = "mumu";
    system = "x86_64-linux";
    # Configuration for `nixpkgs`
    nixpkgsConfig = {
      config = {
        allowUnsupportedSystem = true;
        allowBroken = false;
        allowUnfree = true;
        experimental-features = "nix-command flakes";
        keep-derivations = true;
        keep-outputs = true;
        # try removing this every once in a while to see if deps stopped using it
        permittedInsecurePackages = ["nodejs-16.20.0"];
      };
    };
  in {
    nixosConfigurations = {
      murph-icl-gen2 = nixpkgs-unstable.lib.nixosSystem {
        inherit system;
        pkgs = import nixpkgs-unstable {
          system = "x86_64-linux";
          inherit (nixpkgsConfig) config;
          overlays = [
            nur.overlay
            nixpkgs-wayland.overlay
            (final: prev: {
              inherit (inputs.ironhide.packages.${prev.stdenv.system}) ironhide;
              inherit (inputs.matui.packages.${prev.stdenv.system}) matui;
              inherit (inputs.helix.packages.${prev.stdenv.system}) helix;
            })
          ];
        };
        specialArgs = {
          inherit inputs username;
        };
        modules = [
          ./modules/hardware/x1-extreme-gen2.nix
          ./modules/hardware/drawingtablet.nix
          ./modules/nixos
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.${username} = import ./modules/home-manager;
            home-manager.extraSpecialArgs = {
              inherit inputs username;
            };
          }
          ({
            pkgs,
            config,
            ...
          }: {
            config = {
              nix.settings = {
                # add binary caches
                trusted-public-keys = [
                  "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
                  "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
                ];
                substituters = [
                  "https://cache.nixos.org"
                  "https://nixpkgs-wayland.cachix.org"
                ];
              };
            };
          })
        ];
      };
    };
  };
}
