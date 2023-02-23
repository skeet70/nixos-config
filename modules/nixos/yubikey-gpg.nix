{ config, lib, pkgs, ... }:

{
  # to load gpg keys from one of the yubikeys on fresh setup or removal of gpg config,
  # run `gpg2 --import public_key`, then `gpg2 --card-status`
  # https://rzetterberg.github.io/yubikey-gpg-nixos.html is the guide I followed for setting up key structure.

  programs.ssh.startAgent = false;

  services.pcscd.enable = true;

  # for renewing/creating gpg keys
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  environment.systemPackages = with pkgs; [
    yubikey-personalization
  ];

  environment.shellInit = ''
    gpg-connect-agent /bye
    export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
  '';

  # run `sudo -- udevadm control --reload-rules && udevadm trigger` if live loading to reload
  services.udev.packages = with pkgs; [
    yubikey-personalization
  ];

  # see https://nixos.wiki/wiki/Yubikey for required manual setup of known keys
  security.pam.services = {
    login.u2fAuth = true;
    sudo.u2fAuth = true;
  };
}
