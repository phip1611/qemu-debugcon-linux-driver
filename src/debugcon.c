/* Copyright 2023 Philipp Schuster
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of
 * this software and associated documentation files (the "Software"), to deal in the
 * Software without restriction, including without limitation the rights to use, copy,
 * modify, merge, publish, distribute, sublicense, and/or sell copies of the Software,
 * and to permit persons to whom the Software is furnished to do so, subject to the
 * following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all copies
 * or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
 * INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
 * PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 * HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
 * OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
 * SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */
// ##################################################################################################
/*
 */

// basic definitions for kernel module development
#include <linux/module.h>

#include "debugcon.h"

// Module/Driver description.
MODULE_LICENSE("GPL");
MODULE_AUTHOR("Philipp Schuster <phip1611@gmail.com>");
MODULE_DESCRIPTION(
"Linux driver that registers a /dev/debugcon node for the QEMU Debugcon device. "
"This only works on x86 and when running inside a QEMU VM."
);

/* ######################## CONVENIENT LOGGING MACROS ######################## */
// (Re)definition of some convenient logging macros from <linux/printk.h>. You can see the logging
// messages when printing the kernel log, e.g. with `$ sudo dmesg`.
// See https://elixir.bootlin.com/linux/latest/source/include/linux/printk.h

// with this redefinition we can easily prefix all log messages from pr_* logging macros
#ifdef pr_fmt
#undef pr_fmt
#endif
#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
/* ########################################################################### */

/**
 * Module/driver initializer. Called on module load/insertion.
 *
 * @return success (0) or error code.
 */
static int __init debugcon_module_init(void) {
    int rc;
    pr_info("QEMU Debugcon Driver inserted.\n");

    return 0;
}

/**
 * Module/driver uninitializer. Called on module unload/removal.
 */
static void __exit debugcon_module_exit(void) {
    pr_info("QEMU Debugcon Driver unloaded.\n");
}

module_init(debugcon_module_init);
module_exit(debugcon_module_exit);
