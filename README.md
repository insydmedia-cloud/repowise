# repowise

Repositório com a skill [repowise](https://github.com/partychen/repowise) instalada para o Claude Code.

- `.agents/skills/repowise/`: arquivos da skill
- `.claude/skills/repowise`: link simbólico para o Claude Code encontrar a skill
- `skills-lock.json`: origem e versão instalada

## Uso

Abra uma sessão do Claude Code com este repositório e peça, por exemplo:

> use o repowise para revisar o PR https://github.com/dono/repo/pull/123

Na primeira vez, rode a configuração (Python 3.11+, sem acesso à internet):

```bash
python -I .agents/skills/repowise/scripts/main.py setup
```

## Atualizar

```bash
npx skills add https://github.com/partychen/repowise --skill repowise -y
```
