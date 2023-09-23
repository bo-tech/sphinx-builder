{ pkgs ? import <nixpkgs> {}
, withPdf ? false
}:

# Minimal environment to build the document.
# Includes a minimal custom texlive distribution for PDF generation.

let

  python = let
    packageOverrides = self: super: {

    };
  in pkgs.python3.override { inherit packageOverrides; self = python; };

  sphinx-env = python.withPackages(ps: [
    ps.myst-parser
    ps.reportlab
    ps.sphinx
    ps.sphinxcontrib-blockdiag
    ps.sphinxcontrib-actdiag
    ps.sphinxcontrib-seqdiag
    ps.sphinx-autobuild

    # TODO: deprecated below, remove with 1.0.0
    ps.sphinx-mdinclude
  ]);

  # Hand picked texlive setup. It is fairly minimal and just enough for the
  # needs of the PDF generation via "make latexpdf". Closure is around 350 MiB,
  # compared to several GiB for the full distribution.
  latex = pkgs.texlive.combine {
    inherit (pkgs.texlive)
      scheme-basic
      latexmk

      # fonts
      courier
      ec
      eurosym
      helvetic
      metafont
      tex-gyre
      times
      zapfding

      # packages
      capt-of
      cmap
      fancyvrb
      float
      fncychap
      framed
      needspace
      parskip
      tabulary
      titlesec
      upquote
      varwidth
      wrapfig;
  };

  full-sphinx-env = pkgs.buildEnv {
    name = "full-sphinx-env";
    paths = [
      sphinx-env
      pkgs.bash
      pkgs.coreutils
      pkgs.gnumake
    ] ++ (pkgs.lib.optionals withPdf [
      latex
      pkgs.ipafont
    ]);
  };

in pkgs.dockerTools.buildLayeredImage
  {
    name = "sphinx-builder";
    contents = [
      full-sphinx-env
    ];
    config = {
      Cmd = [ "${pkgs.bash}/bin/bash" ];
    };
  }
