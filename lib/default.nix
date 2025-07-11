{ pkgs }: {
  cached-command = { name, command, deps ? [ ], system }:
    derivation {
      inherit name system deps;
      builder = "${pkgs.bash}/bin/bash";
      args = [ "-c" command ];
    };
}
