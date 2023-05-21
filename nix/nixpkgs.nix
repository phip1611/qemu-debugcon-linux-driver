# Pinned nixpkgs version with Rust overlay.

let
  rust-overlay-src =
    let
      # When you change this, also change the sha256 hash!
      rev = "e2ceeaa7f9334c5d732323b6fec363229da4f382";
    in
    builtins.fetchTarball {
      url = "https://github.com/oxalica/rust-overlay/archive/${rev}.tar.gz";
      sha256 = "sha256:1rs8k4fs46vkw21ahc1zqa57hlaibcgqkqqm2g5x4pkkgh762nk0";
    };
  rust-overlay = import rust-overlay-src;

  stableSrc = /home/pschuster/dev/nixpkgs;
  /*let
      # Picked a recent commit from the nixos-22.11-small branch.
      # https://github.com/NixOS/nixpkgs/tree/nixos-22.11-small
      #
      # When you change this, also change the sha256 hash!
      rev = "a45745ac9e4e1eb86397ab22e2a8823120ab9a4c";
    in
    builtins.fetchTarball {
      url = "https://github.com/NixOS/nixpkgs/archive/${rev}.tar.gz";
      sha256 = "sha256:1acllp8yxp1rwncxsxnxl9cwkm97wxfnd6ryclmvll3sa39j9b1z";
    };*/
  overlays = [ rust-overlay ];
in
{
  stable = import stableSrc { inherit overlays; };
}
