{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-24.11";
    # nix-channel: Bad
    # channels overall: Good
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system: let
      inherit (pkgs)
        callPackage
        mkShell
        ;
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages.hello =
        callPackage ./default.nix {};
      packages.default = self.packages.${system}.hello;

      devShells.default = mkShell {
        MESSAGE = "hello, world!";
        packages = [
          pkgs.opentofu
          pkgs.ripgrep
          pkgs.asciiquarium
        ];
      };
    }) // {
      nixosConfigurations.foo = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [{
          services.nginx.enable = true;
        }];
      };
    };
    # same as
    # {
    #   packages.aarch64-darwin.hello = 
    #     nixpkgs.legacyPackages.x86_64-linux.hello;
    # };
}
