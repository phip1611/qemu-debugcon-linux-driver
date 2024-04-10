# Out of the box, the build with this Makefile only works in FHS environments,
# such as on Ubuntu or Debian. On NixOS, you either need to open an FHS
# environment using a Nix shell or build this from a specially crafter Nix
# derivation.
#
# This file follows the conventions written down here:
# https://docs.kernel.org/kbuild/modules.html

# Make it possible to override the kernel src tree location from Nix derivation.
KERNEL ?= $(shell uname -r)
KERNELDIR ?= /lib/modules/$(KERNEL)/build/

.PHONY: default
default: modules

# -m: Build as module.
obj-m = debugcon.o

.PHONY: modules
modules:
	@#"M=": Module source. Special variable of the kernel's main Makefile.
	$(MAKE) -C $(KERNELDIR) M=$(PWD) modules

.PHONY: modules_install
modules_install:
	$(MAKE) -C $(KERNELDIR) M=$(PWD) modules_install

.PHONY: clean
clean:
	$(MAKE) -C $(KERNELDIR) M=$(PWD) clean

.PHONY: help
help:
	$(MAKE) -C $(KERNELDIR) M=$(PWD) help
