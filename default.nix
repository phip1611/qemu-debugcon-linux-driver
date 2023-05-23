let
  sources = import ./nix/sources.nix;
  # pkgsSrc = import sources.nixpkgs-unstable;
  pkgsSrc = /home/pschuster/dev/nixpkgs;
  pkgs = import pkgsSrc { overlays = [ (import sources.rust-overlay) ]; };
  lib = pkgs.lib;

  rust-toolchain = import ./nix/rust-toolchain.nix { inherit (pkgs) rust-bin; };
  # rust-bindgen at a proper version
  rust-bindgen = (import sources.bindgen-nixpkgs { }).rust-bindgen;
  # The gitignoreSource function which takes a path and filters it by applying
  # gitignore rules. The result is a filtered file tree in the nix store.
  gitignoreSource = (import sources."gitignore.nix" { inherit lib; }).gitignoreSource;
in
rec {
  kernel = pkgs.callPackage ./nix/kernel.nix {
    inherit rust-bindgen;
    linuxSrc = sources.rust-for-linux;
    rustc = rust-toolchain;
  };
  debugconModule = pkgs.callPackage ./nix/debugcon_module.nix {
    inherit gitignoreSource;
    inherit kernel;
    rustc = rust-toolchain;
  };
  testApp = pkgs.callPackage ./nix/test_app.nix { };
  initrd = pkgs.callPackage ./nix/initrd.nix { inherit debugconModule; inherit testApp; };
  runQemuDemo = pkgs.callPackage ./nix/run_qemu_demo.nix { inherit initrd kernel; };
}
