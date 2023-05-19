// SPDX-License-Identifier: GPL-2.0

//! Rust out-of-tree sample

use kernel::prelude::*;

module! {
    type: RustOutOfTree,
    name: "debugcon",
    author: "Philipp Schuster <phip1611@gmail.com>",
    description: "A Rust driver for the QEMU debugcon device.",
    license: "GPL",
}

struct DebugconDriver {
}

impl kernel::Module for DebugconDriver {
    fn init(_module: &'static ThisModule) -> Result<Self> {
        pr_info!("Rust out-of-tree sample (init)\n");

        Ok(DebugconDriver { })
    }
}

impl Drop for DebugconDriver {
    fn drop(&mut self) {
        pr_info!("Rust out-of-tree sample (exit)\n");
    }
}
