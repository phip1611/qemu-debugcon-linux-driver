let
  sources = import ./nix/sources.nix;
  # pkgsSrc = /home/pschuster/dev/nixpkgs;
  pkgs = import sources.nixpkgs { overlays = [ (import sources.rust-overlay) ]; };
  lib = pkgs.lib;

  rust-toolchain = import ./nix/rust-toolchain.nix { inherit (pkgs) rust-bin; };
  # The gitignoreSource function which takes a path and filters it by applying
  # gitignore rules. The result is a filtered file tree in the nix store.
  gitignoreSource = (import sources."gitignore.nix" { inherit lib; }).gitignoreSource;
in
rec {
  kernel = pkgs.callPackage ./nix/kernel.nix {
    linuxSrc = sources.rust-for-linux;
    # linuxSrc = /home/pschuster/dev/linux-rust;
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
