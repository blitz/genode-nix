{ sources ? import ./nix/sources.nix,
  nixpkgs ? sources.nixpkgs,
  pkgs ? import nixpkgs {} }:
pkgs.mkShell {
  buildInputs = [
    pkgs.haskellPackages.niv
  ];
}
