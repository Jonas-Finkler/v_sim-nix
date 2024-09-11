
{
  description = "v_sim - Visualize atomic structures";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
        };
        v_sim = pkgs.callPackage ./v_sim {};
      in {
        packages = { 
          default = v_sim;
          inherit v_sim; 
        };
        defaultPackage = v_sim;
        devShells.default = pkgs.mkShell {
          buildInputs = [ v_sim ];
        };
      }
    );
}
