let
  nixpkgs = fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/799ba5bffed04ced7067a91798353d360788b30d.tar.gz";
    sha256 = "0000000000000000000000000000000000000000000000000000";
  };
  pkgs = import nixpkgs {
    config = {};
    overlays = import ./overlays.nix;
  };
in
# nix-build -A python3Packages.requests
# nix-build -A python311Packages.requests
# nix-build -A hello
pkgs
