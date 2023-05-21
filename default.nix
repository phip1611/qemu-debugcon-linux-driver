let
  pkgs = (import ./nix/nixpkgs.nix).stable;
  lib = pkgs.lib;
  gitignoreSource = import ./nix/gitignore.nix { inherit lib; };
  rust-toolchain = import ./nix/rust-toolchain.nix { inherit (pkgs) rust-bin; };
in
rec {
  kernel = pkgs.callPackage ./nix/kernel.nix { rustc = rust-toolchain; };
  debugconModule = pkgs.callPackage ./nix/debugcon_module.nix {
    inherit gitignoreSource;
    inherit kernel;
    rustc = rust-toolchain;
  };
  testApp = pkgs.callPackage ./nix/test_app.nix { };
  initrd = pkgs.callPackage ./nix/initrd.nix { inherit debugconModule; inherit testApp; };
  runQemuDemo = pkgs.callPackage ./nix/run_qemu_demo.nix { inherit initrd kernel; };
}
