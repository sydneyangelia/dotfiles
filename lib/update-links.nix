{
  nixpkgs,
  pkgs,
  homeDirectory,
}:
let
  registry = {
    flakes = [
      {
        exact = true;
        from = {
          id = "n";
          type = "indirect";
        };
        to = {
          path = "${nixpkgs}";
          type = "path";
        };
      }
    ];
    version = 2;
  };
  registryFile = pkgs.writeTextFile {
    name = "registry.json";
    destination = "/.config/nix/registry.json";
    text = builtins.toJSON registry;
  };
in
pkgs.writeShellScriptBin "update-links" ''
  #!/usr/bin/env bash
  mkdir -p ${homeDirectory}/.config/nix
  ln -sf ${registryFile}/.config/nix/registry.json ${homeDirectory}/.config/nix/registry.json
''
