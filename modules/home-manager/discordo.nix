{ buildGoModule
, fetchFromGitHub
, ...
}:
let
  rev = "50174ef0d25034dd601a5b2060e6f6692a800b05";
  shortRev = builtins.substring 0 8 rev;
in
buildGoModule {
  pname = "discordo";
  version = shortRev;

  src = fetchFromGitHub {
    owner = "ayntgl";
    repo = "discordo";
    inherit rev;
    sha256 = "sha256-C3UouL/A7sn7FpM5PPYa3QeMvgE3Y1c5xeGncLPuocs=";
  };

  vendorSha256 = "sha256-J6J7Tm/GN7Ftxlt10DG9+9LhB8VnLMgEbr4bq5LeEjY=";
}
