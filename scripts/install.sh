#!/usr/bin/env bash
# Instala todas as skills de skills/ no diretório de skills do usuário do Claude Code.
# Uso: scripts/install.sh [--link] [destino]
#   --link   cria links simbólicos em vez de copiar (para quem mantém o clone e usa git pull)
#   destino  padrão: ~/.claude/skills
set -euo pipefail

mode=copy
if [[ "${1:-}" == "--link" ]]; then mode=link; shift; fi
repo="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
dest="${1:-${CLAUDE_SKILLS_DIR:-$HOME/.claude/skills}}"

mkdir -p "$dest"
count=0
for dir in "$repo"/skills/*/; do
  [[ -f "$dir/SKILL.md" ]] || continue
  name="$(basename "$dir")"
  rm -rf "${dest:?}/$name"
  if [[ "$mode" == link ]]; then
    ln -s "${dir%/}" "$dest/$name"
  else
    cp -R "${dir%/}" "$dest/$name"
  fi
  echo "instalada: $name -> $dest/$name"
  count=$((count + 1))
done
echo "$count skill(s) instalada(s) em $dest"
