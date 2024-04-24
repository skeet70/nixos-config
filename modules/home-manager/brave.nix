{ config, pkgs, lib, ... }:
{
  programs.brave = {
    enable = true;

    # try to force hardware acceleration
    commandLineArgs = [
      "--ozone-platform=wayland"
      "--enable-feeatures=VaapiVideoDecoder"
      "--use-gl=egl"
    ];

    extensions = [
      { id = "cjpalhdlnbpafiamejdnhcphjbkeiagm"; } # ublock origin
      { id = "nngceckbapebfimnlniiiahkandclblb"; } # bitwarden
      { id = "cdglnehniifkbagbbombnjghhcihifij"; } # kagi
      { id = "ogcgkffhplmphkaahpmffcafajaocjbd"; } # zenhub
      { id = "edibdbjcniadpccecjdfdjjppcpchdlm"; } # i still don't care about cookies
    ];

    # flags can't be configured declaritively like they can in firefox
    # manually set things from https://gitlab.com/CHEF-KOCH/brave-browser-hardening#desktop-flags
  };
}
