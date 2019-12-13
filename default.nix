{ sources ? import ./nix/sources.nix,
  nixpkgs ? sources.nixpkgs,
  pkgs ? import nixpkgs {} }:
rec {

  toolchain = pkgs.callPackage ./pkgs/toolchain.nix {};

  goa = pkgs.callPackage ./pkgs/goa.nix { inherit toolchain; };
}
