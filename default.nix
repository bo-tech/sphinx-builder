{ system ? builtins.currentSystem
, pkgs ? import <nixpkgs> { inherit system; }
, withPdf ? false
}:

let
  packages = import ./packages.nix { inherit pkgs withPdf; };
in packages.container-image
