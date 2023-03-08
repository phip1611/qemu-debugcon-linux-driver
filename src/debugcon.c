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
 * This is a driver for the QEMU debugcon device. It provides the /dev/debugcon
 * device that can be acquired exclusively by user applications for write
 * operations.
 */

// basic definitions for kernel module development
#include <linux/module.h>
// file operations and alloc_chdev_region
#include <linux/fs.h>
// cdev_init, cdev_add, cdev_del
#include <linux/cdev.h>

#include "debugcon.h"

// Module/Driver description.
MODULE_LICENSE("GPL");
MODULE_AUTHOR("Philipp Schuster <phip1611@gmail.com>");
MODULE_DESCRIPTION(
"Linux driver that registers a /dev/debugcon node for the QEMU Debugcon device. "
"This only works on x86 and when running inside a QEMU VM."
);

// with this redefinition we can easily prefix all log messages from pr_* logging macros
#ifdef pr_fmt
#undef pr_fmt
#endif
#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt

dev_t dev_num = -1;
int device_is_opened = 0;
int dev_major = -1;
struct class * debugcon_class = NULL;
struct cdev chrdev;
struct file_operations fops = {
        .owner = THIS_MODULE,
        .open = device_open,
        .write = device_write,
        .release = device_release
};
struct device * device = NULL;

int device_open(struct inode * ino, struct file * f) {
    int acquired_exclusive_access = 0;
    int expected = 0;
    int new_state = 1;

    pr_info("%s called", __FUNCTION__);

    acquired_exclusive_access = __atomic_compare_exchange(
            &device_is_opened,
            &expected,
            &new_state,
            0,
            __ATOMIC_SEQ_CST,
            __ATOMIC_SEQ_CST
    );
    if (!acquired_exclusive_access) {
        pr_info("Another device has the driver file already open");
        return -EBUSY;
    } else {
        pr_info("Acquired exclusive access to device");
    }

    return 0;
}

int device_release(struct inode * ino, struct file * f) {
    pr_info("%s called", __FUNCTION__);

    // Non-atomic access is fine as there can only be one thread in this
    // function.
    device_is_opened = 0;
    return 0;
}

ssize_t device_write(struct file * f, const char * buf, size_t n, loff_t * off) {
    pr_info("%s called", __FUNCTION__);
    for (int i = 0; i < n; i++) {
        asm volatile (
                "outb %%al, %%dx"
                :
                : "a" (buf[i]),
                  "d" (QEMU_DEBUGCON_IO_PORT)
                :
        );
    }
    return n;
}

char *debugcon_devnode_mode(const struct device *dev, umode_t *mode) {
    pr_info("%s called", __FUNCTION__);
    *mode = 0666;
    return NULL;
}

/*int is_qemu_hypervisor(void) {
    int res;
    // See https://github.com/qemu/qemu/blob/6512fa497c2fa9751b9d774ab32d87a9764d1958/target/i386/cpu.c
    const char * vendor = "TCGTGTCGCGTC";
    uint32_t cpuid_res[4];
    cpuid(
            // x86 hypervisor info leaf
            0x40000000,
            &cpuid_res[0], // eax
            &cpuid_res[1], // ebx
            &cpuid_res[2], // ecx
            &cpuid_res[3] // edx
    );
    const uint32_t actual_vendor_str_chunk[3] = {
            [0] = cpuid_res[1],
            [1] = cpuid_res[3],
            [2] = cpuid_res[2],
    };
    pr_info("Hypervisor=%s", (char*)actual_vendor_str_chunk);
    res = strncmp(vendor, (char*) actual_vendor_str_chunk, 12);
    if (res) {
        return -EINVAL;
    } else {
        return 0;
    }
}*/

/**
 * Module/driver initializer. Called on module load/insertion.
 *
 * @return success (0) or error code.
 */
static int __init debugcon_module_init(void) {
    int rc;
    pr_info("%s", __FUNCTION__);

    // Nope, I don't do this. It is up to the user. This is too complicated to check
    // automatically as a user can also use QEMU if the Hypervisor ID is kvm.
    /*rc = is_qemu_hypervisor();
    if (rc) {
        pr_err("Not running under QEMU. Hypervisor ID is not the one from QEMU.");
        goto end;
    } else {
        pr_info("Running under QEMU Hypervisor.");
    }*/

    rc = alloc_chrdev_region(&dev_num, 0, CHR_DEV_COUNT, "debugcon");
    if (rc) {
        pr_err("Failed to allocate chrdev region\n");
        goto end;
    }

    dev_major = MAJOR(dev_num);

    debugcon_class = class_create(THIS_MODULE, "debugcon");
    if (IS_ERR(debugcon_class)) {
        rc = PTR_ERR(debugcon_class);
        pr_err("Failed to create driver class\n");
        goto end;
    }

    // Set permissions for user processes.
    debugcon_class->devnode = debugcon_devnode_mode;

    cdev_init(&chrdev, &fops);
    chrdev.owner = THIS_MODULE;

    rc = cdev_add(&chrdev, dev_num, 1);
    if (rc) {
        pr_err("Failed to add char dev\n");
        goto end;
    }

    // Create device node /dev/debugcon
    device = device_create(debugcon_class, NULL, dev_num, NULL, "debugcon");
    if (IS_ERR(device)) {
        rc = PTR_ERR(device);
        pr_err("Failed to call device_create\n");
        goto end;
    }

    pr_info("QEMU Debugcon Driver inserted: /dev/debugcon available\n");

  end:
    return rc;
}

/**
 * Module/driver uninitializer. Called on module unload/removal.
 */
static void __exit debugcon_module_exit(void) {
    device_destroy(debugcon_class, dev_num);
    class_unregister(debugcon_class);
    class_destroy(debugcon_class);
    cdev_del(&chrdev);
    unregister_chrdev_region(dev_num, CHR_DEV_COUNT);
    pr_info("QEMU Debugcon Driver unloaded.\n");
}

module_init(debugcon_module_init);
module_exit(debugcon_module_exit);
