CREATE SCHEMA ControleCampanhaRPG;
SET search_path TO ControleCampanhaRPG;
SHOW search_path;

CREATE TABLE jogador (
    cpf VARCHAR(11) PRIMARY KEY,
    nome VARCHAR(100) NOT NULL
);

CREATE TABLE personagem (
    nome VARCHAR(100) PRIMARY KEY,
    ocupacao VARCHAR(50) NOT NULL,
    idade INTEGER NOT NULL,
    genero VARCHAR(20) NOT NULL,
    residencia VARCHAR(50) NOT NULL,
    local_nasc VARCHAR(50) NOT NULL,
    pv INT NOT NULL,
    sanidade INT NOT NULL CHECK (sanidade BETWEEN 0 AND 100),
    cpf_jogador VARCHAR(11) NOT NULL,
    FOREIGN KEY (cpf_jogador) REFERENCES jogador(cpf)
);

CREATE TABLE pilarSanidade (
    nome_personagem VARCHAR(100) NOT NULL,
    nome VARCHAR(100) NOT NULL,
    tipo VARCHAR(50) NOT NULL,
    condicao VARCHAR(50) NOT NULL,
    
    PRIMARY KEY (nome_personagem, nome),
    FOREIGN KEY (nome_personagem) REFERENCES personagem(nome)
);

CREATE TABLE nivelCredito (
    nome_personagem VARCHAR(100) NOT NULL,
    nivel INTEGER NOT NULL CHECK (nivel BETWEEN 0 AND 100),
    patrimonio DECIMAL(10,2),
    dinheiro DECIMAL(6,2),
    niv_gasto DECIMAL(6,2),
    classificacao VARCHAR(25),

    PRIMARY KEY (nome_personagem),
    FOREIGN KEY (nome_personagem) REFERENCES personagem(nome)
);

CREATE TABLE atributos (
    nome_personagem VARCHAR(100) PRIMARY KEY,
    forca INTEGER NOT NULL CHECK (forca BETWEEN 0 AND 100),
    constituicao INTEGER NOT NULL CHECK (constituicao BETWEEN 0 AND 100),
    tamanho INTEGER NOT NULL CHECK (tamanho BETWEEN 0 AND 100),
    destreza INTEGER NOT NULL CHECK (destreza BETWEEN 0 AND 100),
    aparencia INTEGER NOT NULL CHECK (aparencia BETWEEN 0 AND 100),
    inteligen INTEGER NOT NULL CHECK (inteligen BETWEEN 0 AND 100),
    poder INTEGER NOT NULL CHECK (poder BETWEEN 0 AND 100),
    educacao INTEGER NOT NULL CHECK (educacao BETWEEN 0 AND 100),

    FOREIGN KEY (nome_personagem) REFERENCES personagem(nome)
);

CREATE TABLE cemiterio (
    nome VARCHAR(100) PRIMARY KEY
);

CREATE TABLE sessao (
    numero INTEGER PRIMARY KEY,
    data DATE NOT NULL
);

CREATE TABLE sepultamento (
    nome_personagem VARCHAR(100) NOT NULL,
    nome_cemiterio VARCHAR(100) NOT NULL,
    num_sessao INTEGER NOT NULL,
    causa_morte TEXT,

    PRIMARY KEY (nome_personagem),
    FOREIGN KEY (nome_personagem) REFERENCES personagem(nome),
    FOREIGN KEY (nome_cemiterio) REFERENCES cemiterio(nome),
    FOREIGN KEY (num_sessao) REFERENCES sessao(numero)
);

CREATE TABLE participacao (
    cpf_jogador VARCHAR(11) NOT NULL,
    num_sessao INTEGER NOT NULL,

    PRIMARY KEY (cpf_jogador, num_sessao),
    FOREIGN KEY (cpf_jogador) REFERENCES jogador(cpf),
    FOREIGN KEY (num_sessao) REFERENCES sessao(numero)
);

CREATE TABLE combate (
    data_hora TIMESTAMP PRIMARY KEY
);

CREATE TABLE locacao (
    nome VARCHAR(100) PRIMARY KEY,
    endereco VARCHAR(200),
    tipo VARCHAR(100)
);

CREATE TABLE acontecimento (
    data_hora_comb TIMESTAMP NOT NULL,
    nome_loca VARCHAR(100) NOT NULL,

    PRIMARY KEY (data_hora_comb, nome_loca),
    FOREIGN KEY (data_hora_comb) REFERENCES combate(data_hora),
    FOREIGN KEY (nome_loca) REFERENCES locacao(nome)
);

CREATE TABLE npc (
    nome VARCHAR(100) PRIMARY KEY,
    idade INT CHECK(idade > 0),
    inclinacao VARCHAR(25) CHECK (inclinacao IN ('aliado', 'inimigo')),
    caracteristicas TEXT
);

CREATE TABLE enfrentamento (
    data_hora_comb TIMESTAMP NOT NULL,
    nome_npc VARCHAR(100) NOT NULL,
    nome_persona VARCHAR(100) NOT NULL,

    PRIMARY KEY (data_hora_comb, nome_npc, nome_persona),
    FOREIGN KEY (data_hora_comb) REFERENCES combate(data_hora),
    FOREIGN KEY (nome_npc) REFERENCES npc(nome),
    FOREIGN KEY (nome_persona) REFERENCES personagem(nome)
);

CREATE TABLE grupo (
    nome VARCHAR(100) PRIMARY KEY,
    tendencia VARCHAR(100) CHECK (tendencia IN ('aliado', 'inimigo', 'neutro'))
);

CREATE TABLE encontra_se (
    nome_npc VARCHAR(100) NOT NULL,
    nome_grupo VARCHAR(100) NOT NULL,
    nome_locacao VARCHAR(100) NOT NULL,

    PRIMARY KEY (nome_npc, nome_grupo, nome_locacao),
    FOREIGN KEY (nome_npc) REFERENCES npc(nome),
    FOREIGN KEY (nome_grupo) REFERENCES grupo(nome),
    FOREIGN KEY (nome_locacao) REFERENCES locacao(nome)
);

CREATE TABLE magia (
    nome VARCHAR(100) PRIMARY KEY,
    temp_conj INTEGER NOT NULL,
    descricao TEXT,
    custo INTEGER CHECK (custo >= 0)
);

CREATE TABLE item (
    nome VARCHAR(100) PRIMARY KEY,
    nome_locacao VARCHAR(100),
    nome_persona VARCHAR(100),
    CHECK (
    (nome_locacao IS NOT NULL AND nome_persona IS NULL)
    OR (nome_locacao IS NULL AND nome_persona IS NOT NULL)
    ),

    FOREIGN KEY (nome_locacao) REFERENCES locacao(nome),
    FOREIGN KEY (nome_persona) REFERENCES personagem(nome)
);

CREATE TABLE livro (
    nome VARCHAR(100) PRIMARY KEY,
    tempo_estudo_semanas INTEGER CHECK (tempo_estudo_semanas > 0),
    mythos INTEGER CHECK (mythos >= 0),
    perda_san INTEGER CHECK (perda_san >=0),

    FOREIGN KEY (nome) REFERENCES item(nome)
);

CREATE TABLE artefato (
    nome VARCHAR(100) PRIMARY KEY,
    usado_por VARCHAR(100),
    descricao TEXT,

    FOREIGN KEY (nome) REFERENCES item(nome)
);

CREATE TABLE arma (
    nome VARCHAR(100) PRIMARY KEY,
    tipo VARCHAR(50),
    defeito INTEGER CHECK (defeito >= 95 AND defeito <= 100),
    tam_pente INTEGER CHECK (tam_pente >= 0),
    dano VARCHAR(50),
    id SERIAL,

    FOREIGN KEY (nome) REFERENCES item(nome)
);


CREATE TABLE documento (
    nome VARCHAR(100) PRIMARY KEY,
    tipo VARCHAR(50),
    codigo VARCHAR(50),

    FOREIGN KEY (nome) REFERENCES item(nome)
);

CREATE TABLE livroPossuiMagia (
    nome_item VARCHAR(100) NOT NULL,
    nome_magia VARCHAR(100) NOT NULL,

    PRIMARY KEY (nome_item, nome_magia),
    FOREIGN KEY (nome_item) REFERENCES item(nome),
    FOREIGN KEY (nome_magia) REFERENCES magia(nome)
);