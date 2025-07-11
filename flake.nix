{
  description = "Provides functions for caching arbitrary commands";
  inputs.nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        ours = import ./lib/default.nix { inherit pkgs; };
      in rec {
        inherit ours;

        example = let 
          commitHash = pkgs.runCommand "cmd-output" { } ''
            echo -n "$(git -C ${./.} rev-parse HEAD)" > $out
          '';
        in ours.cached-command {
          name = "example";
          inherit system;
          command = "echo The date is $(date) > $out";
          deps = [ ./README.md commitHash ];
        };

        packages.default = example;

        checks.basic = example;
      });
}
