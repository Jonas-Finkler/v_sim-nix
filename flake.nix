
{
  description = "v_sim - Visualize atomic structures";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
        };
      in rec {
        packages.${system}.v_sim = pkgs.callPackage ./v_sim {};
        defaultPackage = packages.${system}.v_sim;
      }
    );
}
