{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };
  outputs =
    { self, nixpkgs }@inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      inherit (pkgs)
        wayland-scanner
        wayland
        libxkbcommon
        libGLX
        ;
      inherit (pkgs.xorg)
        libX11
        libXcursor
        libXext
        libXfixes
        libXi
        libXinerama
        libXrandr
        libXrender
        ;
    in
    {

      devShells.${system}.default = pkgs.mkShell {

        buildInputs = [
          wayland-scanner
          wayland
          libxkbcommon
          libGLX

          libX11
          libXcursor
          libXext
          libXfixes
          libXi
          libXinerama
          libXrandr
          libXrender
        ];
      };

    };
}
