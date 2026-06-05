USE master;

DROP DATABASE IF EXISTS revisao6;

CREATE DATABASE revisao6;

USE revisao6;
GO;


CREATE TABLE Motorista(
	Codigo			INT			PRIMARY KEY,
	Nome			VARCHAR(50)	NOT NULL,
	Idade			INT			NOT NULL,
	Naturalidade	VARCHAR(30)	NOT NULL
)

INSERT INTO Motorista
(Codigo,	Nome,			Idade,	Naturalidade)
VALUES
(12341,	'Julio Cesar',		48,		'São Paulo'),
(12342,	'Mario Carmo',		27,		'Americana'),
(12343,	'Lucio Castro',		53,		'Campinas'),
(12344,	'André Figueiredo',	33,		'São Paulo'),
(12345,	'Luiz Carlos',		23,		'São Paulo');

CREATE TABLE Onibus(
	Placa 		VARCHAR(7)	PRIMARY KEY,
	Marca		VARCHAR(30)	NOT NULL,
	Ano			INT			NOT NULL,
	Descricao	VARCHAR(30)	NOT NULL
)

INSERT INTO Onibus
(Placa,		Marca,		Ano,	Descricao)
VALUES
('adf0965',	'Mercedes',	1999,	'Leito'),
('bhg7654',	'Mercedes',	2002,	'Sem Banheiro'),
('dtr2093',	'Mercedes',	2001,	'Ar Condicionado'),
('gui7625',  'Volvo',	2001,	'Ar Condicionado');

CREATE TABLE Viagem(
	Codigo 			INT 		PRIMARY KEY,
	Onibus			VARCHAR(7)	NOT NULL,
	Motorista 		INT 		NOT NULL,
	Hora_de_Saida	TIME 		NOT NULL,
	Hora_de_Chegada	TIME 		NOT NULL,
	Destino			VARCHAR(50) NOT NULL,
	FOREIGN KEY	(Onibus)	REFERENCES Onibus(Placa),
	FOREIGN KEY	(Motorista)	REFERENCES Motorista(Codigo)
)

INSERT INTO Viagem
(Codigo,	Onibus,		Codigo,	Hora_de_Saida,	Hora_de_Chegada,	Destino)
VALUES
(101,		'adf0965',	12343,		'10:00:00',		'12:00:00',			'Campinas'),
(102,		'gui7625',	12341,		'07:00:00',		'12:00:00',			'Araraquara'),
(103,		'bhg7654',	12345,		'14:00:00',		'22:00:00',			'Rio de Janeiro'),
(104,		'dtr2093',	12344,		'18:00:00',		'21:00:00',			'Sorocaba');

-- Consultar, da tabela viagem, todas as horas de chegada e saída, convertidas em formato HH:mm (108) e seus destinos
SELECT
	CONVERT(VARCHAR(5), Hora_de_Saida, 108) AS Hora_de_Saida,
	CONVERT(VARCHAR(5), Hora_de_Chegada, 108) AS Hora_de_Chegada,
	Destino
FROM Viagem;

-- Consultar, com subquery, o nome do motorista que viaja para Sorocaba	
SELECT Nome
FROM Motorista
WHERE Codigo IN (
	SELECT Motorista
	FROM Viagem
	WHERE Destino LIKE '%Sorocaba%'
);

-- Consultar, com subquery, a descrição do ônibus que vai para o Rio de Janeiro	
SELECT Descricao
FROM Onibus
WHERE Placa IN (
	SELECT Onibus
	FROM Viagem
	WHERE Destino LIKE '%Rio de Janeiro%'
);
 
-- Consultar, com Subquery, a descrição, a marca e o ano do ônibus dirigido por Luiz Carlos	
SELECT 
	Descricao, Marca, Ano
FROM Onibus
WHERE Placa IN (
	SELECT Onibus
	FROM Viagem
	WHERE Motorista IN (
		SELECT Codigo
		FROM Motorista
		WHERE Nome LIKE '%Luiz%'
	)
);

-- Consultar o nome, a idade e a naturalidade dos motoristas com mais de 30 anos	
SELECT Nome, Idade, Naturalidade
FROM Motorista
WHERE Idade > 30;
