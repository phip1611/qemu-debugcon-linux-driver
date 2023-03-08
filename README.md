# A Linux out-of-tree Kernel module for the QEMU debugcon device

This repository contains an out-of-tree Linux kernel driver for the QEMU
[debugcon device](https://phip1611.de/blog/how-to-use-qemus-debugcon-feature-and-write-to-a-file/).
It only works on x86, as it requires I/O ports.

The driver will provide a `/dev/debugcon` device. One process at a time can
open the device file and write bytes to it. Depending on the configuration of
QEMU, the output will land in the configured location.

The driver is packaged in [Nix](https://nixos.org/), which allows an easy build
setup. Although the driver can be built the regular way, it is recommended to
use Nix.

## Build and Run Demo with Nix
By using the `$ nix-build -A runQemuDemo` command, you get a shell script in
`./result/bin/run_qemu_demo` that starts a QEMU VM with a minimal Linux kernel
and initrd, that automatically loads the out-of-tree debugcon kernel module at
runtime. Once you are in the VM shell, can write to the device like this:
`echo "foo" > /dev/debugcon`. All output will land in `./debugcon.txt`.

### TL;DR
- `$ nix-build -A runQemuDemo && ./result/bin/run_qemu_demo`
- (once the prompt of the VM appears) `# echo "foo" > /dev/debugcon`
- `$ cat debugcon.txt` (on the host) will show you what was written to the
  device

## Build Kernel Module for Your System
To build the kernel module for your system (without Nix), you can enter the
`src` directory and type `$ make`. Ensure that you have installed all relevant
packages for your system that are needed to build a Linux kernel (module).
[This resource](https://wiki.ubuntu.com/Kernel/BuildYourOwnKernel) might be
helpful for you.

If you managed that, you should be able to type `$ insmod debugcon.ko`. However,
adding this to your main system doesn't make much sense, except you are inside a
QEMU VM.
