{
  wrapNeovimUnstable,
  neovim-unwrapped,
  neovimUtils,
  buildFHSEnv,
  writeShellScript,
  config_path,
  pkgs,
  lib,
  ...
}: let
  nvim = let
    config = let
      extraPackags = with pkgs; [
        cargo
        ccls
        opam
        ocaml
        ocamlPackages.ocamlformat
        ocamlPackages.ocaml-lsp
        go
        unzip
      ];
    in
      neovimUtils.makeNeovimConfig {
        inherit extraPackags;

        customRC = ''
          set runtimepath^=${config_path}
          set runtimepath^=${config_path}/after
          source ${config_path + "/init.lua"}
        '';
      }
      // {
        wrapperArgs = [
          "--prefix"
          "PATH"
          ":"
          "${lib.makeBinPath extraPackags}"
        ];
      };
  in
    wrapNeovimUnstable neovim-unwrapped config;
in
  buildFHSEnv {
    name = "nvim";
    targetPkgs = pkgs: [
      nvim
    ];
    runScript = writeShellScript "run-nvim.sh" ''
      exec ${nvim}/bin/nvim "$@"
    '';
  }
