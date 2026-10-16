#!/usr/bin/env bash
# Gera um ZIP por skill em dist/, no formato aceito pelo upload de skills do claude.ai
# (Configurações > Capacidades > Skills). Cada ZIP tem a pasta da skill na raiz.
# Uso: scripts/build-zips.sh [skill...]   (sem nomes, gera todas)
set -euo pipefail

repo="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
mkdir -p "$repo/dist"
names=("$@")
if [[ ${#names[@]} -eq 0 ]]; then
  for dir in "$repo"/skills/*/; do [[ -f "$dir/SKILL.md" ]] && names+=("$(basename "$dir")"); done
fi
for name in "${names[@]}"; do
  [[ -f "$repo/skills/$name/SKILL.md" ]] || { echo "skill não encontrada: $name" >&2; exit 1; }
  rm -f "$repo/dist/$name.zip"
  (cd "$repo/skills" && zip -qr "$repo/dist/$name.zip" "$name" -x '*/__pycache__/*' '*.pyc')
  echo "dist/$name.zip"
done
