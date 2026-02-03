{
  description = "Sphinx builder";

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        packages = import ./packages.nix { inherit pkgs; withPdf = true; };
      in
      {
        packages = {
          default = packages.sphinx-env;
          inherit (pkgs)
            skopeo;
        } // packages;

        devShells.default = pkgs.mkShell {
          packages = [ packages.full-sphinx-env ];
        };
      }
    );
}
