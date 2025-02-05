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
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      # nix flake check
      checks.hello = pkgs.nixosTest {
        name = "test-hello";
        nodes.machine = {
          environment.systemPackages = [
            pkgs.hello
          ];

          nixpkgs.overlays = [
            # Like ./overlays.nix
          ];
        };
        testScript = ''
          start_all()
          machine.wait_for_unit("multi-user.target");
          result = machine.succeed("hello")
          if result != "Hello, world!\n":
            raise RuntimeError("Not a legit hello world, the output is \"" + result + "\"!")
        '';
      };

    }) // {

      # Start VM:
      #
      #   nix run .#nixosConfigurations.foo.config.system.build.vm -- --nographic
      #
      # To try out:
      #
      #   curl http://localhost/etc/nginx/nginx.conf
      #
      # Exit VM: Ctrl-A C Q <Enter>
      nixosConfigurations.foo = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [({ pkgs, ... }: {
          services.nginx.enable = true;
          services.nginx.enableReload = true;
          services.nginx.virtualHosts."/" = {
            root = "/";
            extraConfig = "autoindex on;";
          };

          environment.systemPackages = [
            pkgs.curl
          ];

          services.getty.autologinUser = "demo";
          users.users.demo = {
            isNormalUser = true;
            initialPassword = "";
            extraGroups = [ "wheel" ];
          };
          security.sudo.wheelNeedsPassword = false;

          # Bogus values, not used for the VM
          fileSystems."/".device = "nodev";
          boot.loader.grub.device = "nodev";
        })];
      };
    };
}

