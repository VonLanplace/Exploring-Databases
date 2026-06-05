USE master;

DROP DATABASE IF EXISTS revisao08;

CREATE DATABASE revisao08;

USE revisao08;

CREATE TABLE Cliente(
	Codigo				INT PRIMARY KEY,
	Nome				VARCHAR(30),
	Endereco			VARCHAR(30),
	Telefone			VARCHAR(13),
	Telefone_Comercial	VARCHAR(13)
)
GO;

INSERT INTO Cliente
(Codigo,	Nome,				Endereco,							Telefone,	Telefone_Comercial)
VALUES
(1,		'Luis Paulo',		'R. Xv de Novembro, 100',			'45657878',	NULL),
(2,		'Maria Fernanda',	'R. Anhaia, 1098',					'27289098',	'40040090'),
(3,		'Ana Claudia',		'Av. Voluntários da Pátria, 876',	'21346548',	NULL),
(4,		'Marcos Henrique',	'R. Pantojo, 76',					'51425890',	'30394540'),
(5,		'Emerson Souza',	'R. Pedro Álvares Cabral, 97',		'44236545',	'39389900'),
(6,		'Ricardo Santos',	'Trav. Hum, 10',					'98789878',	NULL);

CREATE TABLE Tipo_de_Mercadoria(
	Codigo	INT PRIMARY KEY,
	Nome	VARCHAR(30)
)
GO;

INSERT INTO Tipo_de_Mercadoria
(Codigo,	Nome)
VALUES
(10001,	'Pães'),
(10002,	'Frios'),
(10003,	'Bolacha'),
(10004,	'Clorados'),
(10005,	'Frutas'),
(10006,	'Esponjas'),
(10007,	'Massas'),
(10008,	'Molhos');

CREATE TABLE Corredor(
	Codigo	INT	PRIMARY KEY,
	Tipo	INT,
	Nome	VARCHAR(30),
	FOREIGN KEY (Tipo) REFERENCES Tipo_de_Mercadoria(Codigo)
)
GO;

INSERT INTO Corredor
(Codigo,	Tipo,	Nome)
VALUES
(101,	10001,	'Padaria'),
(102,	10002,	'Calçados'),
(103,	10003,	'Biscoitos'),
(104,	10004,	'Limpeza'),
(105,	NULL,	NULL),
(106,	NULL,	NULL),
(107,	10007,	'Congelados');

CREATE TABLE Compra(
	Nota_Fiscal		INT PRIMARY KEY,
	Codigo_Cliente	INT,
	Valor			NUMERIC(7,3),
	FOREIGN KEY (Codigo_Cliente) REFERENCES Cliente(Codigo)
)
GO;

INSERT INTO Compra
(Nota_Fiscal,	Codigo_Cliente,	Valor)
VALUES
(1234,			2,				200),
(2345,			4,				156),
(3456,			6,				354),
(4567,			3,				19);

CREATE TABLE Mercadoria(
	Codigo		INT PRIMARY KEY,
	Nome		VARCHAR(30),
	Corredor	INT,
	Tipo		INT,
	Valor		NUMERIC(7,3),
	FOREIGN KEY (Corredor) REFERENCES Corredor(Codigo),
	FOREIGN KEY (Tipo) REFERENCES Tipo_de_Mercadoria(Codigo)
)

INSERT INTO Mercadoria
(Codigo,	Nome,				Corredor,	Tipo,	Valor)
VALUES
(1001,		'Pão de Forma',		101,		10001,	3.5),
(1002,		'Presunto',			101,		10002,	2.0),
(1003,		'Cream Cracker',	103,		10003,	4.5),
(1004,		'Água Sanitária',	104,		10004,	6.5),
(1005,		'Maçã',				105,		10005,	0.9),
(1006,		'Palha de Aço',		106,		10006,	1.3),
(1007,		'Lasanha',			107,		10007,	9.7);

-- Pede-se:
-- Valor da Compra de Luis Paulo
SELECT com.Valor
FROM Compra com
INNER JOIN Cliente cli ON cli.Codigo = com.Codigo_Cliente
WHERE cli.Nome LIKE '%Luis Paulo%';

-- Valor da Compra de Marcos Henrique
SELECT com.Valor
FROM Compra com
INNER JOIN Cliente cli ON cli.Codigo = com.Codigo_Cliente
WHERE cli.Nome LIKE '%Marcos Henrique%';

-- Endereço e telefone do comprador de Nota Fiscal = 4567
SELECT 
	cli.Endereco, cli.Telefone
FROM Compra com
INNER JOIN Cliente cli ON cli.Codigo = com.Codigo_Cliente
WHERE com.Nota_Fiscal = 4567;

-- Valor da mercadoria cadastrada do tipo " Pães"
SELECT mer.Valor
FROM Mercadoria mer
INNER JOIN Tipo_de_Mercadoria tpm ON tpm.Codigo = mer.Tipo
WHERE tpm.Nome LIKE '%Pães%';

-- Nome do corredor onde está a Lasanha
SELECT cor.Nome
FROM Mercadoria mer
INNER JOIN Corredor cor ON cor.Codigo = mer.Corredor
WHERE mer.Nome LIKE '%Lasanha%';

-- Nome do corredor onde estão os clorados
SELECT cor.Nome
FROM Corredor cor
INNER JOIN Mercadoria mer ON cor.Codigo = mer.Corredor
INNER JOIN Tipo_de_Mercadoria tpm ON tpm.Codigo = mer.Tipo
WHERE tpm.Nome LIKE '%clorados%';
