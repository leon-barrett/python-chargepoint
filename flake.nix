{
  description = "flake for Python library python-chargepoint";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs?ref=nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    pyproject-nix.url = "github:pyproject-nix/pyproject.nix";
  };

  outputs = { self, nixpkgs, flake-utils, pyproject-nix }:
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = nixpkgs.legacyPackages.${system};
          project = pyproject-nix.lib.project.loadPyproject {
            projectRoot = ./.;
          };
          python = pkgs.python3;
      in rec {
        packages = rec {
          python-chargepoint = python.pkgs.buildPythonPackage (
            project.renderers.buildPythonPackage { inherit python; }
          );
          default = python-chargepoint;
        };

        devShells = {
          default = pkgs.mkShell {
            packages = [(python.withPackages (project.renderers.withPackages {
              inherit python;
              extras = [ "dev" ];
            }))];
          };
        };
      });
}
