SET search_path TO ControleCampanhaRPG;

-- View 1: vw_personagens_ativos_com_credito
-- Lista personagens ativos (não sepultados) com suas informações de crédito e atributos.
CREATE OR REPLACE VIEW vw_personagens_ativos_com_credito AS
SELECT
    p.nome AS nome_personagem,
    p.ocupacao,
    p.idade,
    p.genero,
    nc.nivel AS nivel_credito,
    nc.classificacao AS classificacao_credito,
    nc.patrimonio,
    nc.dinheiro,
    a.forca,
    a.constituicao,
    a.tamanho,
    a.destreza,
    a.aparencia,
    a.inteligen,
    a.poder,
    a.educacao
FROM
    personagem p
LEFT JOIN
    nivelCredito nc ON p.nome = nc.nome_personagem
LEFT JOIN
    atributos a ON p.nome = a.nome_personagem
WHERE
    p.nome NOT IN (SELECT nome_personagem FROM sepultamento);




-- View 2: vw_historico_combates_locacoes
-- Detalha combates, NPCs envolvidos, personagens e locais.
CREATE OR REPLACE VIEW vw_historico_combates_locacoes AS
SELECT
    c.data_hora AS data_combate,
    l.nome AS nome_locacao,
    l.endereco AS endereco_locacao,
    e.nome_npc,
    n.inclinacao AS inclinacao_npc,
    e.nome_persona AS nome_personagem_envolvido
FROM
    combate c
JOIN
    acontecimento ac ON c.data_hora = ac.data_hora_comb
JOIN
    locacao l ON ac.nome_loca = l.nome
LEFT JOIN
    enfrentamento e ON c.data_hora = e.data_hora_comb
LEFT JOIN
    npc n ON e.nome_npc = n.nome
ORDER BY
    c.data_hora DESC;


