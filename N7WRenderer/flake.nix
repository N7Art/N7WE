{
  description = "raylib flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };
  outputs =
    {self,  nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {

      devShells.${system}.default = pkgs.mkShell {
        buildInputs =
          (with pkgs; [
            wayland-scanner
            wayland
            libxkbcommon
            libGLX
            zig
          ])
          ++ (with pkgs.xorg; [

            libX11
            libXcursor
            libXext
            libXfixes
            libXi
            libXinerama
            libXrandr
            libXrender
          ]);

      };
    };
}
