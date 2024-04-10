# Minimal Linux kernel configuration for a kernel with the following properties:
# - x86_64
# - relocatable
# - initrd loading
# - elf and shebang executables
# - printk
# - serial and tty
# - hypervisor detection support
# - dynamic module loading
# - shutdown/poweroff
#
# The kernel config itself probably builds with a big variety of Linux kernel
# configurations. All important drivers are built-in ("=Y"). There are no modules
# build.

{ lib
  # the selected Linux kernel from "pkgs.linux_*"
, selectedLinuxKernelPkg
, pkgs
}:

let
  # Function that builds a kernel from the provided Linux source with the
  # given config.
  buildKernel = selectedLinuxKernelPkg: pkgs.linuxKernel.manualConfig {
    inherit (pkgs) stdenv lib;

    src = selectedLinuxKernelPkg.src;
    configfile = ./kernel.config;

    version = selectedLinuxKernelPkg.version;
    modDirVersion = selectedLinuxKernelPkg.version;

    # Property comes from `manualConfig.nix` in nixpkgs and allows the read
    # `configfile` from within the derivation.
    allowImportFromDerivation = true;
  };
in
buildKernel selectedLinuxKernelPkg
