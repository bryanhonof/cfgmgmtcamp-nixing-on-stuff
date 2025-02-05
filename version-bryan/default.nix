{ stdenv }:

stdenv.mkDerivation {
  name = "hello";
  src = ./.;
  buildPhase = ''
    cc -o hello.bin hello.c
  '';
  installPhase = ''
    mkdir -p $out/bin
    mv hello.bin $out/bin/hello.bin
  '';
}
