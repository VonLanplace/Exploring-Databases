USE master

CREATE DATABASE revisao1;

USE revisao1;

CREATE TABLE aluno(
	ra			INT 			PRIMARY KEY,
	nome		VARCHAR(20),
	sobrenome	VARCHAR(80),
	rua			VARCHAR(100),
	numero		INT,
	bairro		VARCHAR(100),
	cep			VARCHAR(13),
	telefone	VARCHAR(13)
);

CREATE TABLE cursos(
	codigo			INT				PRIMARY KEY,
	nome			VARCHAR(100),
	carga_horaria	INT,
	turno			VARCHAR(10)
);

CREATE TABLE disciplinas(
	codigo			INT				PRIMARY KEY,
	nome			VARCHAR(100),
	carga_horaria	INT,
	turno			VARCHAR(10),
	semestre		INT
);

INSERT INTO aluno
(ra,	nome,		sobrenome,		rua,						numero,	bairro,				cep,		telefone)
VALUES
(12345,	'José',		'Silva',		'Almirante Noronha',		236,	'Jardim São Paulo',	'1589000',	69875287),
(12346,	'Ana',		'Maria Bastos',	'Anhaia',					1568,	'Barra Funda',		'3569000',	25698526),
(12347,	'Mario',	'Santos',		'XV de Novembro',			1841,	'Centro',			'1020030',	NULL),
(12348,	'Marcia',	'Neves',		'Voluntários da Patria',	225,	'Santana',			'2785090',	78964152);

INSERT INTO cursos
(codigo,	nome,	carga_horaria,	turno)
VALUES
(1,			'Informatica',	2800,	'Tarde'),
(2,			'Informatica',	2800,	'Noite'),
(3,			'Logística',	2650,	'Tarde'),
(4,			'Logística',	2650,	'Noite'),
(5,			'Plásticos',	2500,	'Tarde'),
(6,			'Plásticos',	2500,	'Noite');

INSERT INTO disciplinas
(codigo, nome, 					carga_horaria,	turno,	semestre)
VALUES
(1,		'Informática',			4,				'Tarde',	1),
(2,		'Informática',			4,				'Noite',	1),
(3,		'Quimica',				4,				'Tarde',	1),
(4,		'Quimica',				4,				'Noite',	1),
(5,		'Banco de Dados I',		2,				'Tarde',	3),
(6,		'Banco de Dados I',		2,				'Noite',	3),
(7,		'Estrutura de Dados',	4,				'Tarde',	4),
(8,		'Estrutura de Dados',	4,				'Noite',	4);

--Nome e sobrenome, como nome completo dos Alunos Matriculados
SELECT
	nome +' ' + sobrenome AS nome_completo
FROM aluno;
--Rua, nº , Bairro e CEP como Endereço do aluno que não tem telefone
SELECT
	rua + ', ' + 
	CAST(numero AS VARCHAR(13)) + '. ' +
	bairro + ' - ' +
	cep AS endereco
FROM aluno;
--Telefone do aluno com RA 12348
SELECT
	telefone
FROM aluno
WHERE ra = 12348;
--Nome e Turno dos cursos com 2800 horas
SELECT
	nome,
	turno
FROM cursos
WHERE carga_horaria = 2800;
--O semestre do curso de Banco de Dados I noite
SELECT
	semestre
FROM disciplinas
WHERE 
	nome LIKE 'Banco de Dados I'
	AND 
	turno LIKE 'Noite';










