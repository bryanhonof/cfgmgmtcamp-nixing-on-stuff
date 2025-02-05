[
  (final: prev: {

    #openssl = prev.openssl.overrideAttrs (old: {
    #  name = "libressl";
    #});

    pythonPackagesExtensions = [
      (finalp: prevp: {

        # stdenv.mkDerivation { ... }
        idna = prevp.idna.overrideAttrs (old: {
          name = old.name + "-florp";
        });
      })
    ];

    # this is how Nixpkgs is built up, more or less
    # gcc = final.callPackage ./gcc {};
  })
]
