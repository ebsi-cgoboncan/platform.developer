# Installation

Use the Determinate Systems to install nix.
https://github.com/DeterminateSystems/nix-installer

# Dotfiles setup

Create a private repo in your github account named `dotfiles`.
Clone your repo into your home directory.

Refer to the `flake.nix` file for the contents of your file. Update the `flake.nix` file

# macOS Hostname

Your hostname will change when you start a new session, so to prevent this add the following in your .zshrc:

```
hostname=$(scutil --get HostName)
if [ -z "$hostname" ]
then
    scutil --set HostName <your.hostname>
fi
```

and restart your terminal session.

# Build your config

## macOS

```
nix build .#darwinConfigurations.<your.hostname>.system
./result/sw/bin/dawrin-rebuild switch --flake .
```

## WSL

```
nix build .#homeConfigurations.<your.username>.activationPackage
./result/home-path/bin/home-manager switch --flake .
```

# direnv

Direnv is a utility that we can use to leverage nix flakes to configure environment variables based
on your working directory.

Follow the instructions for your shell and then restart your terminal session.

## Confirm direnv is in your path

run the following command and you should see something like below:

```
which direnv
# /home/<your.username>/.nix-profile/bin/direnv
```

## BASH

Add the following line at the end of the ~/.bashrc file:

```
eval "$(direnv hook bash)"
```

## ZSH

Add the following line at the end of the ~/.zshrc file:

```
eval "$(direnv hook zsh)"

```

## Setting up direnv with EmpyreanGO

In the EmpyreanGO root folder, enter the following commands.

```
touch .envrc && echo "use flake" >> .envrc
```

After you enter to command above, you should see a message like

> direnv: error <path.info>/empyrean/mobile/empyreango/.envrc is blocked. Run `direnv allow` to approve its content

Enter `direnv allow` to activate direnv for EmpyreanGO and wait for nix to build the configuration.

# Resources

- [Zero-to-nix](https://zero-to-nix.com/)
- [Home manager](https://nix-community.github.io/home-manager/)
- [direnv](https://direnv.net/)
