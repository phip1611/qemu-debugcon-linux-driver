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
, pkgs
}:

let
  src = builtins.fetchTarball {
    url = "https://github.com/Rust-for-Linux/linux/archive/refs/heads/rust.tar.gz";
    sha256 = "sha256:18mxvk1l97448m9s55zc60nlgwb5dnzl1akpz12xyvigc5kz3q7r";
  };
  # Function that builds a kernel from the provided Linux source with the
  # given config.
  buildKernel = pkgs.linuxKernel.manualConfig {
    inherit (pkgs) stdenv lib;

    inherit src;
    configfile = ./kernel.config;

    version = "6.3";
    # Probably that's a weird nixpkgs upstream thingy. Linux 6.3 wants
    # "6.3.0" instead of "6.3".
    modDirVersion = "6.3.0";

    allowImportFromDerivation = true;
  };
in
buildKernel
