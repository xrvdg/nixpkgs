{ lib, stdenv }:

# A special kind of derivation that is only meant to be consumed by the
# nix-shell.
{
  mergeInputs ? [], # a list of derivations whose inputs will be merged
  buildInputs ? [],
  nativeBuildInputs ? [],
  propagatedBuildInputs ? [],
  ...
}@attrs:
let
  mergeInputs' = name:
    let
      op = item: sum: sum ++ item."${name}" or [];
      nul = [];
      list = [attrs] ++ mergeInputs;
    in
      lib.foldr op nul list;

  rest =
    builtins.removeAttrs
      attrs
      ["mergeInputs" "buildInputs" "nativeBuildInputs" "propagatedBuildInputs"];
in

stdenv.mkDerivation ({
  name = "nix-shell";
  phases = ["nobuildPhase"];

  buildInputs = mergeInputs' "buildInputs";
  nativeBuildInputs = mergeInputs' "nativeBuildInputs";
  propagatedBuildInputs = mergeInputs' "propagatedBuildInputs";

  nobuildPhase = ''
    echo
    echo "This derivation is not meant to be built, aborting";
    echo
    exit 1
  '';
} // rest)
