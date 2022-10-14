let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-22.05.tar.gz";
in
{
  imports = [
    # add home manager
    (import "${home-manager}/nixos")
  ];

  home-manager.useUserPackages = true;
  home-manager.useGlobalPkgs = true;
  home-manager.users.mumu = { pkgs, ... }: {
    programs.home-manager = {
      enable = true;
    };
    home.stateVersion = "22.05";

    imports = [ 
      ./firefox.nix
    ];

    # Use sway desktop environment with Wayland display server
    wayland.windowManager.sway = {
      enable = true;
      wrapperFeatures.gtk = true;
      # Sway-specific Configuration
      config = {
        terminal = "alacritty";
        menu = "bemenu-run";
        modifier="Mod4";
        # Status bar(s)
        bars = [{
          fonts.size = 13.0;
          command = "waybar"; # You can change it if you want
          position = "bottom";
        }];
        # Display device configuration
        output = {
          eDP-1 = {
            # Set HIDP scale (pixel integer scaling)
            scale = "1"; # probably 2 once not in a VM
	        };
	      };
      };
      # End of Sway-specific Configuration
    };

    programs.git = {
      enable = true;
      package = pkgs.gitAndTools.gitFull; # Install git wiith all the optional extras
      userName = "skeet70";
      userEmail = "murph@clurictec.com";
      extraConfig = {
        # Use vim as our default git editor
        core.editor = "vim";
        # Cache git credentials for 15 minutes
        credential.helper = "cache";
      };
    };

    programs.vscode = {
      enable = true;
      extensions = [
          pkgs.vscode-extensions.bbenoist.nix 
      ];
      userSettings = {
        "update.channel" = "none";
        "[nix]"."editor.tabSize" = 2;
      };
    };

    programs.zsh = {
      enable = true;
      shellAliases = {
        ll = "ls -l";
        cat = "bat";
      };
    };

     # Rust-based terminal emulator
    programs.alacritty = {
      enable = true;
      settings = {
        env.TERM = "alacritty";
        window = {
          decorations = "full";
          title = "Alacritty";
          dynamic_title = true;
          class = {
            instance = "Alacritty";
            general = "Alacritty";
          };
        };
      };
    };

    home.packages = with pkgs; [ 
      file
      htop
      # sway deps
      bemenu
      grim
      slurp
      swaylock
      swayidle
      wl-clipboard
      mako
      waybar
      # end sway deps
    ];
  };

  nixpkgs.config.packageOverrides = pkgs: {
    nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {
      inherit pkgs;
    };
  };
}