{ nixpkgs ? import <nixpkgs> {}, ... } : let
  v_sim = nixpkgs.callPackage ./v_sim {};
in
  v_sim
