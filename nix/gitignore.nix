# Returns the gitignoreSource function which takes a path and filters it by
# applying gitignore rules. The result is a filtered file tree in the nix store.

let
  gitignoreSrc =
    let
      # Picked a recent commit from the master branch.
      # When you change this, also change the sha256 hash!
      rev = "a20de23b925fd8264fd7fad6454652e142fd7f73";
    in
    builtins.fetchTarball {
      url = "https://github.com/hercules-ci/gitignore.nix/archive/${rev}.tar.gz";
      sha256 = "sha256:07vg2i9va38zbld9abs9lzqblz193vc5wvqd6h7amkmwf66ljcgh";
    };
  gitignoreNix = import gitignoreSrc { };
in
gitignoreNix.gitignoreSource
