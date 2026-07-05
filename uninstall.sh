#!/usr/bin/env bash
# ==================================================
#  Hackerer theme — uninstaller
#  Maintainer: syndr / UltronCORE — GPL-3.0-or-later
# ==================================================
# Removes the files installed by install.sh. Does NOT restore whatever
# theme you had before; it only deletes Hackerer's payload and leaves your
# Qt/Kvantum/GTK selection to fall back to a system default.
set -u

CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"

note() { printf '\033[33m[NOTE]\033[0m %s\n' "$*"; }

rm -rf "$CONFIG_HOME/Kvantum/Hackerer-Dark"
rm -f  "$CONFIG_HOME/qt5ct/colors/Hackerer-Dark.colors"
rm -f  "$CONFIG_HOME/qt6ct/colors/Hackerer-Dark.colors"
rm -f  "$DATA_HOME/color-schemes/Hackerer.colors"
rm -rf "$HOME/.themes/Hackerer-Dark"
rm -rf "$DATA_HOME/icons/broodwar"

note "Removed Hackerer theme payload."
note "kvantum.kvconfig, qt5ct.conf and qt6ct.conf were left in place — edit them if they still point at Hackerer-Dark."
