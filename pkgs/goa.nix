{ stdenv, lib, expect, tcl, libxml2, fetchFromGitHub, makeWrapper, gnumake, gnupg, toolchain }:
stdenv.mkDerivation {
  pname = "goa";
  version = "0.0.0-dev";

  src = fetchFromGitHub {
    owner = "nfeske";
    repo = "goa";
    rev = "cc66bd611fe086e76a8ca673b9756b33620b1355";
    sha256 = "0xkpymf9qj34nghn1zy7v0dm968krag3qfix6d5523i4c1wlr144";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ tcl expect ];

  postPatch = ''
    substituteInPlace share/goa/lib/command_line.tcl \
      --replace "/usr/local/genode/tool/current/bin/genode-x86-" "${toolchain}/bin/genode-x86-"
   
    patchShebangs bin/goa
    patchShebangs share/goa/gosh/gosh
  '';

  postFixup = ''
    wrapProgram $out/bin/goa --prefix PATH : ${lib.makeBinPath [ libxml2 gnumake gnupg ]}
  '';
  
  installPhase = ''
    mkdir $out
    cp -r bin/ share/ $out
  '';
}
