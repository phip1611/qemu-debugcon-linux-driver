# If you enter this Nix shell, you can run `make` right away as it opens a
# FHS environment.
#
# `$ nix-shell`
# `$ make`

let
  sources = import ../nix/sources.nix;
  pkgs = import sources.nixpkgs { };
  project = import ../default.nix;
in
(pkgs.buildFHSEnv {
  name = "linux-dev-fhs-env";
  targetPkgs = pkgs: with pkgs; [
    # Linux source tree/build support.
    project.kernel.dev
    gcc
    gnumake
    gnupg # warnings when not present when entering the shell
  ];
}).env
