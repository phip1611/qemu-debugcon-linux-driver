# Convenient shell script that starts QEMU with the kernel, initrd,
# and out-of-tree Linux kernel module. The root shell of the kernel
# is connected to stdio.

{ kernel
, initrd
, writeShellScriptBin
, qemu
}:

let
  kernelPath = "${kernel}/bzImage";
  initrdPath = "${initrd}/initrd.gz";
  qemuBin = "${qemu}/bin/qemu-system-x86_64";
in
writeShellScriptBin "run_qemu_demo" ''
  ${qemuBin} \
    -kernel ${kernelPath} \
    -append "console=ttyS0" \
    -initrd ${initrdPath} \
    -serial stdio \
    -debugcon file:debugcon.txt \
    -m 512M
''
