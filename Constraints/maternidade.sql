CREATE  DATABASE   maternidade

GO

USE maternidade

GO

CREATE  TABlE   mae(
    id                      INT             NOT NULL,
    nome                    VARCHAR(60)     NOT NULL,
    logradouro_endereco     VARCHAR(100)    NOT NULL,
    cep_endereco            CHAR(8)         NOT NULL,
    complemento_endereco    CHAR(200)       NOT NULL,
    telefone                CHAR(10)        NOT NULL,
    data_nascimento         DATE            NOT NULL,

    PRIMARY KEY (id)
)

CREATE  TABLE   medico(
    crm_numero              INT             NOT NULL,
    crm_uf                  CHAR(2)         NOT NULL,
    nome                    VARCHAR(60)     NOT NULL,
    telefone_celular        CHAR(11)        NOT NULL,
    especialidade           VARCHAR(30)     NOT NULL,

    PRIMARY KEY (crm_numero,crm_uf)
)

GO

CREATE  TABLE   bebe(
    id                      INT             NOT NULL,
    nome                    VARCHAR(60)     NOT NULL,
    data_nasc               DATE            NOT NULL,
    altura                  DECIMAL(7,2)    NOT NULL,
    peso                    DECIMAL(4,3)    NOT NULL,
    id_mae                  INT             NOT NULL,

    PRIMARY KEY (id),
    FOREIGN KEY (id_mae)    REFERENCES  mae(id)
)

GO

CREATE  TABLE   bebe_medico(
    id_bebe                         INT             NOT NULL,
    crm_numero_medico               INT             NOT NULL,
    crm_uf_medico                   CHAR(2)         NOT NULL,

    PRIMARY KEY (id_bebe, crm_numero_medico, crm_uf_medico),
    FOREIGN KEY (id_bebe)           REFERENCES  bebe(id),
    FOREIGN KEY (crm_numero_medico, crm_uf_medico) REFERENCES  medico(crm_numero, crm_uf),
)
