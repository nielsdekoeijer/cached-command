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

# NOTE: clang-scan-deps -compilation-database=compile_commands.json test/Test_bisect.cpp | grep $(pwd)/include | sort | uniq | awk '{print $1}'
        # example of how you can use the library
        example = let
          # example command to use with cached-command
          commitHash = pkgs.runCommand "cmd-output" { } ''
            echo -n "$(git -C ${./.} rev-parse HEAD)" > $out
          '';

        in ours.cached-command {
          name = "example";
          inherit system;
          command = "echo The date is $(date) > $out";
          dependencies = [ ./README.md commitHash ];
        };

        # default for nix build
        packages.default = example;

        # default for nix flake check
        checks.basic = example;
      });
}
