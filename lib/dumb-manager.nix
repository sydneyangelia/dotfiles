{
  configuration =
    {
      pkgs,
      nixpkgs,
      module,
    }:
    let
      cfg = (import module) { inherit pkgs; };
      inherit (cfg) homeDirectory;
      update-links = import ./update-links.nix;
      packages = (cfg.packages or [ ]) ++ [
        (update-links { inherit pkgs nixpkgs homeDirectory; })
      ];
    in
    pkgs.buildEnv {
      name = "dumb-manager";
      paths = packages;
    };
}
