{
  description = "A Wordle-inspired game designed for the web. Players must guess the randomly selected F1 driver using statistics retrieved from the Jolpica API.";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    systems.url = "github:nix-systems/default";
    bun2nix.url = "github:baileyluTCD/bun2nix";
    bun2nix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ flake-parts, systems, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = (import systems);
      perSystem = { config, self', inputs', pkgs, system, ... }: {
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            bun
            inputs'.bun2nix.packages.default
          ];
        };

        packages = rec {
          stewardle = pkgs.callPackage ./default.nix {
            inherit (inputs.bun2nix.lib.${system}) mkBunDerivation;
          };
          default = stewardle;
        };
        
        apps = pkgs.lib.attrsets.mapAttrs (name: package: {
          program = "${package}/bin/${package.meta.mainProgram or name}";
        }) config.packages;
      };
    };
}
