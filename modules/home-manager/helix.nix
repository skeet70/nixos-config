{ config, pkgs, lib, ... }:
{
  programs.helix = {
    enable = true;
    package = pkgs.unstable.helix;
    defaultEditor = true;
    settings = {
      theme = "jellybeans";
      editor = {
        line-number = "absolute";
        mouse = true;
        text-width = 120;
        file-picker = {
          hidden = false;
        };
      };
    };
    languages = {
      language = [
        {
          name = "javascript";
          formatter = {
            command = "prettier";
            args = [ "--parser" "typescript" ];
          };
          auto-format = true;
        }
        {
          name = "typescript";
          formatter = {
            command = "prettier";
            args = [ "--parser" "typescript" ];
          };
          auto-format = true;
        }
        {
          name = "python";
          formatter = {
            command = "black";
            args = [ "--quiet" "-" ];
          };
          auto-format = true;
        }
        {
          name = "nix";
          formatter = {
            command = "nixpkgs-fmt";
          };
          auto-format = true;
        }
      ];
    };
  };

  home.packages = with pkgs; [
    # helix language support
    nodePackages.bash-language-server # bash
    shellcheck # bash
    clang-tools # cpp
    gopls # go
    haskell-language-server # haskell
    nodePackages.intelephense # php
    # the java one still needs some work. this installs the right lsp, but helix can't see it.
    # might see this, haven't tried env var https://dschrempf.github.io/emacs/2023-03-02-emacs-java-and-nix/
    jdt-language-server # java
    kotlin-language-server # kotlin
    nil # nix
    nixpkgs-fmt # nix
    marksman # markdown
    metals # scala
    python311Packages.python-lsp-server # python
    python311Packages.python-lsp-ruff # python
    python311Packages.pylsp-mypy # python
    black # python
    rust-analyzer # rust
    nodePackages.svelte-language-server # svelte
    taplo # toml
    nodePackages.typescript-language-server # typescript
    nodePackages.prettier # typescript, js
    vscode-langservers-extracted # css, json, html
    yaml-language-server # yaml
    # - vscode-github-actions equivalent? 
    #   - see https://github.com/helix-editor/helix/issues/6988
    #   - see https://github.com/actions/languageservices/issues/56    
    # end helix language support
  ];
}
