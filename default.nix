{ sources ? import ./nix/sources.nix,
  nixpkgs ? sources.nixpkgs,
  pkgs ? import nixpkgs {} }:
{
  toolchain = pkgs.callPackage ./pkgs/toolchain.nix {};
}
