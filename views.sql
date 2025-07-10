SET search_path TO ControleCampanhaRPG;

-- View 1: vw_personagens_ativos_com_credito_detalhado
-- Propósito: Fornece uma visão detalhada e enriquecida dos personagens ativos, combinando informações de várias tabelas.
-- Funcionalidade Aprimorada: Esta view inclui informações do jogador, status de sanidade, nível de crédito, atributos e, 
-- mais importante, calcula a média dos atributos de cada personagem, fornecendo uma métrica de seu poder geral.
CREATE OR REPLACE VIEW vw_personagens_ativos_com_credito_detalhado AS
SELECT
    p.nome AS nome_personagem,
    p.ocupacao,
    p.idade,
    p.genero,
    j.nome AS nome_jogador,
    p.pv AS pontos_de_vida,
    p.sanidade,
    CASE
        WHEN p.sanidade > 80 THEN 'Estável'
        WHEN p.sanidade > 50 THEN 'Ansioso'
        WHEN p.sanidade > 20 THEN 'Instável'
        ELSE 'Crítico'
    END AS status_sanidade,
    nc.nivel AS nivel_credito,
    nc.classificacao AS classificacao_credito,
    nc.patrimonio,
    a.forca, a.constituicao, a.tamanho, a.destreza, a.aparencia, a.inteligen, a.poder, a.educacao,
    -- Cálculo da média dos atributos para uma visão geral do poder do personagem
    ROUND((a.forca + a.constituicao + a.tamanho + a.destreza + a.aparencia + a.inteligen + a.poder + a.educacao) / 8.0, 2) AS media_atributos
FROM
    personagem p
JOIN
    jogador j ON p.cpf_jogador = j.cpf
LEFT JOIN
    nivelCredito nc ON p.nome = nc.nome_personagem
LEFT JOIN
    atributos a ON p.nome = a.nome_personagem
WHERE
    p.nome NOT IN (SELECT nome_personagem FROM sepultamento);





-- View 2: vw_historico_combates_detalhado
-- Propósito: Oferece uma visão completa dos combates, detalhando todos os participantes (personagens e NPCs), a localização e o resultado.
-- Funcionalidade Aprimorada: A view agora inclui informações sobre os grupos aos quais os NPCs pertencem e os jogadores que controlam os personagens envolvidos.
-- Também adiciona uma coluna para indicar o tipo de participante (Personagem ou NPC), tornando a análise de combates mais rica.
CREATE OR REPLACE VIEW vw_historico_combates_detalhado AS
SELECT
    c.data_hora AS data_combate,
    l.nome AS nome_locacao,
    l.tipo AS tipo_locacao,
    -- Detalhes do personagem envolvido
    p.nome AS nome_personagem,
    p.ocupacao AS ocupacao_personagem,
    j.nome AS nome_jogador,
    -- Detalhes do NPC envolvido
    n.nome AS nome_npc,
    n.inclinacao AS inclinacao_npc,
    g.nome AS nome_grupo_npc,
    g.tendencia AS tendencia_grupo_npc,
    -- Coluna para identificar o tipo de participante
    CASE
        WHEN p.nome IS NOT NULL THEN 'Personagem'
        WHEN n.nome IS NOT NULL THEN 'NPC'
    END AS tipo_participante
FROM
    combate c
JOIN
    acontecimento ac ON c.data_hora = ac.data_hora_comb
JOIN
    locacao l ON ac.nome_loca = l.nome
LEFT JOIN
    enfrentamento e ON c.data_hora = e.data_hora_comb
LEFT JOIN
    personagem p ON e.nome_persona = p.nome
LEFT JOIN
    jogador j ON p.cpf_jogador = j.cpf
LEFT JOIN
    npc n ON e.nome_npc = n.nome
LEFT JOIN
    encontra_se es ON n.nome = es.nome_npc AND l.nome = es.nome_locacao
LEFT JOIN
    grupo g ON es.nome_grupo = g.nome
ORDER BY
    c.data_hora DESC, tipo_participante;

