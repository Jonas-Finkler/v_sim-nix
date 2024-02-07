{ nixpkgs ? import <nixpkgs> {}, ... } : let
  v_sim = nixpkgs.callPackage ./v_sim {};
in
  nixpkgs.mkShell {
    nativeBuildInputs = [ v_sim ];
  }
