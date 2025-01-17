{
  description = "Gluten Nix Flake";

  inputs.nix-filter.url = "github:numtide/nix-filter";
  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.nixpkgs.inputs.flake-utils.follows = "flake-utils";
  inputs.nixpkgs.url = "github:nix-ocaml/nix-overlays";

  outputs = { self, nixpkgs, flake-utils, nix-filter }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages."${system}".extend (self: super: {
          ocamlPackages = super.ocaml-ng.ocamlPackages_5_00;
        });
        packages = pkgs.callPackage ./nix { nix-filter = nix-filter.lib; };

      in
      {
        packages = packages // { default = packages.gluten; };
        devShells.default = pkgs.callPackage ./shell.nix { inherit packages; };
      });
}
