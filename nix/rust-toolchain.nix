# Comes from "rust-overlay".
{ rust-bin }:

# This is the Rust version that the kernel currently expects at my selected
# revision.
rust-bin.stable."1.68.2".default
