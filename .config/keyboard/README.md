I am using [Colemak-DH](https://colemakmods.github.io/mod-dh/).

This is an adapted configuration from DreymaR's BigBag.

I was using this keyboard layout, but it is not exactly what Colemak DH should be. I started using the system provided layout because of:
- it is the same on all systems without need for customisation
- my .xkb file is pain to use, it stopped working on some of my systems

Use the following command to load it on X11 system.

```bash
xkbcomp .config/keyboard/keymap_colemak_dh.xkb $DISPLAY
```

More info on [arch wiki](https://wiki.archlinux.org/title/X_keyboard_extension#Using_keymap).
