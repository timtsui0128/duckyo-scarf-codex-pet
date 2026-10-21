#!/usr/bin/env bash
set -eu

duckyo_script_dir="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
duckyo_source_dir="$(CDPATH= cd -- "$duckyo_script_dir/../pet" && pwd)"
duckyo_target_dir="${DUCKYO_INSTALL_DIR:-${CODEX_HOME:-$HOME/.codex}/pets/duckyo-scarf}"

for duckyo_file in pet.json spritesheet.webp; do
  if [ ! -f "$duckyo_source_dir/$duckyo_file" ]; then
    printf 'Missing source file: %s\n' "$duckyo_source_dir/$duckyo_file" >&2
    exit 1
  fi
done

if [ -e "$duckyo_target_dir" ] && [ ! -d "$duckyo_target_dir" ]; then
  printf 'Installation target is not a directory: %s\n' "$duckyo_target_dir" >&2
  exit 1
fi

mkdir -p -- "$(dirname -- "$duckyo_target_dir")"

if [ -d "$duckyo_target_dir" ]; then
  duckyo_backup_dir="$(mktemp -d "${duckyo_target_dir}.backup.$(date +%Y%m%d-%H%M%S).XXXXXX")"
  cp -Rp "$duckyo_target_dir/." "$duckyo_backup_dir/"
  printf 'Existing files backed up to: %s\n' "$duckyo_backup_dir"
fi

mkdir -p -- "$duckyo_target_dir"
for duckyo_file in pet.json spritesheet.webp; do
  cp "$duckyo_source_dir/$duckyo_file" "$duckyo_target_dir/$duckyo_file"
  chmod 644 "$duckyo_target_dir/$duckyo_file"
done

printf 'Installed Duckyo Scarf Codex pet to: %s\n' "$duckyo_target_dir"
printf 'Select Duckyo Scarf Codex pet in Codex to use it.\n'
