# A Linux out-of-tree Kernel module for the debugcon device

This repository contains an out-of-tree Linux kernel driver for the
[debugcon (Debug console) device](https://phip1611.de/blog/how-to-use-qemus-debugcon-feature-and-write-to-a-file/),
which is present in QEMU or Cloud Hypervisor (as of >= v38.0).
The driver only works on x86, as it needs I/O ports to access the device.

The build process of the driver follows the
[recommended guidelines](https://docs.kernel.org/kbuild/modules.html).

The driver will provide a character-device file in `/dev/debugcon`. One process
at a time can open the device file and write bytes to it. Depending on the
configuration of QEMU, the output will land in the configured location.

The driver is packaged in [Nix](https://nixos.org/), which allows an easy build
setup. Although the driver can be built the regular way, it is recommended to
use Nix.

## Build and Run Demo with Nix

By using the `$ nix-build -A runQemuDemoBin` command, you get a shell script in
`./result/bin/run_qemu_demo` that starts a QEMU VM with a minimal Linux kernel
and initrd, that automatically loads the out-of-tree debugcon kernel module at
runtime. Once you are in the VM shell, can write to the device like this:
`echo "foo" > /dev/debugcon`. By default, the VMM will redirect all output to
`./debugcon.txt`.

### TL;DR

- `$ nix-build -A runQemuDemo && ./result`
- (once the prompt of the VM appears) `# echo "foo" > /dev/debugcon`
- (on the host) `$ cat debugcon.txt` will show what was written to the
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
