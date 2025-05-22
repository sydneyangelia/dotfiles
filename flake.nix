{
  inputs = {
    nixpkgs.url = "https://channels.nixos.org/nixpkgs-unstable/nixexprs.tar.xz";
    lix = {
      url = "https://git.lix.systems/lix-project/lix/archive/main.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs =
    { self, ... }@inputs:
    let
      inherit (inputs) nixpkgs;
      inherit (inputs.nixpkgs) lib;
      specialArgs = { inherit inputs; };
      forAllSystems =
        function: lib.genAttrs lib.systems.flakeExposed (system: function nixpkgs.legacyPackages.${system});
    in
    {
      nixosConfigurations = {
        hetzner = nixpkgs.lib.nixosSystem {
          inherit specialArgs;
          modules = [
            ./common
            ./hetzner
          ];
        };
      };
      formatter = forAllSystems (pkgs: pkgs.nixfmt-rfc-style);
    };
}
