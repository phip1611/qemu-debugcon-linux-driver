# Comes from "rust-overlay".
{ rust-bin }:

# This is the Rust version that the kernel currently expects at my selected
# revision.
# This can be found out when the kernel is build with "make -V12" or if
# "./scripts/rust_is_aviailable.sh -v" is executed manually.
rust-bin.stable."1.66.0".default.override {
  # Linux build system cross-compiles the core lib.
  extensions = [ "rust-src" ];
}
