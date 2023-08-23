# Installation

Use the Determinate Systems to install nix.
[https://github.com/DeterminateSystems/nix-installer](https://github.com/DeterminateSystems/nix-installer)

# setup

Create a private repo in your github account named `dotfiles`.
Clone your repo into your home directory using the following command

```
git clone git@github.com:<your.github.account>/dotfiles ~/.config/nix-darwin
```

```
cd ~/.config/nix-darwin
```

- Refer to the `flake.nix` file for the contents of your file. Update the `flake.nix` file based on your machine settings.
- Copy your .zshrc contents to programs.zsh.initExtra.

# Build your config

To bootstrap nix-darwin, use the command:

```
nix build .#darwinConfigurations.<your.hostname>.system
```

Then to activate your profile use:

```
./result/sw/bin/darwin-rebuild switch --flake .
```

Subsequent changes to your `flake.nix` file can activated with

```
darwin-rebuild switch --flake ~/.config/nix-darwin
```

or simply in zsh.

```
dr-switch
```

# direnv

Direnv is a utility that we can use to leverage nix flakes to configure environment variables based
on your working directory.

## Setting up direnv with EmpyreanGO

In the EmpyreanGO root folder, enter the following commands.

```
touch .envrc && echo "use flake" >> .envrc
```

After you enter to command above, you should see a message like

> direnv: error <path.info>/empyrean/mobile/empyreango/.envrc is blocked. Run `direnv allow` to approve its content

Enter `direnv allow` to activate direnv for EmpyreanGO and wait for nix to build the configuration.

# Uninstall

To uninstall nix, first uninstall nix-darwin with:

```
nix-build https://github.com/LnL7/nix-darwin/archive/master.tar.gz -A uninstaller
./result/bin/darwin-uninstaller
```

If you get the following warning

> warning: Nix search path entry '/nix/var/nix/profiles/per-user/root/channels' does not exist, ignoring
> then run:

```
 sudo -i nix-channel --add https://nixos.org/channels/nixpkgs-unstable nixpkgs
 sudo -i nix-channel --update nixpkg
```

Then uninstall nix using the nix-installer:

```
/nix/nix-installer uninstall
``

# Resources

- [Zero-to-nix](https://zero-to-nix.com/)
- [Home manager](https://nix-community.github.io/home-manager/)
- [direnv](https://direnv.net/)
```
