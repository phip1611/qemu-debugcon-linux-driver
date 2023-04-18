# Nix-build for the out-of-tree Linux driver. I used
# https://github.com/NixOS/nixpkgs/blob/b2aeb9072b698553c2332e6bd6128eb0dce5e9ee/pkgs/os-specific/linux/hid-nintendo/default.nix
# as template.

{ gitignoreSource
, lib
  # The Linux kernel Nix package for which this module is compiled.
, kernel
, stdenv
}:

stdenv.mkDerivation rec {
  pname = "qemu-debugcon-driver";
  version = "0.1";

  src = gitignoreSource ../src;

  setSourceRoot = ''
    export sourceRoot=$(pwd)/source
  '';

  nativeBuildInputs = kernel.moduleBuildDependencies;

  makeFlags = kernel.makeFlags ++ [
    "-C"
    "${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "M=$(sourceRoot)"
  ];

  buildFlags = [ "modules" ];
  installFlags = [ "INSTALL_MOD_PATH=${placeholder "out"}" ];
  installTargets = [ "modules_install" ];

  meta = with lib; {
    description = "A QEMU Debugcon Driver for Linux";
    platforms = platforms.linux;
  };
}
