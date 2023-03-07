# Out-of-tree build of the debugcon QEMU driver.
# This Makefile works for example on Debian-based systems but not
# in a Nix derivation or on NixOS out of the box. Hence, it takes
# magic in the Nix derivation.

default: driver

obj-m = debugcon.o

.PHONY: clean default driver

driver:
	make -C /lib/modules/$(shell uname -r)/build/ M=$(PWD) modules

clean:
	make -C /lib/modules/$(shell uname -r)/build M=$(PWD) clean
