self: super: {
  # remove this once 1.8 releases in unstable
  wlroots = super.wlroots.overrideAttrs (old: {
    # mesonFlags = [ "-Dauto_features=auto" ];
    src = super.fetchFromGitLab {
      domain = "gitlab.freedesktop.org";
      owner = "wlroots";
      repo = "wlroots";
      rev = "0.16";
      sha256 = "sha256-/tyz+w6AP/5quU88KOq2Fhhw8ADtn2oxY9+/ns9jEAU=";
    };
    buildInputs = old.buildInputs ++ [ self.hwdata ];
  });

  sway-unwrapped = super.sway-unwrapped.overrideAttrs (old: rec {
    version = "1.8-rc3";
    src = super.fetchFromGitHub {
      owner = "swaywm";
      repo = "sway";
      rev = "1.8-rc3";
      sha256 = "ltmlD8R/Dsv80+f3olHeRFOYlrHdcfMa19CfYADqSfI=";
    };
    buildInputs = old.buildInputs ++ [ self.pcre2 self.xorg.xcbutilwm.dev ];
  });
}
