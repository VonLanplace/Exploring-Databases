CREATE DATABASE clinica;
USE clinica;

CREATE TABLE paciente (
    num_beneficiario    INTEGER         NOT NULL,
    nome                VARCHAR(100)    NOT NULL,
    logradouro          VARCHAR(200)    NOT NULL,
    numero              INTEGER         NOT NULL,
    cep                 CHAR(8)         NOT NULL,
    complemento         VARCHAR(255)    NOT NULL,
    telefone            VARCHAR(11)     NOT NULL,
    PRIMARY KEY (num_beneficiario)
);
GO;

CREATE TABLE especialidade (
    id                  INTEGER         NOT NULL,
    especialidade       VARCHAR(100)    NOT NULL,
    PRIMARY KEY (id)
);
GO;

CREATE TABLE medico (
    codigo              INTEGER         NOT NULL,
    nome                VARCHAR(100)    NOT NULL,
    logradouro          VARCHAR(200)    NOT NULL,
    numero              INTEGER         NOT NULL,
    cep                 char(8)         NOT NULL,
    complemento         VARCHAR(255)    NOT NULL,
    contato             VARCHAR(11)     NOT NULL,
    especialidade_id    INTEGER         NOT NULL,
    PRIMARY KEY (codigo),
    FOREIGN KEY (especialidade_id)  REFERENCES  especialidade   (id)
);
GO;

CREATE TABLE consulta (
    paciente_num        INTEGER         NOT NULL,
    medico_cod          INTEGER         NOT NULL,
    data_hora           DATETIME        NOT NULL,
    observacao          VARCHAR(255)    NOT NULL,
    PRIMARY KEY (paciente_num, medico_cod),
    FOREIGN KEY (paciente_num)  REFERENCES  paciente    (num_beneficiario),
    FOREIGN KEY (medico_cod)    REFERENCES  medico      (codigo)
);
GO;

INSERT  INTO    paciente
(num_beneficiario,  nome,               logradouro,                 numero, cep,        complemento,                telefone)   VALUES
(99901,             'Washington Silva', 'R.Anhaia',                 150,    '02345000', 'Casa',                     '922229999'),
(99902,             'Luis Ricardo',     'R.Voluntários da Pátria',  2251,   '03254010', 'Bloco B. Apto 25',         '923450987'),
(99903,             'Maria Elisa',      'Av.Aguia de Haia',         1188,   '06987020', 'Apto 1208',                '912348765'),
(99904,             'José Araujo',      'R.XV de Novembro',         18,     '03678000', 'Casa',                     '945674312'),
(99905,             'Joana Paula',      'R.7 de Abril',             97,     '01214000', 'Conjunto 3 - Apto 801',    '912095674');

INSERT  INTO    especialidade
(id, especialidade) VALUES
(1, 'Otorrinolaringologista'),
(2, 'Urologista'),
(3, 'Geriatra'),
(4, 'Pediatra');


INSERT  INTO    medico
(codigo,    nome,               logradouro,             numero, cep,        complemento, contato,       especialidade_id)    VALUES
(100001,    'Ana Paula',        'R.7 de Setembro',      256,    '03698000', 'Casa',     '915689456',    1),
(100002,    'Maria Aparecida',  'Av.Brasil',            32,     '02145070', 'Casa',     '923235454',    1),
(100003,    'Lucas Borger',     'Av.do Estado',         3210,   '05241000', 'Apto 205', '963698585',    2),
(100004,    'Gabriel Oliveira', 'Av.Dom Helder Camara', 350,    '03145000', 'Apto 602', '932485745',    3);

INSERT  INTO consulta
(paciente_num,  medico_cod, data_hora,          observacao) VALUES
(99901,         100002,     '2021-09-04 13:20', 'infecção Urina'),
(99902,         100003,     '2021-09-04 13:15', 'Gripe'),
(99903,         100001,     '2021-09-04 12:30', 'Infecção Garganta');

ALTER TABLE medico
ADD dia_atendimento VARCHAR(15) NOT NULL    DEFAULT 'Não Definido';
GO;

UPDATE  medico
SET     dia_atendimento =   '2ª Feira'
WHERE   codigo          =   100001;

UPDATE  medico
SET     dia_atendimento =   '4ª Feira'
WHERE   codigo          =   100002;

UPDATE  medico
SET     dia_atendimento =   '2ª Feira'
WHERE   codigo          =   100003;

UPDATE  medico
SET     dia_atendimento =   '5ª Feira'
WHERE   codigo          =   100004;

DELETE  FROM    especialidade
WHERE   ID  =   4;

GO;

EXEC    sp_rename   'medico.dia_atendimento',  'dia_semana_atendimento',   'COLUMN';

GO;

UPDATE  medico
SET logradouro = 'Av.Bras Leme',    numero = 876,   cep = '02122000',   complemento = 'Apto 876'
WHERE   codigo = 100003;

ALTER TABLE consulta
ALTER COLUMN observacao VARCHAR(200)    NOT NULL;
