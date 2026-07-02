{
  description = "FP lab 20XX/XX";

  outputs = inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } {
    systems = [
      "aarch64-linux"
      "i686-linux"
      "x86_64-linux"
      "aarch64-darwin"
      "x86_64-darwin"
    ];

    perSystem = { lib, pkgs, system, ... }: let
      hsPkgs = pkgs.haskell.packages."ghc947";

      buildInputs = [
        hsPkgs.ghc
        hsPkgs.haskell-language-server
        hsPkgs.hlint
        pkgs.cabal-install
        pkgs.hpack
      ];
    in {
      devShells.default = pkgs.mkShell {
        inherit buildInputs;

        # Make external Nix c libraries like zlib known to GHC, like
        # pkgs.haskell.lib.buildStackProject does
        # https://github.com/NixOS/nixpkgs/blob/d64780ea0e22b5f61cd6012a456869c702a72f20/pkgs/development/haskell-modules/generic-stack-builder.nix#L38
        env.LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath buildInputs;
      };
    };
  };

  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
  };
}
