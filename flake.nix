{
  description = "Sphinx builder";

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        packages = import ./packages.nix { inherit pkgs; };
      in
      {
        packages = {
          inherit (pkgs)
            skopeo;
        } // packages;
      }
    );
}
