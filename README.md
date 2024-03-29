# My personal dotfiles
Current default configuration consists of:

- [NixOS](https://nixos.org/) (previously arch/manjaro)
- [gruvbox light](https://github.com/morhetz/gruvbox)
- sway {waybar, rofi, lightdm}
- fish {alacritty, tmux}
- Neovim for coding, emacs [Doom!](https://github.com/hlissner/doom-emacs) for [org-mode](https://orgmode.org/)
- [rg](https://github.com/BurntSushi/ripgrep), [fzf](https://github.com/junegunn/fzf), [ranger](https://github.com/ranger/ranger)
- ...

You can see preview in (very likely out of date)
![Current state of dotfiles](./screenshots/23.6.2019.png)

More screenshots can be found in this [folder](screenshots).

# Installation

First step is to clone this repository:

```bash
git clone https://www.github.com/metiu07/dotfiles
```

The repository contains installation scripts. Namely:

- install.py
- install.sh # deprecated

The [requirements.txt](requirements.txt) file contains arch package names of used packages. I am
trying to keep the list updated, but if something is missing simple google query
should find you the right package.

## Script - install.py

This is new and intended way to install dotfiles. To run this script at least
python version 3.5 is needed. Example usage is shown in the next snippet.

```bash
./install.py                 # install default target (linux)
./install.py bash            # install bash module
./install.py -r bash         # remove bash module
./install.py linux           # install linux target
./install.py -l              # list all modules
./install.py -i asd.json asd # use custom json configuration file
./install.py -d linux        # dry run (show user the command which will be run)
./install.py -m linux        # install via moving instead of symlink
./install.py -a linux        # auto-confirm all prompts
```

The program configuration is stored in json file `configuration.json`. For
example next snippet means that the file `./.config/ranger/rc.conf` will be
installed to the location `./.config/ranger/rc.conf` and also depends on module
`ragner_rifle`.

```json
  "ranger": {
    "source": "./.config/ranger/rc.conf",
    "destination": "~/.config/ranger/rc.conf",
    "name": "Ranger configuration",
    "install": "./scripts/install.sh",
    "$deps": [
      "ranger_rifle"
    ]
  }
```

## Script - install.sh

This script is deprecated and should not be used anymore. It's included only
because of nostalgia and for educational purposes.

## FAQ
### How to setup default applications

```bash
xdg-mime default org.pwmt.zathura.desktop application/pdf
```

### Sway

#### How to change tty

Press `ctrl` + `alt` + `cmd` + `fX` key.

### Firefox
**Add-ons:**
- [NoScript](https://addons.mozilla.org/en-US/firefox/addon/noscript/)
- [Dark Reader](https://addons.mozilla.org/en-US/firefox/addon/darkreader/)
- [Vimium-FF](https://addons.mozilla.org/en-US/firefox/addon/vimium-ff/)
- [Imagus](https://addons.mozilla.org/en-US/firefox/addon/imagus/)
- [uBlock Origin](https://addons.mozilla.org/en-US/firefox/addon/ublock-origin/)
- [I don't care about cookies](https://addons.mozilla.org/en-US/firefox/addon/i-dont-care-about-cookies/)
- [Web Archives](https://addons.mozilla.org/en-US/firefox/addon/view-page-archive/)

#### Vimium-FF
- there is a setting to ignore keyboard layout

#### Fullscreen - don't hide the toolbar

1) Go to `about:config` in firefox
2) Set the `browser.fullscreen.autohide` to `false`

#### Wayland

```bash
mkdir -p ~/.local/share/applications
# Setup for rofi
cp /usr/share/applications/firefox.desktop ~/.local/share/applications
# Every "Exec=..." prefix with "Exec=env MOZ_ENABLE_WAYLAND=1 ..."
# Correct links from applications
# NOTE: firefox.desktop is only a name, not a file path
xdg-settings set default-web-browser firefox.desktop
```

### Mac keyboard - fn keys

```bash
# Permanent
echo "options hid_apple fnmode=2" | sudo tee /etc/modprobe.d/hid_apple.conf
mkinitcpio -p linux

# Temporary
echo 2 | sudo tee /sys/module/hid_apple/parameters/fnmode
```

## Inspiration

This wouldn't have been possible without other people who share their dotfiles. Take this as a list of my appreciation and inspiration.

|Name/Link|Note|
|-|-|
|https://github.com/valebes/nix-dotfiles | |
|https://github.com/hlissner/dotfiles | |
|https://gitlab.com/JoelDimbernat/rofi-menus | |
|https://github.com/davidpdrsn| |
|https://github.com/LukeSmithxyz/voidrice | |
|https://github.com/s3rvac/dotfiles | |
|https://github.com/metthal/configs | |
|https://github.com/geohot/configuration | |
|https://github.com/okubax/dotfiles | |
|https://github.com/089kili/dotfiles | | 
|https://github.com/Madic-/Sway-DE | |
