{ ... } : final: prev: {
  v_sim = final.callPackage (import (final.fetchFromGitHub {
    owner = "Jonas-Finkler";
    repo = "v_sim-nix";
    rev = "88f1c4ddd1db8a567c73937ec2d533fbdb385d18";
    sha256 = "";
  }) + "/v_sim") {};
}
