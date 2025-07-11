{ pkgs }: {
  cached-command = { name, command, dependencies ? [ ], system }:
    derivation {
      inherit name system dependencies;
      builder = "${pkgs.bash}/bin/bash";
      args = [ "-c" command ];
    };
}
