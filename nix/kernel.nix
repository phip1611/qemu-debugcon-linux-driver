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

{ pkgs
, lib
, rustc
, linuxSrc
}:

let
  # Function that builds a kernel from the provided Linux source with the
  # given config.
  buildKernel = pkgs.linuxKernel.manualConfig.override
    {
      inherit rustc;
    }
    {
      inherit (pkgs) stdenv lib;

      src = linuxSrc;
      configfile = ./kernel.config;

      version = "6.3";
      # Probably that's a weird nixpkgs upstream thingy. Linux 6.3 wants
      # "6.3.0" instead of "6.3".
      modDirVersion = "6.3.0";

      allowImportFromDerivation = true;

      extraMakeFlags = [
        # Helps to detect the output of the rust_is_available.sh script.
        "V=12"
      ];
    };
in
buildKernel
