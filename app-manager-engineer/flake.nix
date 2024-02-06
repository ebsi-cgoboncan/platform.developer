{
  description = "appmanager.build";

  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs/nixos-23.11;
    flake-utils.url = github:numtide/flake-utils;
    nix-filter.url = github:numtide/nix-filter;

    devshell = {
      url = github:numtide/devshell;
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };

    enspire-pkgs = {
      url = github:ebsi-epd/service.benefitgo/dev;
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
      inputs.nix-filter.follows = "nix-filter";
    };

    android-nixpkgs = {
      url = github:tadfisher/android-nixpkgs;
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.devshell.follows = "devshell";
      inputs.flake-utils.follows = "flake-utils";
    };
  };

  outputs = { self, nixpkgs, flake-utils, nix-filter, enspire-pkgs, android-nixpkgs, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        inherit (pkgs.stdenv) isDarwin;
        inherit (pkgs.lib.lists) optionals;
        inherit (pkgs.lib.strings) optionalString;
        inherit (enspire-pkgs.packages.${system}) enspire;
        fastlane = pkgs.callPackage ./nixpkgs/fastlane { };

        build = {
          buildInputs = with pkgs; [ enspire firebase-tools ruby bundix ] ++ [ fastlane ]; # gh go-task  ];
          shellHook =
            ''
              # required for fastlane
              export PATH=./node_modules/.bin:$PATH
              export LANG=en_US.UTF-8
              export TASK_X_REMOTE_TASKFILES=1
            '';
        };

        ios =
          let
            xcodeenv = import "${nixpkgs}/pkgs/development/mobile/xcodeenv" { callPackage = pkgs.callPackage; };
            xcode = xcodeenv.composeXcodeWrapper rec {
              version = "15.2";
              xcodeBaseDir = "/Applications/Xcode.app";
            };
          in
          {
            buildInputs = with pkgs; [
              xcode
              cocoapods
            ];

            shellHook =
              ''
                export PATH=${xcode}/bin:$PATH
                export LD=/usr/bin/clang
              '';
          };

        android =
          let
            android-sdk = android-nixpkgs.sdk.${system} (p: with p; [
              build-tools-30-0-3
              cmdline-tools-latest
              emulator
              platform-tools
              platforms-android-33
              ndk-23-1-7779620
            ]);
          in
          {
            buildInputs = with pkgs; [
              android-sdk
              jdk11
              gradle_7
              kotlin
            ];

            shellHook =
              ''
                export ANDROID_HOME="${android-sdk}/share/android-sdk"
                export ANDROID_SDK_ROOT="${android-sdk}/share/android-sdk"
                export JAVA_HOME="${pkgs.jdk11.home}"
                export KOTLIN_HOME="${pkgs.kotlin}"
                export PATH=$KOTLIN_HOME/bin:$PATH
              '';
          };
      in
      {
        devShells = {
          iosShell = pkgs.mkShell {
            buildInputs = build.buildInputs ++ ios.buildInputs;
            shellHook = build.shellHook + ios.shellHook;
          };

          androidShell = pkgs.mkShell {
            buildInputs = build.buildInputs ++ android.buildInputs;
            shellHook = build.shellHook + android.shellHook;
          };

          buildShell = pkgs.mkShell {
            buildInputs = build.buildInputs;
            shellHook = build.shellHook;
          };

          default = pkgs.mkShell {
            buildInputs = build.buildInputs ++ android.buildInputs ++ (optionals isDarwin ios.buildInputs);
            shellHook = build.shellHook + android.shellHook + (optionalString isDarwin ios.shellHook);
          };
        };
      });
}

