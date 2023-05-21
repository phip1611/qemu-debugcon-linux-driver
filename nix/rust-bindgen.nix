# Returns bindgen in the correct version (0.56.0) for the kernel build.
#
# This can be found out when the kernel is build with "make -V12" or if
# "./scripts/rust_is_aviailable.sh -v" is executed manually.

let
  nixpkgs-src =
    # 0.56.0 was never in nixpkgs, only 0.57.0. I use this one instead!
    let
      rev = "abf7ed76bcb3433d9e1abbcb9779017d0dc9088b";
    in
    builtins.fetchTarball {
      url = "https://github.com/NixOS/nixpkgs/archive/${rev}.tar.gz";
      sha256 = "sha256:1a796r2iyba8vkg7310bh3x8k8dw5aph4pq1s3wp70xvripbrs4w";
    };
  pkgs = import nixpkgs-src {};
in
pkgs.rust-bindgen

