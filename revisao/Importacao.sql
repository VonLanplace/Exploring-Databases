USE master;

DROP DATABASE IF EXISTS revisao6;

CREATE DATABASE revisao6;


USE revisao6;

CREATE TABLE Cliente(
	RG			VARCHAR(13)	PRIMARY KEY,
	CPF			VARCHAR(13)	NOT NULL,
	Nome		VARCHAR(50)	NOT NULL,
	Logradouro	VARCHAR(30),
	Numero		INT
);


INSERT INTO Cliente
(RG,				CPF,			Nome,				Logradouro,		Numero)
VALUES
('29531844',		'34519878040',	'Luiz André',		'R. Astorga',	500),
('13514996x',		'84984285630',	'Maria Luiza',		'R. Piauí',		174),
('121985541',		'23354997310',	'Ana Barbara',		'Av. Jaceguai',	1141),
('23987746x',		'43587669920',	'Marcos Alberto',	'R. Quinze',	22);

CREATE TABLE Pedido(
	Nota_Fiscal	INT	PRIMARY KEY,
	Valor		NUMERIC(7,2),
	Dia			DATE,
	RG_Cliente	VARCHAR(13),
	FOREIGN KEY (RG_Cliente) REFERENCES Cliente(RG)
);


INSERT INTO Pedido		
(Nota_Fiscal,	Valor,	Dia,			RG_Cliente)
VALUES
(1001,			754,	'2018-04-01',	'121985541'),
(1002,			350,	'2018-04-02',	'121985541'),
(1003,			30,		'2018-04-02',	'29531844'),
(1004,			1500,	'2018-04-03',	'13514996x');


CREATE TABLE Fornecedor(
	Codigo		INT PRIMARY KEY,
	Nome		VARCHAR(50),
	Logradouro	VARCHAR(50),
	Numero		INT,
	Pais		VARCHAR(20),
	Area		INT,
	Telefone	VARCHAR(13),
	CNPJ		VARCHAR(15),
	Cidade		VARCHAR(30),
	Transporte	VARCHAR(20),
	Moeda		VARCHAR(4)
);


INSERT INTO Fornecedor
(Codigo,	Nome,		Logradouro,					Numero,	Pais,	Area,	Telefone,		CNPJ,				Cidade,			Transporte,	Moeda)
VALUES
(1,			'Clone',	'Av. Nações Unidas, 12000',	12000,	'BR',	55,		'1141487000',	NULL,				'São Paulo',	NULL,		'R$'),
(2,			'Logitech',	'28th Street, 100',			100,	'USA',	1,		'2127695100',	NULL,				NULL,			'Avião',	'US$'),
(3,			'LG',		'Rod. Castello Branco',		NULL,	'BR',	55,		'0800664400',	'4159978100001',	'Sorocaba',		NULL,		'R$'),
(4,			'PcChips',	'Ponte da Amizade',			NULL,	'PY',	595,	NULL,			NULL,				NULL,			'Navio',	'US$');

CREATE TABLE Mercadoria(
	Codigo			INT	PRIMARY KEY,
	Descricao		VARCHAR(50),
	Preco			NUMERIC(7,2),
	Qtd				INT,
	Cod_Fornecedor	INT	NOT NULL,
	FOREIGN KEY (Cod_Fornecedor) REFERENCES Fornecedor(Codigo)
);


INSERT INTO Mercadoria
(Codigo,	Descricao,		Preco,	Qtd,	Cod_Fornecedor)
VALUES
(10,		'Mouse',		24,		30,		1),
(11,		'Teclado',		50,		20,		1),
(12,		'Cx. De Som',	30,		8,		2),
(13,		'Monitor 17',	350,	4,		3),
(14,		'Notebook',		1500,	7,		4);



--Pede-se: (Quando o endereço concatenado não tiver número, colocar só o logradouro e o país, quando tiver colocar, também o número)		
--Nota: (CPF deve vir sempre mascarado no formato XXX.XXX.XXX-XX 
--	e RG Sempre com um traçao antes do último dígito (Algo como XXXXXXXX-X), 
--		mas alguns tem 8 e outros 9 dígitos)
--Consultar 10% de desconto no pedido 1003
SELECT Valor * 0.9 AS Valor_Descontado
FROM Pedido
WHERE Nota_Fiscal = 1003;

--Consultar 5% de desconto em pedidos com valor maior de R$700,00
SELECT Valor * 0.95 AS Valor_Descontado
FROM Pedido
WHERE Valor > 700.00;

--Consultar e atualizar aumento de 20% no valor de
--	marcadorias com estoque menor de 10
SELECT Preco * 1.20 AS Preco_Aumentado
FROM Mercadoria
WHERE Qtd < 10;
UPDATE Mercadoria
SET Preco = Preco * 1.20
WHERE Qtd < 10;

--Data e valor dos pedidos do Luiz
SELECT ped.Dia, ped.Valor
FROM Pedido ped
INNER JOIN Cliente cli ON ped.RG_Cliente = cli.RG
WHERE cli.Nome LIKE 'Luiz%';

--CPF, Nome e endereço concatenado do cliente de nota 1004
SELECT
	SUBSTRING(cli.CPF, 1,3) + '.'+
		SUBSTRING(cli.CPF, 4,3) + '.'+
		SUBSTRING(cli.CPF, 7,3) + '-'+
		SUBSTRING(cli.CPF,10,2)
	AS cpf,
	cli.Nome,
	Logradouro + ', '+ 
		CASE
			WHEN Numero IS NULL
			THEN ''
			ELSE ', ' + CAST(Numero AS VARCHAR(12))
		END + '.'
	AS endereco_completo
FROM Cliente cli
INNER JOIN Pedido ped ON  ped.RG_Cliente = cli.RG
WHERE ped.Nota_Fiscal = 1004;

--País e meio de transporte da Cx. De som	
SELECT 	
	forn.Pais, forn.Transporte
FROM Mercadoria merc
INNER JOIN Fornecedor forn ON merc.Cod_Fornecedor = forn.Codigo
WHERE merc.Descricao LIKE 'Cx. De som%';

--Nome e Quantidade em estoque dos produtos fornecidos pela Clone	
SELECT 
	merc.Descricao, merc.Qtd
FROM Mercadoria merc
INNER JOIN Fornecedor forn ON merc.Cod_Fornecedor = forn.Codigo
WHERE forn.Nome LIKE 'Clone%'

--Endereço concatenado e telefone dos fornecedores do monitor. 
--	(Telefone brasileiro (XX)XXXX-XXXX ou XXXX-XXXXXX (Se for 0800),
--	Telefone Americano (XXX)XXX-XXXX)
SELECT
	forn.Logradouro + ', '+ 
		CASE
			WHEN forn.Numero IS NULL
			THEN ''
			ELSE ', ' + CAST(forn.Numero AS VARCHAR(12))
		END + '. '+
	forn.Pais AS endereco_completo,
	CASE 
		WHEN Telefone IS NULL THEN ''
		
		WHEN forn.Pais = 'USA'
			THEN
				'(' + SUBSTRING(forn.Telefone,1,3) + ')' + 
				SUBSTRING(forn.Telefone,4,3) + '-' + 
				SUBSTRING(forn.Telefone,7,LEN(forn.Telefone))
		WHEN forn.Pais = 'BR'
			THEN
				CASE 
					WHEN forn.Telefone LIKE '0800%'
						THEN 
							SUBSTRING(forn.Telefone,1,4) + '-' + 
							SUBSTRING(forn.Telefone,5,LEN(forn.Telefone))
					ELSE 
						'(' + SUBSTRING(forn.Telefone,1,2) + ')' + 
						SUBSTRING(forn.Telefone,3,4) + '-' + 
						SUBSTRING(forn.Telefone,7,LEN(forn.Telefone))
				END
		ELSE forn.Telefone
	END AS Telefone
FROM Fornecedor forn;

--Tipo de moeda que se compra o notebook
SELECT forn.Moeda
FROM Fornecedor forn
INNER JOIN Mercadoria merc ON merc.Cod_Fornecedor = forn.Codigo
WHERE merc.Descricao LIKE 'Notebook%';

--Considerando que hoje é 03/02/2019,
--	há quantos dias foram feitos os pedidos e, 
--	criar uma coluna que escreva Pedido antigo para pedidos feitos 
--	há mais de 6 meses e pedido recente para os outros
SELECT
	ped.Nota_Fiscal AS Pedido,
	CONVERT(VARCHAR, ped.Dia, 103) AS Data_Pedido
FROM Pedido ped
WHERE DATEDIFF(MONTH, '2019-02-03', ped.Dia) > 6;

ALTER TABLE Pedido
ADD idade VARCHAR(15);

UPDATE Pedido
SET idade = 
	CASE
		WHEN DATEDIFF(MONTH, '2019-02-03', Dia) > 6
			THEN 'Pedido Antigo'
		ELSE 'Pedido Novo'
	END;
	
--Nome e Quantos pedidos foram feitos por cada cliente
SELECT
	cli.Nome AS nome_cliente,
	COUNT(ped.Nota_Fiscal) AS numero_pedidos
FROM Cliente cli
INNER JOIN Pedido ped ON ped.RG_Cliente = cli.RG
GROUP BY cli.Nome;

--RG,CPF,Nome e Endereço dos cliente cadastrados que Não Fizeram pedidos		
SELECT
	SUBSTRING(cli.RG,	1,				LEN(cli.RG)-1) + '-' +
	SUBSTRING(cli.RG,	LEN(cli.RG),	1)
	AS rg,
	SUBSTRING(cli.CPF, 1,3) + '.'+
	SUBSTRING(cli.CPF, 4,3) + '.'+
	SUBSTRING(cli.CPF, 7,3) + '-'+
	SUBSTRING(cli.CPF,10,2)
	AS cpf,
	cli.Nome,
	cli.Logradouro +
	CASE
		WHEN cli.Numero IS NULL
		THEN ''
		ELSE ', ' + CAST(cli.Numero AS VARCHAR(12))
	END + '.'
	AS endereco_completo
FROM Cliente cli
LEFT JOIN Pedido ped ON ped.RG_Cliente = cli.RG
WHERE ped.RG_Cliente IS NULL;
