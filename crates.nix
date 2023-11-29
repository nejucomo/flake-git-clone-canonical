{inputs, ...}: {
  perSystem = {
    ...
  }: let
    crateName = "git-clone-canonical";
  in {
    nci.projects.${crateName}.path = inputs.gcc.outPath;
    nci.crates.${crateName} = {};
  };
}
