USE master;

DROP DATABASE IF EXISTS revisao3;
GO

CREATE DATABASE revisao3;
GO

USE revisao3;
GO

CREATE TABLE Pacientes(
	CPF			VARCHAR(15)	PRIMARY KEY,
	Nome		VARCHAR(50),
	Rua			VARCHAR(50),
	Num			INT,
	Bairro		VARCHAR(20),
	Telefone	VARCHAR(13),
	Data_Nasc	DATE
);
GO

INSERT INTO Pacientes
(CPF,			Nome,				Rua,				Num,	Bairro,			Telefone,	Data_Nasc)
VALUES
('35454562890',	'José Rubens',		'Campos Salles',	2750,	'Centro',		21450998,	'1954-10-18'),
('29865439810',	'Ana Claudia',		'Sete de Setembro',	178,	'Centro',		97382764,	'1960-05-29'),
('82176534800',	'Marcos Aurélio',	'Timóteo Penteado',	236,	'Vila Galvão',	68172651,	'1980-09-24'),
('12386758770',	'Maria Rita',		'Castello Branco',	7765,	'Vila Rosália',	NULL,		'1975-03-30'),
('92173458910',	'Joana de Souza',	'XV de Novembro',	298,	'Centro',		21276578,	'1944-04-24');


CREATE TABLE Medico(
	Codigo			INT	PRIMARY KEY,
	Nome			VARCHAR(50),
	Especialidade	VARCHAR(20)
);
GO

INSERT INTO Medico
(Codigo,	Nome,					Especialidade)
VALUES
(1,			'Wilson Cesar',			'Pediatra'),
(2,			'Marcia Matos',			'Geriatra'),
(3,			'Carolina Oliveira',	'Ortopedista'),
(4,			'Vinicius Araujo',		'Clínico Geral');

CREATE TABLE Prontuario(
	Data DATE,
	CPF_Paciente	VARCHAR(15),
	Codigo_Medico	INT,
	Diagnostico		VARCHAR(30),
	Medicamento		VARCHAR(30),
	PRIMARY KEY	(Data, CPF_Paciente, Codigo_Medico),
	FOREIGN KEY (CPF_Paciente) REFERENCES Pacientes(CPF),
	FOREIGN KEY (Codigo_Medico) REFERENCES Medico(Codigo),
)

INSERT INTO Prontuario	
(Data,			CPF_Paciente,	Codigo_Medico,	Diagnostico,				Medicamento)
VALUES
('2026-09-10',	'35454562890',	2,				'Reumatismo',				'Celebra'),
('2026-09-10',	'92173458910',	2,				'Renite Alérgica',			'Allegra'),
('2026-09-12',	'29865439810',	1,				'Inflamação de garganta',	'Nimesulida'),
('2026-09-13',	'35454562890',	2,				'H1N1',						'Tamiflu'),
('2026-09-15',	'82176534800',	4,				'Gripe',					'Resprin'),
('2026-09-15',	'12386758770',	3,				'Braço Quebrado',			'Dorflex + Gesso');

--Consultar:
--Nome e Endereço (concatenado) dos pacientes com mais de 50 anos
SELECT 
	pac.Nome,
	Rua + ', ' +
	CAST(Num AS VARCHAR(10)) + '. ' +
	Bairro AS endereco
FROM Pacientes pac
WHERE DATEDIFF(YEAR, pac.Data_Nasc, GETDATE()) > 50;

--Qual a especialidade de Carolina Oliveira
SELECT Especialidade
FROM Medico
WHERE Nome LIKE '%Carolina Oliveira%';

--Qual medicamento receitado para reumatismo
SELECT Medicamento
FROM Prontuario
WHERE Diagnostico LIKE '%Reumatismo%';

--Consultar em subqueries:
--Diagnóstico e Medicamento do paciente José Rubens em suas consultas
SELECT Diagnostico, Medicamento
FROM Prontuario
WHERE CPF_Paciente IN (
	SELECT CPF
	FROM Pacientes
	WHERE Nome LIKE '%José Rubens%'
);

--Nome e especialidade do(s) Médico(s) que atenderam José Rubens.
--	Caso a especialidade tenha mais de 3 letras, 
--		mostrar apenas as 3 primeiras letras concatenada com um ponto final (.)
SELECT 
	Nome, 
	CASE
		WHEN LEN(Especialidade) > 3
		THEN SUBSTRING(Especialidade, 0, 4) + '.'
		ELSE Especialidade
	END AS Especialidade
FROM Medico
WHERE Codigo IN (
	SELECT Codigo_Medico
	FROM Prontuario
	WHERE CPF_Paciente IN (
		SELECT CPF
		FROM Pacientes
		WHERE Nome LIKE '%José Rubens%'
	)
);

--CPF (Com a máscara XXX.XXX.XXX-XX), Nome, Endereço completo (Rua, nº - Bairro), 
--	Telefone (Caso nulo, mostrar um traço (-)) dos pacientes do médico Vinicius
SELECT 
	SUBSTRING(pac.CPF,1,3) + '.' +
	SUBSTRING(pac.CPF,4,3) + '.' +
	SUBSTRING(pac.CPF,7,3) + '-' +
	SUBSTRING(pac.CPF,10,3) AS cpf,
	pac.Nome,
	pac.Rua + ', ' +
	CAST(pac.Num AS VARCHAR(8)) + '. '+
	pac.Bairro AS Endereço_completo,
	ISNULL(pac.Telefone,'-') AS Telefone
FROM Pacientes pac
WHERE pac.CPF IN (
	SELECT pro.CPF_Paciente
	FROM Prontuario pro
	WHERE pro.Codigo_Medico IN (
		SELECT med.Codigo
		FROM Medico med
		WHERE med.Nome LIKE '%Vinicius%'
	)
);
	
--Quantos dias fazem da consulta de Maria Rita até hoje
SELECT DATEDIFF(DAY, GETDATE(), pro.Data)
FROM Prontuario pro
WHERE pro.CPF_Paciente IN (
	SELECT CPF
	FROM Pacientes
	WHERE Nome LIKE '%Maria Rita%'
);

--Alterar o telefone da paciente Maria Rita, para 98345621
UPDATE Pacientes
SET Telefone = '98345621'
WHERE Nome = 'Maria Rita';
--Alterar o Endereço de Joana de Souza para Voluntários da Pátria, 1980, Jd. Aeroporto
UPDATE Pacientes
SET
	Rua = 'Voluntários da Pátria',
	Num = 1980,
	Bairro = 'Jd. Aeroporto'
WHERE Nome = 'Joana de Souza';
