{ config, pkgs, lib, ... }:
{
  programs.vscode = {
    enable = true;
    enableExtensionUpdateCheck = false;
    enableUpdateCheck = false;
    extensions = with pkgs.vscode-extensions; [
      charliermarsh.ruff
      scala-lang.scala
      svelte.svelte-vscode
      redhat.vscode-yaml
      jnoortheen.nix-ide
      vspacecode.whichkey # ?
      tamasfe.even-better-toml
      esbenp.prettier-vscode
      timonwong.shellcheck
      rust-lang.rust-analyzer
      graphql.vscode-graphql
      dbaeumer.vscode-eslint
      codezombiech.gitignore
      bierner.markdown-emoji
      bradlc.vscode-tailwindcss
      naumovs.color-highlight
      mikestead.dotenv
      mkhl.direnv
      mskelton.one-dark-theme
      ms-vsliveshare.vsliveshare
      ms-python.python
      brettm12345.nixfmt-vscode
      davidanson.vscode-markdownlint
      pkief.material-icon-theme
      bbenoist.nix
      # TODO: see if these are in the vscode-extensions now
    ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
      {
        name = "kubernetes-yaml-formatter";
        publisher = "kennylong";
        version = "1.1.0";
        sha256 = "bAdMQxefeqedBdLiYqFBbuSN0auKAs4SKnrqK9/m65c=";
      }
      {
        name = "vscode-github-actions";
        publisher = "github";
        version = "0.25.8";
        sha256 = "N9xW/RdVxsGQepnoR1SHRAL48/pk95qQ8I5xc8y3qB4=";
      }
      {
        name = "black-formatter";
        publisher = "ms-python";
        version = "2023.5.12151008";
        sha256 = "YBcyyE9Z2eL914J8I97WQW8a8A4Ue6C0pCUjWRRPcr8=";
      }
      {
        name = "mypy-type-checker";
        publisher = "ms-python";
        version = "2023.2.0";
        sha256 = "KIaXl7SBODzoJQM9Z1ZuIS5DgEKtv/CHDWJ8n8BAmtU=";
      }
      {
        name = "kotlin";
        publisher = "mathiasfrohlich";
        version = "1.7.1";
        sha256 = "sha256-MuAlX6cdYMLYRX2sLnaxWzdNPcZ4G0Fdf04fmnzQKH4=";
      }
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
      "editor.minimap.enabled" = true;
      "[nix]"."editor.tabSize" = 2;
      "[svelte]"."editor.defaultFormatter" = "svelte.svelte-vscode";
      "[jsonc]"."editor.defaultFormatter" = "esbenp.prettier-vscode";
      "[nix]"."editor.defaultFormatter" = "jnoortheen.nix-ide";
      "[python]"."editor.defaultFormatter" = "ms-python.black-formatter";
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
      "keyboard.dispatch" = "keyCode";
      "workbench.editor.showTabs" = true;
      "workbench.list.automaticKeyboardNavigation" = false;
      "workbench.activityBar.visible" = false;
      "workbench.colorTheme" = "One Dark";
      "workbench.iconTheme" = "material-icon-theme";
      "editor.accessibilitySupport" = "off";
      "oneDark.bold" = true;
      # disable the notifications about updates, we'll get them whenever nix gives them
      "update.mode" = "none";
      "window.zoomLevel" = 1;
      "window.menuBarVisibility" = "toggle";
      # hack to get around https://github.com/NixOS/nixpkgs/issues/246509
      "window.titleBarStyle" = "custom";
      "terminal.integrated.shell.linux" = "${pkgs.zsh}/bin/zsh";

      "svelte.enable-ts-plugin" = true;
      "javascript.inlayHints.functionLikeReturnTypes.enabled" = true;
      "javascript.referencesCodeLens.enabled" = true;
      "javascript.suggest.completeFunctionCalls" = true;
      "[typescriptreact]"."editor.defaultFormatter" = "esbenp.prettier-vscode";
      "[typescript]"."editor.defaultFormatter" = "esbenp.prettier-vscode";
      "redhat.telemetry.enabled" = false;

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

  # VSCode whines like a when the config file is read-only
  # I want nix to govern the configs, but to let vscode edit it (ephemerally) if I change
  # the zoom or whatever. This hack just copies the symlink to a normal file
  home.activation.beforeCheckLinkTargets = {
    after = [ ];
    before = [ "checkLinkTargets" ];
    data = ''
      userDir=~/.config/Code/User
      rm -rf $userDir/settings.json
    '';
  };
  home.activation.afterWriteBoundary = {
    after = [ "writeBoundary" ];
    before = [ ];
    data = ''
      userDir=~/.config/Code/User
      rm -rf $userDir/settings.json
      cat ${pkgs.writeText "tmp_vscode_settings" (builtins.toJSON config.programs.vscode.userSettings)} | jq --monochrome-output > $userDir/settings.json
    '';
  };
}
