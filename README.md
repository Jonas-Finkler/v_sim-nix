# v_sim-nix
This repository aims to help make the atomic visualization software [v_sim](https://l_sim.gitlab.io/v_sim/index.en.html) available under Nix and NixOS.

## Building v_sim
There are several ways to try out v_sim before you install it permanently.  
For all options below, you first need to clone this repository and `cd` into it. 


### Using Flakes
You can build the v_sim package with `nix build .`.
The v_sim executable can now be found under `./result/bin/v_sim`.  

Alternatively you can use `nix develop .`, which will drop you into a shell in which you can launch v_sim by typing `v_sim`.


### Without Flakes
If you are not using flakes, the process is very similar, but you use `nix-build build.nix` to build the package and `nix-shell shell.nix` to access a shell with v_sim available.


## Installing v_sim
There are multiple options, how you can install v_sim permanently. 

### NixOS without flakes
Overlays allow you to modify nixpkgs in your NixOS installation. 
We can use them to add v_sim, such that you can simply install v_sim like any other package in your `configuration.nix` (or with home-manager).
```nix
  environment.systemPackages = with pkgs; [
    ...
    v_sim
  ];
```

There are two possibilities on how you can set up such an overlay.
#### Manually copying the derivation
Copy the `v_sim` directory into the folder with your `configuration.nix`.  

Add the following to your `configuration.nix`.
```nix
  nixpkgs.overlays = [
    (final: prev: { v_sim = final.callPackage ./v_sim {};})
  ];
```

#### Automatically pulling it from GitHub
You can also use the following to automatically download this repository from GitHub and avoid manually copying the files.  
```nix
  nixpkgs.overlays = [
    (final: prev: {
      v_sim = final.callPackage (import (final.fetchFromGitHub {
        owner = "Jonas-Finkler";
        repo = "v_sim-nix";
        rev = "979392c78f39a8fc1e62b1a14c8cd97ad33aeaeb";
        sha256 = "sha256-vRDnBAMEYMWWst9OBj0wH0MG1wG/iqeajeH2DthZHRE=";
      } + "/v_sim")) {};
    })
```
To update v_sim, replace `rev` with the latest tag or commit of this repository. 
Remember to always replace the sha256 with `""`, otherwise, Nix will still use the last version it downloaded that has the given sha256. 

Once you clear the sha256, nix will complain. 
```
       error: hash mismatch in fixed-output derivation '/nix/store/fj8fsan3vi3azw9yzmlyp27mm648xzan-source.drv':
         specified: sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=
            got:    sha256-gOo1m0UvbqLytBjlrQJxew7g/vmKOznThzCBC5PMHjc=
```
Fix this by copying the new sha256 it gives you into the `configuration.nix`.



### Flakes based NixOS
Add this repository to your flake inputs.
```nix
  inputs = {
    ...
    v_sim-nix.url = "github:Jonas-Finkler/v_sim-nix";
    v_sim-nix.inputs.nixpkgs.follows = "nixpkgs";
  }
```

You can then either include v_sim in nixpkgs using an overlay.
```nix
  nixosConfiguration = {
    "your-hostname" = nixpkgs.lib.nixosSystem rec {
      system = "x86_64-linux";
      ...
      modules = [
        ({
          nixpkgs.overlays = [
            (final: prev: {v_sim = v_sim-nix.packages.${system}.v_sim;})
          ];
        })
      ];
    };
  }
```

Or pass it to your `nixosConfiguration` under `specialArgs` or to your home-manager under `extraSpecialArgs`.


