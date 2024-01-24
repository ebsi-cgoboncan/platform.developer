# Installation

Use the Determinate Systems to install nix.
[https://github.com/DeterminateSystems/nix-installer](https://github.com/DeterminateSystems/nix-installer)

# setup

Create a private repo in your github account named `dotfiles`.
Clone your repo into your home directory using the following command nagivate to it.

```
git clone git@github.com:<your.github.account>/dotfiles ~/.config/nix-darwin
cd ~/.config/nix-darwin
```

Copy the `.gitignore` file from this repo into your `nix-darwin` folder.

### flake.nx

- Copy the `flake.nix` file from this repo into your `nix-darwin` folder.
- Update the following attributes in `flake.nix` file based on your machine settings.
  - username (you can use `whoami` to find your name)
  - hostname (you can use `scutil --get ComputerName`)
  - system (will be either `aarch64-darwin` for apple silicon or `x86_64-darwin` for intel)
    > Note the settings above are case-sensitve.

### .zshrc

- Create folder called `zsh` and copy your your `.zshrc` over to a file named `default.zsh`.

> Review the contents of default.zsh and remove any unneeded settings.

```
mkdir -p ~/.config/nix-darwin/zsh
cp ~/.zshrc ~/.config/nix-darwin/zsh/default.zsh
```

### Host name

- If your hostname is not defined, i.e. the `hostname` command returns an empty string, then temporarily set your hostname with `scutil --set LocalHostName "<your.hostname>"`. Your host name must match your computer name otherwise you will not be able to log into the VPN. To get your computer name, use `scutil --get ComputerName`.

# Build your config

Before you build your config, stage your changes to your git repo. You do not need to commit the changes before you build, but you should commit them once you get a successful build. This will let you rollback your config changes if something catastrophic happens.
To bootstrap nix-darwin, use the command:

```
nix build .#darwinConfigurations.<your.hostname>.system
```

nix-darwin will manage `/etc/nix/nix.conf` so we need to rename it to activate the profile.

```
sudo mv /etc/nix/nix.conf /etc/nix/nix.conf.nix-backup
```

Then to activate your profile use:

```
./result/sw/bin/darwin-rebuild switch --flake .
```

If you get an error about overriding a file, rename the file in question by adding `.nix-backup` after the extension.

Once the profile has been activated, restart your terminal session.

Subsequent changes to your `flake.nix` file can activated with

```
darwin-rebuild switch --flake ~/.config/nix-darwin
```

or simply in with the alias

```
dr-switch
```

# direnv

Direnv is a utility that we can use to leverage nix flakes to configure environment variables based
on your working directory.

## Setting up direnv with EmpyreanGO

In the EmpyreanGO root folder, enter the following commands.

```
touch .envrc
```

Thie contents of the .envrc file should be

```
layout node
use flake
```

After you enter to command above, you should see a message like

> direnv: error <path.info>/empyrean/mobile/empyreango/.envrc is blocked. Run `direnv allow` to approve its content

Type in `direnv allow` into y our prompt to activate direnv for EmpyreanGO and wait for nix to build the configuration.

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
```

# Resources

- [Zero-to-nix](https://zero-to-nix.com/)
- [Home manager](https://nix-community.github.io/home-manager/)
- [Home manager options](https://nix-community.github.io/home-manager/options.xhtml)
- [nix-darwin](https://daiderd.com/nix-darwin/manual/index.html)
- [direnv](https://direnv.net/)
