{
  description = "Sphinx builder";

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        packages = import ./packages.nix { inherit pkgs; withPdf = true; };

        makeRunner = pkgs.writeShellApplication {
          name = "sphinx-make";
          runtimeInputs = [ packages.full-sphinx-env ];
          text = ''
            exec make "$@"
          '';
        };

        watchRunner = pkgs.writeShellApplication {
          name = "sphinx-watch";
          runtimeInputs = [ packages.sphinx-env ];
          text = ''
            exec sphinx-autobuild . _build/html "$@"
          '';
        };
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

        apps = {
          default = flake-utils.lib.mkApp { drv = makeRunner; };
          watch = flake-utils.lib.mkApp { drv = watchRunner; };
        };
      }
    );
}
