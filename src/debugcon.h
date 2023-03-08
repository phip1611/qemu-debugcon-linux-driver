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

#pragma once

#define CHR_DEV_COUNT 1
#define QEMU_DEBUGCON_IO_PORT 0xe9

// Opens the debugcon device. Ensures that only one user at a time can access
// the device.
int device_open(struct inode *, struct file *);
// Releases/closes the debugcon device.
int device_release(struct inode *, struct file *);
// Writes all messages to the debugcon I/O port.
ssize_t device_write(struct file *, const char *, size_t, loff_t *);
// Sets the access mode (permissions) of a device node.
char *debugcon_devnode_mode(const struct device *dev, umode_t *mode);

// Numeric identifier of the driver.
extern dev_t dev_num;
// Major number of the character device driver
extern int dev_major;
// Either 0 or 1, if the device file is opened by a process.
// All accesses to this variable must happen as atomic operation.
extern int device_is_opened;
// class structure
extern struct class * debugcon_class;
// Char dev data.
extern struct cdev chrdev;
// File operations of the debugcon character device.
extern struct file_operations fops;
// The device created with device_create.
extern struct device * device;


