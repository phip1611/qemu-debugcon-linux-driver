let
  sources = import ./nix/sources.nix;
  pkgs = import sources.nixpkgs { };
  lib = pkgs.lib;
in
let
  selectedLinuxKernelPkg = pkgs.linux_6_2;
  kernel = pkgs.callPackage ./nix/kernel.nix { inherit selectedLinuxKernelPkg; };
  debugconModule = pkgs.callPackage ./nix/debugcon_module.nix { inherit kernel; };
  testApp = pkgs.callPackage ./nix/test_app.nix { };
  initrd = pkgs.callPackage ./nix/initrd.nix { inherit debugconModule; inherit testApp; };
  runQemuDemo = pkgs.callPackage ./nix/run_qemu_demo.nix { inherit initrd kernel; };
in
{
  inherit debugconModule;
  inherit runQemuDemo;
  inherit kernel;
  inherit initrd;
}
