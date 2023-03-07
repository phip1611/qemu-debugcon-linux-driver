# Nix derivation that creates a minimal initrd with tools from busybox.
# The initrd sets up a minimal typical Linux environment and inserts
# the debugcon out-of-tree kernel module.

{ pkgs
, lib
, debugconModule
}:

let
  debugconKernelMod = "${debugconModule}/lib/modules/6.2.0/extra/debugcon.ko";
in
pkgs.makeInitrd {
  contents = [{
    object = pkgs.writers.writeBash "init" ''
      set -eu
      export PATH=${lib.makeBinPath
        ([
           # Basic shell dependencies
           pkgs.bashInteractive
           pkgs.busybox
        ])
      }

      mkdir -p /proc /sys /tmp /run /var
      mount -t proc none /proc
      mount -t sysfs none /sys
      mount -t tmpfs none /tmp
      mount -t tmpfs none /run

      # Create device nodes.
      mdev -s

      # Insert the debugcon kernel module.
      insmod ${debugconKernelMod}

      # Enters bash (as the root shell) with job control.
      setsid cttyhack bash

      poweroff -f
    '';
    symlink = "/init";
  }];
}
