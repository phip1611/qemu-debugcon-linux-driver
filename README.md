# A Linux out-of-tree Kernel module for the QEMU debugcon device

This repository contains an out-of-tree Linux kernel driver for the QEMU [debugcon
device](https://phip1611.de/blog/how-to-use-qemus-debugcon-feature-and-write-to-a-file/).

It will provide a `/dev/debugcon` device. One process at a time can open the device file
and write bytes to it. Depending on the configuration of QEMU, the output will land in the
configured location.

The driver is packaged in [Nix](https://nixos.org/), which allows an easy build setup.
Although the driver can be built the regular way, it is recommended to use Nix.

**Build and Run with Nix**
- `$ nix-build -A runQemuDemo && ./result/bin/run_qemu_demo`
- All output will land in `./debugcon.txt`.
