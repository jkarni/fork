{
  # inspired by: https://serokell.io/blog/practical-nix-flakes#packaging-existing-applications
  description = "A safe fork";
  inputs.nixpkgs.url = "nixpkgs";
  inputs.flake-utils.url = "github:numtide/flake-utils";
  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem ( system:
    let pkgs = nixpkgs.legacyPackages.${system};
    in rec {
      packages.fork = pkgs.haskell.callCabal2Nix ./.;
      # defaultPackage = self.packages.fork;
      inherit pkgs;
      devShell = pkgs.mkShell {
          buildInputs = [
            pkgs.haskell.compiler.ghc901
            pkgs.cabal-install
            pkgs.hpack
          ];
        # Change the prompt to show that you are in a devShell
        shellHook = "export PS1='\\e[1;34mdev > \\e[0m'";
        };
    }
  );
}
