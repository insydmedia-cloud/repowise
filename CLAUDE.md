# Biblioteca de skills da insydmedia

Este repositório é a biblioteca central de skills do usuário. Responda em português do Brasil.

## Quando o usuário pedir para adicionar ou atualizar uma skill

1. `scripts/add-skill.sh <fonte> [skill...]` (a fonte é o que `npx skills add` aceita).
2. Revise os arquivos novos antes de qualquer commit: scripts, chamadas de rede/subprocesso, binários e
   dependências. Skills rodam com permissões totais de agente; se algo parecer suspeito, pare e avise.
3. `scripts/build-zips.sh <skill>` e envie o ZIP ao usuário para o upload no claude.ai.
4. Atualize a tabela de skills do `README.md`, faça commit e push na `main`.

Nunca edite os arquivos de uma skill de terceiros à mão; para atualizar, rode `add-skill.sh` de novo.
`dist/` é gerado e não vai para o git.
