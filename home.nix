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
  home-manager.users.mumu = { pkgs, config, ... }: {
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
      config = {
        terminal = "alacritty";
        menu = "bemenu-run";
        modifier="Mod4";
        startup = [
          { command = "${pkgs.autotiling}/bin/autotiling"; always = true; }
        ];
        # Status bar(s)
        bars = [{
          fonts.size = 13.0;
          command = "waybar"; # You can change it if you want
          position = "top";
        }];
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
            "*" = {
              xkb_layout = "us,us";
              xkb_variant = "dvorak,";
              xkb_options = "grp:caps_toggle";
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
        find-merge = ''!sh -c 'commit=$0 && branch=''${1:-HEAD} && (git rev-list $commit..$branch --ancestry-path | cat -n; git rev-list $commit..$branch --first-parent | cat -n) | sort -k2 -s | uniq -f1 -d | sort -n | tail -1 | cut -f2' '';
        show-merge = ''!sh -c 'merge=$(git find-merge $0 $1) && [ -n \"$merge\" ] && git show $merge' '';
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
      };
    };

    programs.vscode = {
      enable = true;
      extensions = with pkgs.vscode-extensions; [
        scala-lang.scala
        svelte.svelte-vscode
        redhat.vscode-yaml
        jnoortheen.nix-ide
        vspacecode.whichkey # ?
        bungcip.better-toml
        esbenp.prettier-vscode
        timonwong.shellcheck
        matklad.rust-analyzer
        graphql.vscode-graphql
        dbaeumer.vscode-eslint
        codezombiech.gitignore
        bierner.markdown-emoji
        bradlc.vscode-tailwindcss
        naumovs.color-highlight
        mikestead.dotenv
        mskelton.one-dark-theme
        brettm12345.nixfmt-vscode
        davidanson.vscode-markdownlint
        pkief.material-icon-theme
        bbenoist.nix
      ];

      userSettings = {
        # Much of the following adapted from https://github.com/LunarVim/LunarVim/blob/4625145d0278d4a039e55c433af9916d93e7846a/utils/vscode_config/settings.json
        "editor.tabSize" = 2;
        "editor.fontLigatures" = true;
        "editor.guides.indentation" = false;
        "editor.insertSpaces" = true;
        "editor.fontFamily" =
          "'Hasklug Nerd Font', 'JetBrainsMono Nerd Font', 'FiraCode','SF Mono', Menlo, Monaco, 'Courier New', monospace";
        "editor.fontSize" = 12;
        "editor.formatOnSave" = true;
        "editor.suggestSelection" = "first";
        "editor.scrollbar.horizontal" = "hidden";
        "editor.scrollbar.vertical" = "hidden";
        "editor.scrollBeyondLastLine" = false;
        "editor.cursorBlinking" = "solid";
        "editor.minimap.enabled" = false;
        "[nix]"."editor.tabSize" = 2;
        "[svelte]"."editor.defaultFormatter" = "svelte.svelte-vscode";
        "[jsonc]"."editor.defaultFormatter" = "esbenp.prettier-vscode";
        "extensions.ignoreRecommendations" = false;
        "files.insertFinalNewline" = true;
        "[scala]"."editor.tabSize" = 2;
        "[json]"."editor.tabSize" = 2;
        "vim.highlightedyank.enable" = true;
        "files.trimTrailingWhitespace" = true;
        "gitlens.codeLens.enabled" = false;
        "gitlens.currentLine.enabled" = false;
        "gitlens.hovers.currentLine.over" = "line";
        "vsintellicode.modify.editor.suggestSelection" =
          "automaticallyOverrodeDefaultValue";
        "java.semanticHighlighting.enabled" = true;
        "workbench.editor.showTabs" = true;
        "workbench.list.automaticKeyboardNavigation" = false;
        "workbench.activityBar.visible" = false;
        "workbench.colorTheme" = "One Dark";
        "workbench.iconTheme" = "material-icon-theme";
        "editor.accessibilitySupport" = "off";
        "oneDark.bold" = true;
        "window.zoomLevel" = 1;
        "window.menuBarVisibility" = "toggle";
        "terminal.integrated.shell.linux" = "${pkgs.zsh}/bin/zsh";

        "svelte.enable-ts-plugin" = true;
        "javascript.inlayHints.functionLikeReturnTypes.enabled" = true;
        "javascript.referencesCodeLens.enabled" = true;
        "javascript.suggest.completeFunctionCalls" = true;

        "editor.tokenColorCustomizations" = {
          "textMateRules" = [
            {
              "name" = "One Dark bold";
              "scope" = [
                "entity.name.function"
                "entity.name.type.class"
                "entity.name.type.module"
                "entity.name.type.namespace"
                "keyword.other.important"
              ];
              "settings" = { "fontStyle" = "bold"; };
            }
            {
              "name" = "One Dark italic";
              "scope" = [
                "comment"
                "entity.other.attribute-name"
                "keyword"
                "markup.underline.link"
                "storage.modifier"
                "storage.type"
                "string.url"
                "variable.language.super"
                "variable.language.this"
              ];
              "settings" = { "fontStyle" = "italic"; };
            }
            {
              "name" = "One Dark italic reset";
              "scope" = [
                "keyword.operator"
                "keyword.other.type"
                "storage.modifier.import"
                "storage.modifier.package"
                "storage.type.built-in"
                "storage.type.function.arrow"
                "storage.type.generic"
                "storage.type.java"
                "storage.type.primitive"
              ];
              "settings" = { "fontStyle" = ""; };
            }
            {
              "name" = "One Dark bold italic";
              "scope" = [ "keyword.other.important" ];
              "settings" = { "fontStyle" = "bold italic"; };
            }
          ];
        };
      };
    };

    programs.zsh = {
      enable = true;
      shellAliases = {
        ll = "ls -l";
        cat = "bat";
        unar = "ouch decompress";
        unzip = "ouch decompress";
      };
      enableSyntaxHighlighting = true;
      enableAutosuggestions = true;
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
      extraConfig = ''AddKeysToAgent yes'';
    };

    home.packages = with pkgs; [
      # autotiling-rs switch to this once it's in stable
      autotiling
      bitwarden
      file
      htop
      ouch
      pavucontrol
      ripcord
      signal-desktop
      # sway deps
      bemenu
      grim
      slurp
      swaylock
      wl-clipboard
      mako
      waybar
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

    services.swayidle = let
      lockCommand = pkgs.swaylock + "/bin/swaylock -fF -c 000000";
      swayMsgPath = config.wayland.windowManager.sway.package + /bin/swaymsg;
    in {
      enable = true;
      events = [
        { event = "before-sleep"; command = lockCommand; }
        { event = "after-resume"; command = ''${swayMsgPath} "output * dpms on"'';  }
        { event = "lock"; command = lockCommand;  }
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
  };

  nixpkgs.config.packageOverrides = pkgs: {
    nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {
      inherit pkgs;
    };
  };
}
