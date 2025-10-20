{ mkBunDerivation, ... }:
mkBunDerivation {
  pname = "stewardle";
  version = "1.0.0";
  src = ./.;
  bunNix = ./bun.nix;
  index = "app.js";
}

