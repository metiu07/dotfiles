# My personal dotfiles
Current default configuration consists of:

- arch/manjaro
- i3 {polybar, compton, nitrogen, rofi, lightdm}
- bash/fish {urxvt, tmux}
- emacs
- ranger

You can see preview in
![Current state of dotfiles](./screenshots/23.6.2019.png)

More screenshots can be found in this [folder](screenshots).

# Instalation

First step is to clone this repository:

```bash
git clone https://www.github.com/metiu07/dotfiles
```

The repository contains installation scripts. Namely:

- install.py
- install.sh

The [requirements.txt](requirements.txt) file contains arch package names of used packages. I am
trying to keep the list updated, but if something is missing simple google query
should find you the right package.

## Script - install.py

This is new and intended way to install dotfiles. To run this script at least
python version 3.5 is needed. Example usage is shown in the next snippet.

```bash
./install.py # install default target (linux)
./install.py bash # install bash module
./install.py -r bash # remove bash module
./install.py linux # install linux target
./install.py -l # list all modules
./install.py -i asd.json asd # use custom json configuration file
./install.py -d linux # dry run (show user the command which will be run)
./install.py -m linux # install via moving instead of symlink
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
    "$deps": [
      "ranger_rifle"
    ]
  }
```

## Script - install.sh

This script is deprecated and should not be used anymore. It's included only
because of nostalgy and for educational purposes.
