{
  inputs.nixpkgs.url = "nixpkgs/nixos-20.09";
  inputs.utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, utils }:
    utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};

        texliveEnv = pkgs.texlive.combine {
          inherit (pkgs.texlive)
            xstring;
        };

        mkPackage = isShell:
          let
            devPackages = with pkgs;
              lib.optionals isShell [ nixfmt fd texstudio ];

          in pkgs.stdenv.mkDerivation {
            name = "cv";
            src = if isShell then null else self;

            makeFlags = [ "OUTPUT_DIR=$(out)" ];

            dontInstall = true;

            buildInputs = with pkgs;
              [ gnumake which texliveEnv ] ++ devPackages;
          };
      in {
        packages = { cv = mkPackage false; };
        devShell = mkPackage true;
      });
}
