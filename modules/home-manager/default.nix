{ config
, lib
, pkgs
, ...
}: {
  programs.home-manager = {
    enable = true;
  };
  home.stateVersion = "22.05";

  imports = [
    ./brave.nix
    ./firefox.nix
    ./helix.nix
  ];

  # Use sway desktop environment with Wayland display server
  wayland.windowManager.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    config = {
      terminal = "alacritty";
      menu = "bemenu-run --no-overlap";
      modifier = "Mod4";
      startup = [
        {
          command = "${pkgs.autotiling-rs}/bin/autotiling-rs";
          always = true;
        }
      ];
      # Status bar(s)
      bars = [
        {
          fonts.size = 13.0;
          command = "waybar"; # You can change it if you want
          position = "top";
        }
      ];
      # Display device configuration
      output = {
        eDP-1 = {
          # Set HIDP scale (pixel integer scaling)
          scale = "2";
          # laptop screen to the right of monitor, swap position values if that changes
          position = "3840,0";
        };
        HDMI-A-1 = {
          position = "0,0";
        };
      };
      input = {
        "4617:8961:Keyboardio_Model_01_Keyboard" = {
          xkb_layout = "us";
        };
        "4617:8963:Keyboardio_Atreus_Keyboard" = {
          xkb_layout = "us";
        };
        "*" = {
          xkb_layout = "us,us";
          xkb_variant = "dvorak,";
          xkb_options = "grp:caps_toggle";
        };
      };
    };
    extraConfig = ''
      bindsym ${config.wayland.windowManager.sway.config.modifier}+Shift+x move workspace to output right
    '';
    # vulkan fallbacks are for https://github.com/nix-community/home-manager/issues/5311
    extraSessionCommands = ''
      export WLR_NO_HARDWARE_CURSORS=1
      export WLR_RENDERER=vulkan,gles2,pixman
    '';
    extraOptions = [ "--unsupported-gpu" ];
  };

  programs.waybar = {
    enable = true;
    package = pkgs.waybar.override { upowerSupport = true; };
    settings = {
      mainBar = {
        layer = "bottom";
        modules-left = [ "sway/workspaces" "sway/mode" ];
        modules-center = [ "sway/window" ];
        modules-right = [ "pulseaudio" "bluetooth" "network" "cpu" "memory" "temperature" "sway/language" "battery" "clock" "tray" ];
        "sway/mode".format = "<span style=\"italic\">{}</span>";
        tray.spacing = 10;
        clock = {
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
          format-alt = "{:%a, %d. %b %H:%M}";
        };
        cpu = {
          format = "{usage}% ";
          tooltip = false;
        };
        memory.format = "{}% ";
        temperature = {
          critical-threshold = 80;
          format = "{temperatureC}°C {icon}";
          format-icons = [ "" "" "" ];
        };
        battery = {
          states = {
            good = 80;
            warning = 30;
            critical = 15;
          };
          format = "{capacity}% {icon}";
          format-charging = "{capacity}% ";
          format-plugged = "{capacity}% ";
          format-alt = "{time} {icon}";
          format-icons = [ "" "" "" "" "" ];
        };
        network = {
          format-wifi = "{essid} ({signalStrength}%) ";
          format-ethernet = "{ipaddr}/{cidr} ";
          tooltip-format = "{ifname} via {gwaddr} ";
          format-linked = "{ifname} (No IP) ";
          format-disconnected = "Disconnected ⚠";
          format-alt = "{ifname}: {ipaddr}/{cidr}";
        };
        pulseaudio = {
          format = "{volume}% {icon} {format_source}";
          format-bluetooth = "{volume}% {icon} {format_source}";
          format-bluetooth-muted = " {icon} {format_source}";
          format-muted = " {format_source}";
          format-source = "{volume}% ";
          format-source-muted = "";
          format-icons = {
            headphone = "";
            hands-free = "";
            headset = "";
            phone = "";
            portable = "";
            car = "";
            default = [ "" "" "" ];
          };
          on-click = "pavucontrol";
        };
        bluetooth = {
          format = "";
          format-off = "!";
          format-disabled = "!";
          on-click = "blueberry";
          tooltip-format = "{status}";
        };
      };
    };
  };

  programs.git = {
    enable = true;
    package = pkgs.gitAndTools.gitFull; # Install git wiith all the optional extras
    userName = "Murph Murphy";
    userEmail = "murph@clurictec.com";
    aliases = {
      # find how a given commit made it into a given branch, ex `git find-merge 2f87703c main`
      find-merge = ''!sh -c 'commit=$0 && branch=''${1:-HEAD} && (git rev-list $commit..$branch --ancestry-path | cat -n; git rev-list $commit..$branch --first-parent | cat -n) | sort -k2 -s | uniq -f1 -d | sort -n | tail -1 | cut -f2' '';
      # show the commit that brought a commit into the current branch, ex `git show-merge a7a040dcd7c2 sa-tagging-events`
      show-merge = ''!sh -c 'merge=$(git find-merge $0 $1) && [ -n \"$merge\" ] && git show $merge' '';
      # remove branches that are no longer on the remote
      gone = ''! git fetch -p && git for-each-ref --format '%(refname:short) %(upstream:track)' | awk '$2 == "[gone]" {print $1}' | xargs -r git branch -D'';
    };
    extraConfig = {
      github.user = "skeet70";
      # Use vim as our default git editor
      core.editor = "vim";
      # Cache git credentials for 15 minutes
      credential.helper = "cache";
      push.autoSetupRemote = true;
      init.defaultBranch = "main";
      color.ui = true;
      pull.rebase = true;
      "branch \"main\"".pushRemote = "no_push";
    };
  };

  programs.zsh = {
    enable = true;
    shellAliases = {
      ll = "ls -l";
      cat = "bat";
      unar = "ouch decompress";
      unzip = "ouch decompress";
      # for jdt-language-server
    };
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    enableCompletion = true;
    enableVteIntegration = true;
    history = {
      expireDuplicatesFirst = true;
      ignoreSpace = true;
      save = 10000; # save 10,000 lines of history
    };
    oh-my-zsh = {
      enable = true;
      theme = "lambda";
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

  programs.ssh = {
    enable = true;
    compression = true;
    controlMaster = "auto";
    includes = [ "*.conf" ];
    # matchBlocks."*" =
    #   {
    #     identityFile = "~/.ssh/yubikey.pub";
    #     identitiesOnly = true;
    #   };
    extraConfig = ''
      AddKeysToAgent yes
    '';
  };

  home.packages = with pkgs; [
    autotiling-rs
    bitwarden
    bitwarden-cli
    blueberry
    file
    htop
    ironhide
    matui # lightweight matrix tui client
    nixpkgs-fmt
    ouch
    pavucontrol
    postman
    signal-desktop
    slack
    spotify-player
    # sway deps
    bemenu
    grim
    slurp
    swaylock
    wl-clipboard
    # vulkan-tools
    # shouldn't be necessary once the most recent version of sway hits
    vulkan-validation-layers
    # end sway deps
  ];

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  services.udiskie = {
    enable = true;
    automount = true;
    tray = "always";
    notify = true;
  };

  services.mako = {
    enable = true;
    defaultTimeout = 5000;
  };

  services.swayidle =
    let
      lockCommand = pkgs.swaylock + "/bin/swaylock -fF -c 000000";
      swayMsgPath = config.wayland.windowManager.sway.package + /bin/swaymsg;
    in
    {
      enable = true;
      events = [
        {
          event = "before-sleep";
          command = lockCommand;
        }
        {
          event = "after-resume";
          command = ''${swayMsgPath} "output * dpms on"'';
        }
        {
          event = "lock";
          command = lockCommand;
        }
      ];
      timeouts = [
        {
          timeout = 60 * 6;
          command = "${swayMsgPath} \"output * dpms off\"";
          resumeCommand = "${swayMsgPath} \"output * dpms on\"";
        }
        {
          timeout = 60 * 10;
          command = lockCommand;
        }
        {
          timeout = 60 * 15;
          command = "systemctl suspend";
        }
      ];
    };
}
