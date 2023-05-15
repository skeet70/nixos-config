# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

{
  imports = [
    ./yubikey-gpg.nix
  ];

  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Denver";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.utf8";

  # Enable CUPS to print documents.
  services.printing.enable = true;
  services.avahi.enable = true;
  services.avahi.openFirewall = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Hardware Support for Wayland Sway
  hardware = {
    opengl = {
      enable = true;
      driSupport = true;
    };
  };

  # wayland compat xdg directives
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-wlr
      xdg-desktop-portal-gtk
    ];
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.mumu = {
    isNormalUser = true;
    description = "Murph";
    extraGroups = [ "networkmanager" "wheel" ];
  };
  users.defaultUserShell = pkgs.zsh;
  users.extraGroups.vboxusers.members = [ "mumu" ];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  nix = {
    gc = {
      automatic = true;
      options = "--delete-older-than 8d";
    };
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      auto-optimise-store = true;
    };
    # settings to prevent `direnv` from being garbage collected
    extraOptions = ''
      keep-outputs = true
      keep-derivations = true
    '';
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim
    bat
    zsh
  ];

  environment.variables = {
    "EDITOR" = "vim";
    "NIXOS_OZONE_WL" = "1"; # enable slack wayland native
  };
  programs.zsh.enable = true;
  environment.shells = with pkgs; [ zsh ];
  environment.defaultPackages = [ ];

  # enable dconf so gtk programs can manage their settings
  programs.dconf.enable = true;

  security.pam.services.swaylock = {
    text = "auth include login";
  };
  # show asterisks, also fixes a bug requiring CTRL+D to get enter to work with password prompts and pamu2f enabled.
  security.sudo.extraConfig = "
          Defaults        env_reset,pwfeedback
  ";

  fonts.enableDefaultFonts = true;
  fonts.fonts = with pkgs; [
    fira-code
    fira-code-symbols
    font-awesome
  ];

  # List services that you want to enable:
  virtualisation.docker.rootless = {
    enable = true;
    setSocketVariable = true;
  };
  # enable virtualbox
  virtualisation.virtualbox.host.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?

}
