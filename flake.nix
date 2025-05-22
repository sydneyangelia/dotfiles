{
  inputs = {
    nixpkgs.url = "https://channels.nixos.org/nixpkgs-unstable/nixexprs.tar.xz";
  };
  outputs =
    { self, ... }@inputs:
    let
      inherit (inputs) nixpkgs;
      inherit (inputs.nixpkgs) lib;
      specialArgs = { inherit inputs; };
      forAllSystems =
        function:
        lib.genAttrs lib.systems.flakeExposed (
          system:
          function (
            import nixpkgs {
              inherit system;
              config.allowUnfree = true;
            }
          )
        );
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
      packages = forAllSystems (pkgs: {
        # Too lazy to do callPackage...
        mac-home = (import ./home/mac) pkgs;
      });
      formatter = forAllSystems (pkgs: pkgs.nixfmt-rfc-style);
    };
}
