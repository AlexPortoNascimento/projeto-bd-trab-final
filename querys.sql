SHOW search_path;

SELECT table_name
FROM information_schema.tables
WHERE table_schema = 'controlecampanharpg';


--Consulta 1
--Listar todas as magias que estão atualmente em posse dos personagens, junto com seus livros associados.

SELECT
    personagem.nome AS personagem,
    item.nome AS livro,
    magia.nome AS magia,
    magia.descricao,
    magia.custo
FROM
    livroPossuiMagia
JOIN item ON livroPossuiMagia.nome_item = item.nome
JOIN personagem ON item.nome_persona = personagem.nome
JOIN magia ON livroPossuiMagia.nome_magia = magia.nome
WHERE
    item.nome_persona IS NOT NULL;

--Consulta 2
--Listar todas as magias e os livros onde elas podem ser encontradas.

SELECT
    magia.nome AS magia,
    magia.descricao,
    livro.nome AS livro,
    livro.tempo_estudo_semanas,
    livro.mythos,
    livro.perda_san
FROM
    livroPossuiMagia
JOIN magia ON livroPossuiMagia.nome_magia = magia.nome
JOIN livro ON livroPossuiMagia.nome_item = livro.nome;



--Consulta 3
--Listar todos os NPCs enfrentados em cada combate, além da data, o nome do persongagem engajado e a locação do combate. 

SELECT
    combate.data_hora AS data_combate,
    locacao.nome AS local,
    personagem.nome AS personagem,
    npc.nome AS npc,
    npc.inclinacao,
    npc.caracteristicas
FROM
    enfrentamento
JOIN combate ON enfrentamento.data_hora_comb = combate.data_hora
JOIN personagem ON enfrentamento.nome_persona = personagem.nome
JOIN npc ON enfrentamento.nome_npc = npc.nome
JOIN acontecimento ON enfrentamento.data_hora_comb = acontecimento.data_hora_comb
JOIN locacao ON acontecimento.nome_loca = locacao.nome
ORDER BY combate.data_hora;

--Consulta 4
--Listar todos os personagens que participaram da sessão número 1, com o nome do jogador responsável.

SELECT
    personagem.nome AS personagem,
    jogador.nome AS jogador
FROM
    participacao
JOIN jogador ON participacao.cpf_jogador = jogador.cpf
JOIN personagem ON personagem.cpf_jogador = jogador.cpf
WHERE
    participacao.num_sessao = 1;


--Consulta 5
--Listar todos os livros que ainda não foram encontrado por algum personagem, com nome e local onde estão.

SELECT
    item.nome AS livro,
    locacao.nome AS local,
    locacao.endereco
FROM
    item
JOIN locacao ON item.nome_locacao = locacao.nome
JOIN livro ON item.nome = livro.nome
WHERE
    item.nome_persona IS NULL;

--Consulta 6
--Listar todos os NPCs que pertencem a um grupo inimigo e onde eles estão localizados.

SELECT
    npc.nome AS nome_npc,
    grupo.nome AS nome_grupo,
    locacao.nome AS local,
    locacao.endereco
FROM
    encontra_se
JOIN npc ON encontra_se.nome_npc = npc.nome
JOIN grupo ON encontra_se.nome_grupo = grupo.nome
JOIN locacao ON encontra_se.nome_locacao = locacao.nome
WHERE
    grupo.tendencia = 'inimigo';

--Consulta 7
--Listar todos os personagens que morreram, com nome do cemitério, número da sessão e causa da morte.

SELECT
    personagem.nome AS personagem,
    sepultamento.nome_cemiterio,
    sepultamento.num_sessao,
    sepultamento.causa_morte
FROM
    sepultamento
JOIN personagem ON sepultamento.nome_personagem = personagem.nome;

--Consulta 8
--Listar todos os personagens e ordená-los de acordo com nível de crédito.

SELECT
    personagem.nome,
    nivelCredito.nivel,
    nivelCredito.classificacao,
    nivelCredito.patrimonio,
    nivelCredito.dinheiro
FROM
    personagem
JOIN nivelCredito ON personagem.nome = nivelCredito.nome_personagem
ORDER BY
    nivelCredito.nivel DESC;

--Consulta 9
--Mostrar todos os combates que ocorreram em "Museu do Cairo" e seus NPC envolvidos.

SELECT
    combate.data_hora,
    npc.nome AS npc_envolvido
FROM
    combate
JOIN enfrentamento ON combate.data_hora = enfrentamento.data_hora_comb
JOIN npc ON enfrentamento.nome_npc = npc.nome
JOIN acontecimento ON combate.data_hora = acontecimento.data_hora_comb
WHERE
    acontecimento.nome_loca = 'Museu do Cairo'
ORDER BY
    combate.data_hora;

--Consulta 10
--Listar personagens que possuem livros contendo magias cujo custo de conjuração é maior que 10, com detalhes das magias e livros.

SELECT DISTINCT
    personagem.nome AS personagem,
    livro.nome AS livro,
    magia.nome AS magia,
    magia.custo,
    magia.descricao
FROM
    personagem
JOIN item ON personagem.nome = item.nome_persona
JOIN livro ON item.nome = livro.nome
JOIN livroPossuiMagia ON livro.nome = livroPossuiMagia.nome_item
JOIN magia ON livroPossuiMagia.nome_magia = magia.nome
WHERE
    magia.custo > 10
ORDER BY
    personagem.nome, magia.custo DESC;


--Índices Significativos

--Para facilitar os JOINs envolvendo jogador e personagem
CREATE INDEX idx_personagem_cpf_jogador ON personagem(cpf_jogador);

--Para facilitar a busca do nível de crédito de personagens
CREATE INDEX idx_nivel_credito_nome_personagem ON nivelCredito(nome_personagem);

--Para facilitar a busca por participações dos jogadores em sessões
CREATE INDEX idx_participacao_cpf_sessao ON participacao(cpf_jogador, num_sessao);

--Para facilitar a busca por locações
CREATE INDEX idx_locacao_nome ON locacao(nome);

--Para facilitar buscar itens por persongens.
CREATE INDEX idx_item_nome_persona ON item(nome_persona);
