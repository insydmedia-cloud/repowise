# insydmedia-skills

Biblioteca central de skills do Claude. Toda skill nova entra em `skills/` e fica disponível nos mesmos lugares:
Claude Code no seu computador, sessões do Claude Code na nuvem e conversas/Projetos do claude.ai.

| Skill | Origem | O que faz |
| --- | --- | --- |
| `repowise` | [partychen/repowise](https://github.com/partychen/repowise) | Aprende com os PRs de um projeto, revisa PRs e ajuda a implementar features seguindo as convenções do repositório. |

## Onde instalar

### 1. Claude Code no seu computador

Pelo marketplace de plugins (atualiza junto com este repositório):

```
/plugin install insydmedia-skills --marketplace insydmedia-cloud/repowise
```

Ou, sem plugin, copiando as skills para `~/.claude/skills`:

```bash
git clone https://github.com/insydmedia-cloud/repowise ~/claude-skills
bash ~/claude-skills/scripts/install.sh --link   # com --link, um `git pull` já atualiza tudo
```

### 2. Claude Code na nuvem (claude.ai/code)

No menu do ambiente (barra de título da sessão) → **Editar** → **Setup script**, adicione:

```bash
git clone --depth 1 https://github.com/insydmedia-cloud/repowise /opt/claude-skills \
  && bash /opt/claude-skills/scripts/install.sh || true
```

Toda sessão nova desse ambiente já começa com todas as skills, em qualquer repositório.
Se você usa um ambiente por cliente, repita em cada um.

### 3. Conversas e Projetos do claude.ai

1. Gere os ZIPs: `bash scripts/build-zips.sh` (ficam em `dist/`).
2. No claude.ai: **Configurações → Capacidades → Skills → Enviar skill** e escolha `dist/<skill>.zip`.

A skill passa a valer em todas as conversas e Projetos da conta. Observação: no chat do claude.ai, as skills rodam
num ambiente sem `git`/`gh` conectados ao GitHub, então funções que leem PRs (como as da repowise) funcionam de
verdade no Claude Code.

## Adicionar uma skill nova

```bash
scripts/add-skill.sh https://github.com/dono/repo nome-da-skill   # sem nome, traz todas da fonte
scripts/build-zips.sh nome-da-skill
git add -A && git commit -m "Adiciona a skill nome-da-skill" && git push
```

Depois: plugin local → `/plugin marketplace update insydmedia-skills`; nuvem → automático na próxima sessão;
claude.ai → enviar o ZIP novo.

## Estrutura

- `skills/<nome>/` — cada skill completa (`SKILL.md` + arquivos)
- `.claude-plugin/` — manifesto do plugin e do marketplace
- `.claude/skills/<nome>` — links para as sessões abertas neste próprio repositório
- `skills-lock.json` — origem e hash de cada skill
- `scripts/` — `install.sh`, `add-skill.sh`, `build-zips.sh`
