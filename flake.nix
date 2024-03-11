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
    # switch to main once flake merges
    matui.url = "github:skeet70/matui?rev=d10be43cd90f0b0ddd82216bfef36e6ca16bb459";
    nixpkgs-wayland.url = "github:nix-community/nixpkgs-wayland";
    nixpkgs-wayland.inputs.nixpkgs.follows = "nixpkgs";
    helix.url = "github:helix-editor/helix";
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
        unstable = _: prev: {
          unstable = import nixpkgs-unstable
            {
              inherit (prev.stdenv) system;
              inherit (nixpkgsConfig) config;
            } // {
            ironhide = inputs.ironhide.packages.${prev.stdenv.system}.ironhide;
            matui = inputs.matui.packages.${prev.stdenv.system}.matui;
            helix = inputs.helix.packages.${prev.stdenv.system}.helix;
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
