{ pkgs }:


pkgs.stdenv.mkDerivation {
	name = "archcraft";
	src = pkgs.fetchFromGitHub {
		owner = "iuricarras";
		repo = "sddm-themes";
		rev = "1207fd9649108521cee507d66daeacddeeb41b44";
		sha256 = "05sssd0xkzqrzlwvbdhhhk5pxnyicsm4y35d2s4d19vbix872wif";
	};
	dontUnpack = true;
	installPhase = ''
		mkdir -p $out
		cp -r $src/archcraft/* $out/
		'';
	}
