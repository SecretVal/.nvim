{
  description = "SecretVal's neovim config packaged in a flake";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = inputs @ {flake-parts, ...}:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = ["x86_64-linux" "aarch64-linux" "aarch64-darwin" "x86_64-darwin"];

      perSystem = {
        config,
        self',
        inputs',
        pkgs,
        system,
        ...
      }: let
        inherit (pkgs) neovimUtils;
        inherit (neovimUtils) makeNeovimConfig;
	config_path = ./config;
        name = ".nvim";
        version = "0.1.0";
      in {
        devShells = {
          default = pkgs.mkShell {
            buildInputs = with pkgs; [alejandra];
          };
        };

        packages = {
          default = pkgs.callPackage ./lib/neovim.nix {inherit config_path;};
        };
      };
    };
}
