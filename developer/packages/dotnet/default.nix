{ pkgs, lib, ... }:
let
  inherit (pkgs.dotnetCorePackages) combinePackages;
  dotnet = combinePackages [
    pkgs.dotnet-sdk
    pkgs.dotnet-aspnetcore
    pkgs.dotnet-sdk_7
    pkgs.dotnet-aspnetcore_7
  ];
in
{
  home.packages = with pkgs; [ dotnet powershell ];
  /*
    # the section below is for applications such as JetBrains' Rider that assume the .Net SDK is installed in the user's home directory.
    home.activation.dotnet = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    mkdir -p $HOME/.dotnet

    rm $HOME/.dotnet/bin
    ln -fs ${dotnet}/bin            $HOME/.dotnet/bin

    rm $HOME/.dotnet/dotnet
    ln -fs ${dotnet}/dotnet         $HOME/.dotnet/dotnet

    rm $HOME/.dotnet/host
    ln -fs ${dotnet}/host           $HOME/.dotnet/host

    rm $HOME/.dotnet/packs
    ln -fs ${dotnet}/packs          $HOME/.dotnet/packs

    rm $HOME/.dotnet/sdk
    ln -fs ${dotnet}/sdk            $HOME/.dotnet/sdk

    rm $HOME/.dotnet/sdk-manifests
    ln -fs ${dotnet}/sdk-manifests  $HOME/.dotnet/sdk-manifests

    rm $HOME/.dotnet/share
    ln -fs ${dotnet}/share         $HOME/.dotnet/share

    rm $HOME/.dotnet/shared
    ln -fs ${dotnet}/shared         $HOME/.dotnet/shared

    rm $HOME/.dotnet/templates
    ln -fs ${dotnet}/templates      $HOME/.dotnet/templates
    ''; */
}
