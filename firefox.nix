{ config, pkgs, lib, ... }:
{
  programs.firefox = {
    enable = true;
    package = pkgs.firefox-wayland;
    extensions = with pkgs.nur.repos.rycee.firefox-addons; [
      ublock-origin
      bitwarden
    ];

    profiles = {
      default = {
        isDefault = true;
        settings = {
          "beacon.enabled" = false;
          "browser.contentblocking.category" = "strict";
        };
      };
    };
  };
}