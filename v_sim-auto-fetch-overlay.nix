{ ... } : final: prev: {
  v_sim = final.callPackage (import (final.fetchFromGitHub {
    owner = "Jonas-Finkler";
    repo = "v_sim-nix";
    rev = "aed0ab192e14e328879db8bb43c98639552155e1";
    sha256 = "sha256-gOo1m0UvbqLytBjlrQJxew7g/vmKOznThzCBC5PMHjc=";
  } + "/v_sim/")) {};
}
