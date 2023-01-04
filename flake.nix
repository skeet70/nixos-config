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
            #nur = inputs.nur.overlay;
            ironhide = inputs.ironhide.packages.${prev.stdenv.system}.ironhide;
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
          ];
        };
        pwvm = nixpkgs.lib.nixosSystem {
          inherit system;
          pkgs = import nixpkgs {
            system = "x86_64-linux";
            inherit (nixpkgsConfig) config;
            overlays = with overlays; [ nur.overlay master unstable ];
          };
          specialArgs = {
            inherit inputs username;
          };
          modules = [
            ./modules/hardware/pwvm.nix
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
          ];
        };
      };
    };
}
