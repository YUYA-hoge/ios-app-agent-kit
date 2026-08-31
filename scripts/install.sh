#!/usr/bin/env bash

set -euo pipefail

usage() {
  printf '%s\n' "Usage: scripts/install.sh [--app-name NAME] [--dry-run] [--force] [TARGET]"
}

script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
kit_root=$(CDPATH= cd -- "$script_dir/.." && pwd)
template_root="$kit_root/templates/project"
target_dir="."
app_name=""
dry_run=false
force=false

while [ "$#" -gt 0 ]; do
  case "$1" in
    --app-name)
      [ "$#" -ge 2 ] || { usage >&2; exit 2; }
      app_name=$2
      shift 2
      ;;
    --dry-run)
      dry_run=true
      shift
      ;;
    --force)
      force=true
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    -* )
      printf 'Unknown option: %s\n' "$1" >&2
      usage >&2
      exit 2
      ;;
    *)
      target_dir=$1
      shift
      [ "$#" -eq 0 ] || { usage >&2; exit 2; }
      ;;
  esac
done

[ -d "$template_root" ] || { printf 'Template not found: %s\n' "$template_root" >&2; exit 1; }
mkdir -p "$target_dir"
target_dir=$(CDPATH= cd -- "$target_dir" && pwd)
[ -n "$app_name" ] || app_name=$(basename -- "$target_dir")

case "$app_name" in
  *$'\n'*|*'{{'*|*'}}'*)
    printf 'Invalid app name: %s\n' "$app_name" >&2
    exit 2
    ;;
esac

files_file=$(mktemp)
cleanup() { rm -f -- "$files_file"; }
trap cleanup EXIT HUP INT TERM
(cd "$template_root" && find . -type f -print | LC_ALL=C sort) > "$files_file"

conflicts=""
while IFS= read -r relative_path; do
  destination="$target_dir/${relative_path#./}"
  if [ -e "$destination" ]; then
    conflicts="${conflicts}${destination}\n"
  fi
done < "$files_file"

if [ -n "$conflicts" ] && [ "$force" != true ]; then
  printf 'Installation stopped because these files already exist:\n%b' "$conflicts" >&2
  printf '%s\n' 'Review them first, or rerun with --force to create backups and replace them.' >&2
  exit 3
fi

backup_root=""
if [ -n "$conflicts" ] && [ "$force" = true ]; then
  backup_root="$target_dir/.ios-app-agent-kit-backup/$(date +%Y%m%d-%H%M%S)"
fi

while IFS= read -r relative_path; do
  clean_path=${relative_path#./}
  source_path="$template_root/$clean_path"
  destination="$target_dir/$clean_path"

  if [ "$dry_run" = true ]; then
    printf 'Would install %s\n' "$clean_path"
    continue
  fi

  if [ -e "$destination" ] && [ -n "$backup_root" ]; then
    backup_path="$backup_root/$clean_path"
    mkdir -p "$(dirname -- "$backup_path")"
    cp -p -- "$destination" "$backup_path"
  fi

  mkdir -p "$(dirname -- "$destination")"
  escaped_app_name=$(printf '%s' "$app_name" | sed 's/[&|\\]/\\&/g')
  sed "s|{{APP_NAME}}|$escaped_app_name|g" "$source_path" > "$destination"
  if [ -x "$source_path" ]; then
    chmod +x "$destination"
  fi
  printf 'Installed %s\n' "$clean_path"
done < "$files_file"

if [ "$dry_run" = true ]; then
  printf 'Dry run complete for %s at %s.\n' "$app_name" "$target_dir"
else
  [ -z "$backup_root" ] || printf 'Backups saved to %s\n' "$backup_root"
  printf 'Installed iOS App Agent Kit for %s. Open this repository as a trusted Codex project in a new task.\n' "$app_name"
fi
