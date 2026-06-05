USE master;

DROP DATABASE IF EXISTS revisao11;

CREATE DATABASE revisao11;

USE revisao11;

CREATE TABLE Plano_de_Saude(
	Codigo		INT	PRIMARY KEY,
	Nome		VARCHAR(30),
	Telefone	VARCHAR(13)
);
GO;

INSERT INTO Plano_de_Saude
(Codigo,	Nome,				Telefone)
VALUES
(1234,		'Amil',				'41599856'),
(2345,		'Sul América',		'45698745'),
(3456,		'Unimed',			'48759836'),
(4567,		'Bradesco Saúde',	'47265897'),
(5678,		'Intermédica',		'41415269');

CREATE TABLE Paciente(
	CPF				VARCHAR(13) PRIMARY KEY,
	Nome			VARCHAR(30),
	Rua				VARCHAR(30),
	Numero			INT,
	Bairro			VARCHAR(20),
	Telefone		VARCHAR(13),
	Plano_de_Saude	INT,
	FOREIGN KEY (Plano_de_Saude) REFERENCES Plano_de_Saude(Codigo)
);
GO;

INSERT INTO Paciente											
(CPF,			Nome,			Rua,						Numero,	Bairro,			Telefone,	Plano_de_Saude)
VALUES
('85987458920',	'Maria Paula',	'R. Voluntários da Pátria',	589,	'Santana',		98458741,	2345),
('87452136900',	'Ana Júlia',	'R. XV de Novembro',		657,	'Centro',		69857412,	5678),
('23659874100',	'João Carlos',	'R. Sete de Setembro',		12,		'República',	74859632,	1234),
('63259874100',	'José Lima',	'R. Anhaia',				768,	'Barra Funda',	96524156,	2345);

CREATE TABLE Medico(
	Codigo			INT PRIMARY KEY,
	Nome			VARCHAR(30),
	Especialidade	VARCHAR(30),
	Plano_de_Saude	INT,
	FOREIGN KEY (Plano_de_Saude) REFERENCES Plano_de_Saude(Codigo)
);
GO;

INSERT INTO Medico
(Codigo,	Nome,		Especialidade,				Plano_de_Saude)
VALUES
(1,			'Claudio',	'Clínico Geral',			1234),
(2,			'Larissa',	'Ortopedista',				2345),
(3,			'Juliana',	'Otorrinolaringologista',	4567),
(4,			'Sérgio',	'Pediatra',					1234),
(5,			'Julio',	'Clínico Geral',			4567),
(6,			'Samara',	'Cirurgião',				1234);

CREATE TABLE Consulta(
	Medico 		INT,
	Paciente	VARCHAR(13),
	Dia_Hora	DATETIME2,
	Diagnostico	VARCHAR(30),
	PRIMARY KEY (Medico, Paciente, Dia_Hora),
	FOREIGN KEY (Medico) REFERENCES Medico(Codigo),
	FOREIGN KEY (Paciente) REFERENCES Paciente(CPF)
);
GO;

INSERT INTO Consulta
(Medico,Paciente,		Dia_Hora,				Diagnostico)
VALUES
(1,		'85987458920',	'2021-02-10 10:30:00',	'Gripe'),
(2,		'23659874100',	'2021-02-10 11:00:00',	'Pé Fraturado'),
(4,		'85987458920',	'2021-02-11 14:00:00',	'Pneumonia'),
(1,		'23659874100',	'2021-02-11 15:00:00',	'Asma'),
(3,		'87452136900',	'2021-02-11 16:00:00',	'Sinusite'),
(5,		'63259874100',	'2021-02-11 17:00:00',	'Rinite'),
(4,		'23659874100',	'2021-02-11 18:00:00',	'Asma'),
(5,		'63259874100',	'2021-02-12 10:00:00',	'Rinoplastia');


-- Consultar Nome e especialidade dos médicos da Amil
SELECT med.Nome, med.Especialidade
FROM Plano_de_Saude pds
INNER JOIN Medico med ON pds.Codigo = med.Plano_de_Saude
WHERE pds.Nome LIKE '%Amil%';

-- Consultar Nome, Endereço concatenado, Telefone e Nome do Plano de Saúde de todos os pacientes
SELECT 
	pac.Nome,
	pac.Rua + ', ' + CAST(pac.Numero AS VARCHAR(4)) + ' - ' + pac.Bairro AS Endereco,
	pac.Telefone,
	pds.Nome
FROM Paciente pac
INNER JOIN Plano_de_Saude pds ON pds.Codigo = pac.Plano_de_Saude;

-- Consultar Telefone do Plano de  Saúde de Ana Júlia
SELECT 
	pds.Telefone
FROM Paciente pac
INNER JOIN Plano_de_Saude pds ON pds.Codigo = pac.Plano_de_Saude
WHERE pac.Nome LIKE '%Ana Júlia%';

-- Consultar Plano de Saúde que não tem pacientes cadastrados
SELECT
	pds.Nome
FROM Paciente pac
RIGHT JOIN Plano_de_Saude pds ON pds.Codigo = pac.Plano_de_Saude
WHERE pac.Plano_de_Saude IS NULL;
	
-- Consultar Planos de Saúde que não tem médicos cadastrados
SELECT
	pds.Nome
FROM Medico med
RIGHT JOIN Plano_de_Saude pds ON pds.Codigo = med.Plano_de_Saude
WHERE med.Plano_de_Saude IS NULL; 

-- Consultar Data da consulta, Hora da consulta, 
--	nome do médico, nome do paciente e diagnóstico de todas as consultas		
SELECT
	CAST(con.Dia_Hora AS DATE) AS Dia,
	CAST(con.Dia_Hora AS TIME) AS Hora,
	med.Nome AS medico_nome,
	pac.Nome AS paciente_nome,
	con.Diagnostico AS Diagnostico
FROM Consulta con
INNER JOIN Paciente pac ON con.Paciente = pac.CPF
INNER JOIN Medico med ON con.Medico = med.Codigo;

-- Consultar Nome do médico, data e hora de consulta e diagnóstico de José Lima		
SELECT
	med.Nome AS medico_nome,
	CAST(con.Dia_Hora AS DATE) AS Dia,
	CAST(con.Dia_Hora AS TIME) AS Hora,
	con.Diagnostico AS Diagnostico
FROM Consulta con
INNER JOIN Paciente pac ON con.Paciente = pac.CPF
INNER JOIN Medico med ON con.Medico = med.Codigo
WHERE pac.Nome LIKE '%José Lima%';

-- Consultar Diagnóstico e Quantidade de consultas que aquele
--	 diagnóstico foi dado (Coluna deve chamar qtd)
SELECT
	con.Diagnostico AS Diagnostico,
	COUNT(con.Dia_Hora) AS qtd
FROM Consulta con
GROUP BY con.Diagnostico;

-- Consultar Quantos Planos de Saúde que não tem médicos cadastrados		
SELECT
	COUNT(pds.Nome)
FROM Medico med
RIGHT JOIN Plano_de_Saude pds ON pds.Codigo = med.Plano_de_Saude
WHERE med.Plano_de_Saude IS NULL;

-- Alterar o nome de João Carlos para João Carlos da Silva
UPDATE 	Paciente
SET Nome = 'João Carlos da Silva'
WHERE Nome = 'João Carlos';

-- Deletar o plano de Saúde Unimed
DELETE FROM Plano_de_Saude
WHERE Nome LIKE  '%Unimed%';

-- Renomear a coluna Rua da tabela Paciente para Logradouro
EXEC sp_rename 'Paciente.Rua', 'Logradouro', 'COLUMN';

-- Inserir uma coluna, na tabela Paciente, de nome data_nasc e inserir os valores
-- (1990-04-18,1981-03-25,2004-09-04 e 1986-06-18) respectivamente
ALTER TABLE Paciente
ADD data_nasc DATE;
UPDATE Paciente SET data_nasc = '1990-04-18' WHERE CPF = '85987458920';
UPDATE Paciente SET data_nasc = '1981-03-25' WHERE CPF = '87452136900';
UPDATE Paciente SET data_nasc = '2004-09-04' WHERE CPF = '23659874100';
UPDATE Paciente SET data_nasc = '1986-06-18' WHERE CPF = '63259874100';
