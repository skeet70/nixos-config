{
  description = "mumu nixos system configuration";

  nixConfig = {
    bash-prompt = "";
    bash-prompt-suffix = "(nixflake)#";
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/master";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs-unstable";
    nur.url = "github:nix-community/NUR";
    ironhide.url = "github:IronCoreLabs/ironhide";
    # switch to main once flake merges
    matui.url = "github:skeet70/matui?rev=f30a91c4f5dc0546ce980c943449ee79e46035be";
    nixpkgs-wayland.url = "github:nix-community/nixpkgs-wayland";
    nixpkgs-wayland.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    inputs@{ self
    , nixpkgs
    , nixpkgs-unstable
    , home-manager
    , nur
    , ...
    }:
    let
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
          permittedInsecurePackages = [ "nodejs-16.20.0" ];
        };
      };

      overlays = {
        # Overlays to add different versions `nixpkgs` into package set
        master = _: prev: {
          master = import nixpkgs {
            inherit (prev.stdenv) system;
            inherit (nixpkgsConfig) config;
          };
        };
        unstable = _: prev: {
          unstable = import nixpkgs-unstable
            {
              inherit (prev.stdenv) system;
              inherit (nixpkgsConfig) config;
            } // {
            ironhide = inputs.ironhide.packages.${prev.stdenv.system}.ironhide;
            matui = inputs.matui.packages.${prev.stdenv.system}.matui;
          };
        };
      };
    in
    {
      nixosConfigurations = {
        murph-icl-gen2 = nixpkgs.lib.nixosSystem {
          inherit system;
          pkgs = import nixpkgs {
            system = "x86_64-linux";
            inherit (nixpkgsConfig) config;
            overlays = with overlays; [
              nur.overlay
              master
              unstable
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
            ({ pkgs, config, ... }: {
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

                nixpkgs.overlays = [ inputs.nixpkgs-wayland.overlay ];
              };
            })
          ];
        };
      };
    };
}
