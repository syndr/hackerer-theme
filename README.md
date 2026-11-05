# Hackerer

A green-on-black **hacker** desktop theme family for Linux — Kvantum + Qt
(`qt5ct`/`qt6ct`), a KDE/Plasma color scheme, a GTK theme, and the `broodwar`
cursor. It's a recolor of the excellent [Daemon MK2](#credits) Kvantum theme.

Maintained by **syndr / UltronCORE**. Extracted from the
[hyprland-wm-config](https://github.com/UltronCORE/hyprland-wm-config) dotfiles so
it can be installed on its own, independent of any particular desktop config.

## What's included

| Component | Installs to |
|---|---|
| Kvantum widget theme `Hackerer-Dark` | `~/.config/Kvantum/Hackerer-Dark/` |
| qt5ct / qt6ct color schemes | `~/.config/qt{5,6}ct/colors/Hackerer-Dark.colors` |
| qt5ct / qt6ct settings (style = kvantum) | `~/.config/qt{5,6}ct/*.conf` |
| KDE/Plasma color scheme | `~/.local/share/color-schemes/Hackerer.colors` |
| GTK theme `Hackerer-Dark` | `~/.themes/Hackerer-Dark/` |
| `broodwar` cursor | `~/.local/share/icons/broodwar/` |

**Not bundled:** the `Sours-Full-Color` icon theme (referenced by name only —
install it separately if you want the full look).

## Requirements

- **Kvantum** (`kvantum` package — provides `libkvantum` and `kvantummanager`) so
  Qt apps pick up the widget style.
- `unzip` (for the GTK theme).
- Optional: `kwriteconfig6` (KDE), `gsettings` (GNOME/GTK) — used automatically
  when present to apply the theme live.

## Install

```sh
git clone https://github.com/syndr/hackerer-theme
cd hackerer-theme
./install.sh
```

Then log out/in (or restart your Qt/GTK apps). To pick it manually instead:
Kvantum Manager → *Hackerer-Dark*; `qt6ct`/`qt5ct` → style *kvantum*; KDE color
scheme → *Hackerer*.

To remove:

```sh
./uninstall.sh
```

The installer is dependency-light (bash + `cp` + `unzip`), touches only your home
directory, and never needs root.

## Credits

Kvantum/Qt theme derived from **Daemon MK2** by **Mathis Paquet**; GTK theme
generated with **Oomox/Themix** on a **Numix** base; cursor by **CORVIAN**. Full
attribution in [`CREDITS.md`](CREDITS.md).

## License

**GNU GPL v3** (`GPL-3.0-or-later`) — see [`LICENSE`](LICENSE). As a derivative of
the GPL-licensed Daemon theme, this project keeps the same license.

Exception: the bundled `broodwar` cursor is third-party artwork, not covered by
the GPL. See [`cursors/README.md`](cursors/README.md).
