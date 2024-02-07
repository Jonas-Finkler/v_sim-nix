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
If you are not using flakes, the process is very similar but you use `nix-build build.nix` to build the package and `nix-shell shell.nix` to access a shell with v_sim available.


## Installing v_sim
There are multiple options, how you can install v_sim permanently. 

### Using flakes


### Using overlays
#### Manually copying the derivation

#### Automatically pulling it from GitHub



