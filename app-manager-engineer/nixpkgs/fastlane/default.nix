{ lib, bundlerApp, makeWrapper, git, gnutar, gzip }:

bundlerApp {
  pname = "fastlane";
  gemdir = ./.;
  exes = [ "fastlane" ];

  nativeBuildInputs = [ makeWrapper ];

  postBuild = ''
    wrapProgram $out/bin/fastlane
  '';
}
