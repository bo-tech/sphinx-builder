{ pkgs ? import <nixpkgs> {}
, withPdf ? false
}:

let
  packages = import ./packages.nix { inherit pkgs withPdf; };
in packages.container-image
