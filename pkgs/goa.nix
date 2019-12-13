{ sources, stdenv, lib, expect, tcl, libxml2, fetchFromGitHub, makeWrapper, git, gnumake, gnupg, toolchain }:
stdenv.mkDerivation {
  pname = "goa";
  version = "0.0.0-dev";

  src = sources.goa;

  patches = [ ../patches/goa.patch ];

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ tcl expect ];

  postPatch = ''
    substituteInPlace share/goa/lib/command_line.tcl \
      --replace "/usr/local/genode/tool/current/bin/genode-x86-" "${toolchain}/bin/genode-x86-"
  '';

  postFixup = ''
    wrapProgram $out/bin/goa --prefix PATH : ${lib.makeBinPath [ libxml2 gnupg gnumake git ]}
  '';
  
  installPhase = ''
    mkdir $out
    cp -r bin/ share/ $out
  '';
}
