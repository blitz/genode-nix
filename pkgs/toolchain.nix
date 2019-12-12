{ stdenv, fetchurl, ncurses5, expat }:
stdenv.mkDerivation rec {
  pname = "genode-toolchain";
  version = "19.05";

  src = fetchurl ({
    x86_64-linux = {
      url = "mirror://sourceforge/project/genode/${pname}/${version}/${pname}-${version}-x86_64.tar.xz";
      sha256 = "036czy21zk7fvz1y1p67q3d5hgg8rb8grwabgrvzgdsqcv2ls6l9";
    };
  }.${stdenv.hostPlatform.system}
    or (throw "cannot install Genode toolchain on this platform"));

  phases = [ "unpackPhase" "installPhase" "fixupPhase" ];

  dontStrip = true;
  dontPatchELF = true;

  libPath = stdenv.lib.makeLibraryPath [
    "$out" stdenv.cc.cc expat ncurses5
  ];

  preFixup = ''
    for p in $(find "$out" -type f -executable); do
      if isELF "$p"; then
        echo "Patchelfing $p"
        patchelf "$p"
        patchelf --set-interpreter $(cat ${stdenv.cc}/nix-support/dynamic-linker) "$p"  || true
        patchelf --set-rpath ${libPath}  "$p" || true
      fi
    done
  '';

  installPhase = ''
    mkdir $out
    cp -r local/genode/tool/${version}/* $out
  '';
}
