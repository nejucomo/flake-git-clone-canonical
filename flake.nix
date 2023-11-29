{
  # The source code:
  inputs.gcc = {
    url = "github:nathan-at-least/git-clone-canonical";
    flake = false;   
  };
  
  # Flake toolchain:
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  inputs.nci.url = "github:yusdacra/nix-cargo-integration";
  inputs.nci.inputs.nixpkgs.follows = "nixpkgs";
  inputs.parts.url = "github:hercules-ci/flake-parts";
  inputs.parts.inputs.nixpkgs-lib.follows = "nixpkgs";

  outputs = inputs @ {
    parts,
    gcc,
    nci,
    ...
  }:
    parts.lib.mkFlake {inherit inputs;} {
      systems = ["x86_64-linux"];
      imports = [
        nci.flakeModule
        ./crates.nix
      ];
      perSystem = {
        pkgs,
        config,
        ...
      }: let
        # you can access crate outputs under `config.nci.outputs.<crate name>` (see documentation)
        crateOutputs = config.nci.outputs.git-clone-canonical;
      in {
        devShells.default = crateOutputs.devShell;
        packages.default = crateOutputs.packages.release;
      };
    };
}
