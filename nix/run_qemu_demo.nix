# Convenient shell script that starts QEMU with the kernel, initrd,
# and out-of-tree Linux kernel module. The root shell of the kernel
# is connected to stdio.

{ kernel
, initrd
, writeShellScript
, qemu
}:

let
  kernelPath = "${kernel}/bzImage";
  initrdPath = "${initrd}/initrd.gz";
  qemuBin = "${qemu}/bin/qemu-system-x86_64";
in
writeShellScript "run_qemu_demo" ''
  ${qemuBin} \
    -kernel ${kernelPath} \
    -append "console=ttyS0" \
    -initrd ${initrdPath} \
    -serial stdio \
    -debugcon file:debugcon.txt \
    -display none `# relevant for the CI` \
    -m 512M
''
