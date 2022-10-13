let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-22.05.tar.gz";
in
{
  imports = [
    # add home manager
    (import "${home-manager}/nixos")
  ];

  home-manager.users.mumu = {
    programs.librewolf.enable = true;
  };
}