# Minimal Linux kernel configuration for a kernel with the following properties:
# - x86_64
# - relocatable
# - initrd
# - elf and shebang
# - printk
# - serial and tty
# - hypervisor detection support
# - dynamic module loading
#
# The kernel config itself probably builds with a big variety of Linux kernel configurations.
# All important drivers are built-in ("=Y"). There are no modules build.

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

    version = "${selectedLinuxKernelPkg.version}";
    # Probably that's a weird nixpkgs upstream thingy. Linux 6.2 wants
    # "6.2.0" instead of "6.2".
    modDirVersion = "${selectedLinuxKernelPkg.version}.0";

    allowImportFromDerivation = true;
  };
in
buildKernel selectedLinuxKernelPkg
