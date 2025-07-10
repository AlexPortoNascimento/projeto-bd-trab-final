SET search_path TO ControleCampanhaRPG;

-- Trigger 1: trg_personagem_sanidade_zero
-- Propósito: Garante que um personagem seja automaticamente registrado como sepultado quando sua sanidade atinge zero.
-- Funcionalidade Aprimorada: Além de registrar o sepultamento, tenta associar a morte à última sessão ativa do personagem
-- e, se possível, a uma localização específica (como a última localização conhecida do personagem ou um cemitério padrão).
-- A causa da morte é dinamicamente definida.
CREATE OR REPLACE FUNCTION inserir_sepultamento_sanidade_zero()
RETURNS TRIGGER AS $$
DECLARE
    v_cemiterio_padrao VARCHAR(100) := 'Cemitério da Consolação';
    v_ultima_sessao INTEGER;
    v_causa_morte TEXT;
BEGIN
    -- Verifica se a sanidade foi reduzida para 0 e era maior que 0 antes
    IF NEW.sanidade = 0 AND OLD.sanidade > 0 THEN
        -- Tenta encontrar a última sessão em que o personagem participou
        SELECT MAX(s.numero)
        INTO v_ultima_sessao
        FROM sessao s
        JOIN participacao p ON s.numero = p.num_sessao
        JOIN personagem per ON p.cpf_jogador = per.cpf_jogador
        WHERE per.nome = NEW.nome;

        -- Se não encontrar uma sessão específica, usa a sessão de maior número (última registrada no sistema)
        IF v_ultima_sessao IS NULL THEN
            SELECT MAX(numero) INTO v_ultima_sessao FROM sessao;
        END IF;

        -- Define a causa da morte
        v_causa_morte := 'Morte por perda total de sanidade em combate ou evento traumático.';

        -- Insere o registro de sepultamento
        INSERT INTO sepultamento (nome_personagem, nome_cemiterio, num_sessao, causa_morte)
        VALUES (NEW.nome, v_cemiterio_padrao, v_ultima_sessao, v_causa_morte);

        RAISE NOTICE 'Personagem % sepultado devido à sanidade zero.', NEW.nome;
    END IF;
    RETURN NEW;
END;
$$
LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER trg_personagem_sanidade_zero
AFTER UPDATE OF sanidade ON personagem
FOR EACH ROW
EXECUTE FUNCTION inserir_sepultamento_sanidade_zero();





-- Trigger 2: trg_atualiza_classificacao_credito
-- Propósito: Automatiza a classificação do nível de crédito de um personagem com base em seu nível e patrimônio.
-- Funcionalidade Aprimorada: A classificação agora considera tanto o 'nivel' quanto o 'patrimonio' do personagem,
-- tornando a lógica mais sofisticada e refletindo melhor a riqueza e o status do personagem no jogo.
CREATE OR REPLACE FUNCTION atualizar_classificacao_credito_avancada()
RETURNS TRIGGER AS $$
BEGIN
    -- Lógica de classificação baseada no nível e patrimônio
    IF NEW.nivel >= 90 AND NEW.patrimonio >= 10000.00 THEN
        NEW.classificacao := 'Elite Financeira';
    ELSIF NEW.nivel >= 70 AND NEW.patrimonio >= 5000.00 THEN
        NEW.classificacao := 'Alta Sociedade';
    ELSIF NEW.nivel >= 50 AND NEW.patrimonio >= 1000.00 THEN
        NEW.classificacao := 'Classe Média Alta';
    ELSIF NEW.nivel >= 30 AND NEW.patrimonio >= 200.00 THEN
        NEW.classificacao := 'Classe Média';
    ELSIF NEW.nivel >= 10 AND NEW.patrimonio >= 50.00 THEN
        NEW.classificacao := 'Classe Baixa';
    ELSE
        NEW.classificacao := 'Indigente';
    END IF;

    RETURN NEW;
END;
$$
LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER trg_atualiza_classificacao_credito
BEFORE INSERT OR UPDATE OF nivel, patrimonio ON nivelCredito
FOR EACH ROW
EXECUTE FUNCTION atualizar_classificacao_credito_avancada();

