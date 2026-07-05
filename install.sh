#!/usr/bin/env bash
# ==================================================
#  Hackerer theme — standalone installer
#  Maintainer: syndr / UltronCORE
#  Based on Daemon MK2 by Mathis Paquet
#  License: GNU GPLv3 — SPDX: GPL-3.0-or-later
# ==================================================
# Installs the Hackerer theme family into the current user's home:
#   Kvantum widget theme, qt5ct/qt6ct color schemes, KDE/Plasma color
#   scheme, GTK theme, and the broodwar cursor.
#
# Dependency-light: needs bash + cp + unzip. kvantummanager,
# kwriteconfig6 and gsettings are used opportunistically when present.
set -u

# Repo root = directory of this script (resolve symlinks).
SELF="$(readlink -f "${BASH_SOURCE[0]}" 2>/dev/null || echo "${BASH_SOURCE[0]}")"
ROOT="$(cd "$(dirname "$SELF")" && pwd)"

CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"

log()  { printf '  %s\n' "$*"; }
ok()   { printf '\033[32m[OK]\033[0m %s\n' "$*"; }
note() { printf '\033[33m[NOTE]\033[0m %s\n' "$*"; }

# Theme identity — overridable via the family profile if present.
gtk_theme="Hackerer-Dark"
icon_theme="Sours-Full-Color"
cursor_theme="broodwar"
profile="$ROOT/hypr/themes/Hackerer.conf"
if [ -f "$profile" ]; then
  # shellcheck disable=SC1090
  . "$profile"
  gtk_theme="${DARK_GTK_THEME:-$gtk_theme}"
  icon_theme="${DARK_ICON_THEME:-$icon_theme}"
  cursor_theme="${DARK_CURSOR_THEME:-$cursor_theme}"
fi

mkdir -p \
  "$CONFIG_HOME/Kvantum" \
  "$CONFIG_HOME/qt5ct/colors" \
  "$CONFIG_HOME/qt6ct/colors" \
  "$DATA_HOME/color-schemes" \
  "$DATA_HOME/icons" \
  "$HOME/.themes"

# --- GTK theme (unzip into ~/.themes/Hackerer-Dark) ---------------------
if [ -f "$ROOT/gtk/Hackerer-Dark.zip" ]; then
  if command -v unzip >/dev/null 2>&1; then
    unzip -q -o "$ROOT/gtk/Hackerer-Dark.zip" -d "$HOME/.themes/" || true
    extracted_dir=$(unzip -Z1 "$ROOT/gtk/Hackerer-Dark.zip" | head -1 | cut -d'/' -f1)
    if [ -n "$extracted_dir" ] && [ "$extracted_dir" != "Hackerer-Dark" ] && [ -d "$HOME/.themes/$extracted_dir" ]; then
      rm -rf "$HOME/.themes/Hackerer-Dark"
      mv "$HOME/.themes/$extracted_dir" "$HOME/.themes/Hackerer-Dark" || true
    fi
    log "GTK theme -> ~/.themes/Hackerer-Dark"
  else
    note "unzip not found; skipping GTK theme. Install unzip and re-run for the GTK theme."
  fi
fi

# --- Kvantum widget theme ----------------------------------------------
if [ -d "$ROOT/Kvantum/Hackerer-Dark" ]; then
  rm -rf "$CONFIG_HOME/Kvantum/Hackerer-Dark"
  cp -r "$ROOT/Kvantum/Hackerer-Dark" "$CONFIG_HOME/Kvantum/"
  log "Kvantum theme -> ~/.config/Kvantum/Hackerer-Dark"
fi
[ -f "$ROOT/Kvantum/kvantum.kvconfig" ] \
  && cp -f "$ROOT/Kvantum/kvantum.kvconfig" "$CONFIG_HOME/Kvantum/kvantum.kvconfig"

# --- qt5ct / qt6ct configs + color schemes -----------------------------
[ -f "$ROOT/qt5ct/qt5ct.conf" ] && cp -f "$ROOT/qt5ct/qt5ct.conf" "$CONFIG_HOME/qt5ct/qt5ct.conf"
[ -f "$ROOT/qt6ct/qt6ct.conf" ] && cp -f "$ROOT/qt6ct/qt6ct.conf" "$CONFIG_HOME/qt6ct/qt6ct.conf"
[ -f "$ROOT/qt5ct/colors/Hackerer-Dark.colors" ] \
  && cp -f "$ROOT/qt5ct/colors/Hackerer-Dark.colors" "$CONFIG_HOME/qt5ct/colors/Hackerer-Dark.colors"
[ -f "$ROOT/qt6ct/colors/Hackerer-Dark.colors" ] \
  && cp -f "$ROOT/qt6ct/colors/Hackerer-Dark.colors" "$CONFIG_HOME/qt6ct/colors/Hackerer-Dark.colors"
log "qt5ct/qt6ct color schemes installed"

# --- KDE/Plasma color scheme -------------------------------------------
[ -f "$ROOT/color-schemes/Hackerer.colors" ] \
  && cp -f "$ROOT/color-schemes/Hackerer.colors" "$DATA_HOME/color-schemes/Hackerer.colors"

# --- Cursor -------------------------------------------------------------
if [ -d "$ROOT/cursors/$cursor_theme" ]; then
  cp -r "$ROOT/cursors/$cursor_theme" "$DATA_HOME/icons/"
  log "Cursor '$cursor_theme' -> ~/.local/share/icons"
fi

# --- KDE / GTK application ----------------------------------------------
if command -v kwriteconfig6 >/dev/null 2>&1; then
  kwriteconfig6 --file "$CONFIG_HOME/kdeglobals" --group General --key ColorScheme "Hackerer" || true
  kwriteconfig6 --file "$CONFIG_HOME/kdeglobals" --group KDE --key widgetStyle "kvantum" || true
fi
if command -v kvantummanager >/dev/null 2>&1; then
  kvantummanager --set "Hackerer-Dark" >/dev/null 2>&1 || true
fi
if command -v gsettings >/dev/null 2>&1; then
  gsettings set org.gnome.desktop.interface color-scheme "prefer-dark" 2>/dev/null || true
  gsettings set org.gnome.desktop.interface gtk-theme "$gtk_theme" 2>/dev/null || true
  gsettings set org.gnome.desktop.interface icon-theme "$icon_theme" 2>/dev/null || true
  gsettings set org.gnome.desktop.interface cursor-theme "$cursor_theme" 2>/dev/null || true
fi

# --- Optional external dependencies -------------------------------------
if [ ! -d "$DATA_HOME/icons/$icon_theme" ] && [ ! -d "/usr/share/icons/$icon_theme" ]; then
  note "Icon theme '$icon_theme' not found. It is an optional external dependency and is not bundled — install it separately for the full look."
fi
if ! command -v kvantummanager >/dev/null 2>&1; then
  note "Kvantum is not installed. Install the 'kvantum' package (provides libkvantum + kvantummanager) so Qt apps pick up the widget theme."
fi

ok "Hackerer theme installed. Log out/in (or restart Qt/GTK apps) to see it applied."
