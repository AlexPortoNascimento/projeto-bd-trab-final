SET search_path TO ControleCampanhaRPG;

--Função 1
--Define a classe social do personagem passado no parâmetro baseado no dinheiro + patrimônio.
--Faz uama querry que seleciona o patrimonio + dinheiro da tabela nível de crédito e faz comparações baseados em valores encontrados no livro de regras de Chamado de Cthulhu RPG.
CREATE OR REPLACE FUNCTION define_classe_social(personagem_nome VARCHAR)
RETURNS VARCHAR AS $$
DECLARE
    total NUMERIC;
BEGIN
    SELECT patrimonio + dinheiro
    INTO total
    FROM nivelCredito
    WHERE nome_personagem = personagem_nome;

    IF total IS NULL THEN
        RETURN 'Personagem não encontrado';
    ELSIF total < 1000 THEN
        RETURN 'Pobre';
    ELSIF total < 5000 THEN
        RETURN 'Classe Média';
    ELSIF total < 10000 THEN
        RETURN 'Rico';
    ELSE
        RETURN 'Milionário';
    END IF;
END;
$$ LANGUAGE plpgsql;

--Exemplo de chamada da função 1

SELECT define_classe_social('Claire');


--Função 2
--Criar um tabela que mostra as magias poderosas de um personagem escolhido.
--Recebe como parâmetros o nome do personagem e o nível mínimo desejado de magia. Retorna uma tabela baseada na query onde ocorrem junções das tabelas item, livro, livroPossuiMagia e magia.

CREATE OR REPLACE FUNCTION listar_magias_poderosas_por_personagem(
    personagem_nome VARCHAR,
    custo_minimo INTEGER
)
RETURNS TABLE (
    nome_magia VARCHAR,
    descricao TEXT,
    custo INTEGER,
    nome_livro VARCHAR
) AS $$
BEGIN
    RETURN QUERY
    SELECT
        magia.nome AS nome_magia,
        magia.descricao,
        magia.custo,
        livro.nome AS nome_livro
    FROM
        personagem
    JOIN item ON personagem.nome = item.nome_persona
    JOIN livro ON livro.nome = item.nome
    JOIN livroPossuiMagia ON livroPossuiMagia.nome_item = livro.nome
    JOIN magia ON livroPossuiMagia.nome_magia = magia.nome
    WHERE
        personagem.nome = personagem_nome
        AND magia.custo >= custo_minimo
    ORDER BY
        magia.custo DESC;
END;
$$ LANGUAGE plpgsql;

--Exemplo de chamada da função 2

SELECT * FROM listar_magias_poderosas_por_personagem('Claire', 10);


--Função 3
--Função que retorna verdadeiro se um jogador participou de uma sessão ou false caso contrário.
--Usa uma query q busca um único valor se os parametros correspondem ao numero da sessao e ao cpf do jogador. Retorna um booleano.

CREATE OR REPLACE FUNCTION jogador_participou(cpf_jogador_selecionado VARCHAR, sessao_num INTEGER)
RETURNS BOOLEAN AS $$
DECLARE
    participou BOOLEAN;
BEGIN
    SELECT EXISTS (
        SELECT 1
        FROM participacao
        WHERE cpf_jogador = cpf_jogador_selecionado
          AND num_sessao = sessao_num
    ) INTO participou;

    RETURN participou;
END;
$$ LANGUAGE plpgsql;

--Exemplo de chamada da Função 3

SELECT jogador_participou('Claire', 1);

--Função 4
--Função que mostra a quantidade de vezes que um NPC entrou em combate com personagens.
--Faz uma query que conta a quantidade de entradas da tabela enfrentamento ondo o parametro corresponde ao nome do npc e retorna esse valor.

CREATE OR REPLACE FUNCTION numero_combates_npc(npc_nome VARCHAR)
RETURNS INTEGER AS $$
DECLARE
    total_combates INTEGER;
BEGIN
    SELECT COUNT(*)
    INTO total_combates
    FROM enfrentamento
    WHERE nome_npc = npc_nome;

    RETURN total_combates;
END;
$$ LANGUAGE plpgsql;

--Exemplo de chamada função 4

SELECT numero_combates_npc('Nyerlathotep');


--Função 5
--Função que mostra se o personagem está vivo ou não. 
--Ela verifica se o personagem está na tabela sepultamento e retorna true ou false.

CREATE OR REPLACE FUNCTION esta_vivo(personagem_nome VARCHAR)
RETURNS BOOLEAN AS $$
DECLARE
    morto BOOLEAN;
BEGIN
    SELECT EXISTS (
        SELECT 1 FROM sepultamento
        WHERE nome_personagem = personagem_nome
    ) INTO morto;

    IF morto THEN
        RETURN FALSE;
    ELSE
        RETURN TRUE;
    END IF;
END;
$$ LANGUAGE plpgsql;

--Exemplo de chamada da função 5
SELECT esta_vivo('Tonho');