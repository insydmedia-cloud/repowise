#!/usr/bin/env bash
# Adiciona (ou atualiza) skills de uma fonte externa nesta biblioteca.
# Uso: scripts/add-skill.sh <fonte> [skill...]
#   fonte  qualquer coisa aceita por `npx skills add` (ex.: https://github.com/dono/repo ou dono/repo)
#   skill  nomes das skills; sem nomes, adiciona todas as skills da fonte
# Depois: revisar o código, rodar scripts/build-zips.sh, commit e push.
set -euo pipefail

[[ $# -ge 1 ]] || { echo "uso: $0 <fonte> [skill...]" >&2; exit 2; }
source_ref="$1"; shift
repo="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
work="$(mktemp -d)"
trap 'rm -rf "$work"' EXIT

args=(add "$source_ref" -a claude-code --copy -y)
if [[ $# -gt 0 ]]; then
  for s in "$@"; do args+=(--skill "$s"); done
else
  args+=(--skill '*')
fi
(cd "$work" && npx -y skills "${args[@]}")

shopt -s nullglob
added=()
for dir in "$work"/.claude/skills/*/ "$work"/.agents/skills/*/; do
  name="$(basename "$dir")"
  [[ -f "$dir/SKILL.md" ]] || continue
  [[ " ${added[*]-} " == *" $name "* ]] && continue
  rm -rf "${repo:?}/skills/$name"
  cp -RL "${dir%/}" "$repo/skills/$name"
  ln -sfn "../../skills/$name" "$repo/.claude/skills/$name"
  added+=("$name")
  echo "adicionada: skills/$name"
done
[[ ${#added[@]} -gt 0 ]] || { echo "nenhuma skill encontrada em $source_ref" >&2; exit 1; }

# Junta as entradas de origem/versão no skills-lock.json da biblioteca.
if [[ -f "$work/skills-lock.json" ]]; then
  python3 -I - "$work/skills-lock.json" "$repo/skills-lock.json" <<'EOF'
import json, os, sys
new_path, lock_path = sys.argv[1], sys.argv[2]
lock = json.load(open(lock_path)) if os.path.exists(lock_path) else {"version": 1, "skills": {}}
for name, entry in json.load(open(new_path)).get("skills", {}).items():
    entry["installedAt"] = f"skills/{name}"
    lock["skills"][name] = entry
lock["skills"] = dict(sorted(lock["skills"].items()))
with open(lock_path, "w") as f:
    json.dump(lock, f, indent=2, ensure_ascii=False)
    f.write("\n")
EOF
fi
