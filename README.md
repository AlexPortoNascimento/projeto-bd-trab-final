# Sistema de Controle de Campanha de RPG

Este projeto é um banco de dados relacional completo desenvolvido em PostgreSQL. Foi criado com o objetivo de realizar o trabalho final da disciplina TCC00335 - Projeto de Banco de Dados, do curso de Bacharelado Sistemas de Informação da Universidade Federal Fluminense - UFF, com tema livre.

O tema escolhido foi "Controle de Campanha de RPG", inspirado pela campanha Máscaras de Nyerlathotep do sistema de regras Chamado de Cthulhu - 7ª edição.

---

## Objetivos

- Gerenciar personagens, jogadores, sessões e combates.
- Registrar itens especiais, magias, livros e artefatos encontrados.
- Controlar o nível de sanidade e o status de vida dos personagens.
- Automatizar ações críticas por meio de **triggers** e **funções**.
- Gerar **consultas** e **views** ricas para apoio ao Guardião (narrador da campanha).

---

## 🧩 Estrutura do Banco

O banco utiliza o schema `ControleCampanhaRPG`, contendo as seguintes principais entidades:

- **Jogador**, **Personagem**, **Atributos**, **Sanidade**, **Nível de Crédito**
- **Sessão**, **Participação**, **Combate**, **Enfrentamento**
- **Locação**, **NPC**, **Grupo/Fação**
- **Item**, com especializações como `Livro`, `Artefato`, `Arma`, `Documento`
- **Magias** e associação entre livros e magias (`livroPossuiMagia`)
- **Sepultamento** e **Cemitério**

---

## ⚙️ Recursos Avançados

### 🔁 Triggers

- **`trg_personagem_sanidade_zero`**  
  Insere automaticamente um sepultamento quando a sanidade de um personagem cai a 0.

- **`trg_atualiza_classificacao_credito`**  
  Atualiza a classificação de crédito com base no nível e patrimônio.

### 🔎 Views

- **`vw_personagens_ativos_com_credito_detalhado`**  
  Lista os personagens vivos com todos os atributos, status de sanidade e média dos atributos.

- **`vw_historico_combates_detalhado`**  
  Mostra todos os combates com NPCs, personagens, local, grupo envolvido e tipo de participante.

### 🧠 Funções

- `define_classe_social(nivel, patrimonio)`  
  Retorna a classificação econômica do personagem.

- `esta_vivo(personagem_nome)`  
  Retorna TRUE se o personagem não está sepultado.

- `listar_magias_poderosas_por_personagem(personagem_nome, custo_minimo)`  
  Lista magias poderosas que o personagem pode acessar através de livros.

- `jogador_participou(cpf_jogador_selecionado, sessao_num)`
  Retorna TRUE se o jogador participou da sessão selecionada.

- `numero_combates_npc(npc_nome)`
  Retorna o número de combates de que determinado NPC participou.
---

## 📊 Exemplos de Consultas

- Listar todos os personagens com sanidade crítica.
- Ver histórico de combates envolvendo um determinado grupo de NPCs.
- Verificar se um personagem possui acesso a uma magia específica.

---

## 🚀 Como Usar

1. Clone este repositório
2. Configure um banco PostgreSQL com o schema `ControleCampanhaRPG`
3. Execute os scripts SQL fornecidos na pasta `/scripts`:
   - `create_tables.sql`
   - `create_triggers.sql`
   - `insert_data.sql`
   - `create_views.sql`
   - `functions.sql`
4. Explore os dados via PGAdmin, DBeaver ou psql

---

## Autores

Este projeto foi desenvolvido por Alexandre Nascimento, Matheus Sena e Lucas Sodré com apoio de ferramentas como ChatGPT para automação de partes da geração de código e documentação. A modelagem foi feita inteiramente a mão.

---

## Licença

Este projeto é open source e pode ser usado livremente para fins educacionais e não comerciais.
