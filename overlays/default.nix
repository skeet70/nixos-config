_: pkgs: rec {
  # remove this once 1.8 releases in unstable
  sway = pkgs.sway.overrideAttrs (old: rec {
    src = pkgs.fetchFromGitHub {
      owner = "swaywm";
      repo = "sway";
      rev = "1.8-rc3";
      sha256 = "ltmlD8R/Dsv80+f3olHeRFOYlrHdcfMa19CfYADqSfI=";
    };
  });
}
