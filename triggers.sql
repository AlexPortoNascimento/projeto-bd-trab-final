SET search_path TO ControleCampanhaRPG;

-- Trigger 1: trg_personagem_sanidade_zero
-- Ao atualizar a sanidade de um personagem para 0, inserir um registro na tabela sepultamento.
CREATE OR REPLACE FUNCTION inserir_sepultamento_sanidade_zero()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.sanidade = 0 AND OLD.sanidade > 0 THEN
        INSERT INTO sepultamento (nome_personagem, nome_cemiterio, num_sessao, causa_morte)
        VALUES (NEW.nome, 'Cemitério da Consolação', (SELECT MAX(numero) FROM sessao), 'Morte por perda total de sanidade');
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
-- Ao inserir ou atualizar o nivelCredito de um personagem, recalcular a classificacao com base no nivel.
CREATE OR REPLACE FUNCTION atualizar_classificacao_credito()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.nivel >= 80 THEN
        NEW.classificacao := 'Classe A';
    ELSIF NEW.nivel >= 60 THEN
        NEW.classificacao := 'Classe B';
    ELSIF NEW.nivel >= 40 THEN
        NEW.classificacao := 'Classe C';
    ELSIF NEW.nivel >= 20 THEN
        NEW.classificacao := 'Classe D';
    ELSE
        NEW.classificacao := 'Classe E';
    END IF;
    RETURN NEW;
END;
$$
LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER trg_atualiza_classificacao_credito
BEFORE INSERT OR UPDATE OF nivel ON nivelCredito
FOR EACH ROW
EXECUTE FUNCTION atualizar_classificacao_credito();


