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
      dumb-manager = import ./lib/dumb-manager.nix;
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
        # mac-home = (import ./home/mac) {inherit pkgs;};
        mac-home = dumb-manager.configuration {
          inherit pkgs nixpkgs;
          module = ./home/mac;
        };
      });
      # apps = forAllSystems (pkgs: {
      #   update-links = {
      #     type = "app";
      #     program = "${self.packages.${pkgs.system}.update-links}";
      #   };
      # });
      formatter = forAllSystems (pkgs: pkgs.nixfmt-rfc-style);
    };
}
