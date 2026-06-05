USE master;

DROP DATABASE IF EXISTS revisao10;

CREATE DATABASE revisao10;

USE revisao10;


CREATE TABLE Medicamento(
	Codigo				INT	PRIMARY KEY,
	Nome				VARCHAR(50),
	Apresentacao		VARCHAR(50),
	Unidade_de_Cadastro	VARCHAR(30),
	Preco_Proposto		NUMERIC(7,3)
);
GO;

INSERT INTO Medicamento
(Codigo,	Nome,								Apresentacao,				Unidade_de_Cadastro,	Preco_Proposto)
VALUES
(1,	 		'Acetato de medroxiprogesterona',	'150 mg/ml',				'Ampola',				6.700),
(2,	 		'Aciclovir',						'200mg/comp.',				'Comprimido',			0.280),
(3,			'Ácido Acetilsalicílico',		 	'500mg/comp.',				'Comprimido',			0.035),
(4,			'Ácido Acetilsalicílico',		  	'100mg/comp.',				'Comprimido',			0.030),
(5,			'Ácido Fólico',					 	'5mg/comp.',				'Comprimido',			0.054),
(6,			'Albendazol',						'400mg/comp. mastigável',	'Comprimido',  			0.560),
(7,			'Alopurinol',						'100mg/comp.',				'Comprimido',  			0.080),
(8,			'Amiodarona',						'200mg/comp.',				'Comprimido',  			0.200),
(9,			'Amitriptilina(Cloridrato)',		'25mg/comp.',				'Comprimido',  			0.220),
(10,		'Amoxicilina',  	 				'500mg/cáps.',				'Cápsula',  			0.190);


CREATE TABLE Cliente(
	CPF			VARCHAR(13) PRIMARY KEY,
	Nome		VARCHAR(30),
	Rua			VARCHAR(30),
	Num			INT,
	Bairro		VARCHAR(30),
	Telefone	VARCHAR(13)
);
GO;

INSERT INTO Cliente
(CPF,			Nome,				Rua,						Num,	Bairro,			Telefone)
VALUES
('34390898700',	'Maria Zélia',		'Anhaia',					65,		'Barra Funda',	'92103762'),
('21345986290',	'Roseli Silva',		'Xv. De Novembro',			987,	'Centro',		'82198763'),
('86927981825',	'Carlos Campos',	'Voluntários da Pátria',	1276,	'Santana',		'98172361'),
('31098120900',	'João Perdizes',	'Carlos de Campos',			90,		'Pari',			'61982371');


CREATE TABLE Venda(
	Nota_Fiscal			INT,
	CPF_cliente			VARCHAR(13),
	Codigo_Medicamento	INT,
	Quantidade			INT,
	Valor_Total			NUMERIC(7,2),
	Dia					DATE,
	PRIMARY KEY (Nota_Fiscal, CPF_cliente, Codigo_Medicamento),
	FOREIGN KEY (CPF_cliente) REFERENCES Cliente(CPF),
	FOREIGN KEY (Codigo_Medicamento) REFERENCES Medicamento(Codigo)
);
GO;

INSERT INTO Venda					
(Nota_Fiscal,	CPF_cliente,	Codigo_Medicamento,	Quantidade,	Valor_Total,	Dia)
VALUES
(31501,			'86927981825',	10,					3,			0.57,			'2020-11-01'),
(31501,			'86927981825',	2,					10,			2.8,			'2020-11-01'),
(31501,			'86927981825',	5,					30,			1.05,			'2020-11-01'),
(31501,			'86927981825',	8,					30,			6.6,			'2020-11-01'),
(31502,			'34390898700',	8,					15,			3,				'2020-11-01'),
(31502,			'34390898700',	2,					10,			2.8,			'2020-11-01'),
(31502,			'34390898700',	9,					10,			2.2,			'2020-11-01'),
(31503,			'31098120900',	1,					20,			134,			'2020-11-02');


-- Nome, apresentação, unidade e valor unitário dos remédios que ainda não foram vendidos. 
-- 		Caso a unidade de cadastro seja comprimido, mostrar Comp.
SELECT
	med.Nome,
	med.Apresentacao,
	CASE 
		WHEN med.Unidade_de_Cadastro LIKE '%omprimido%'
		THEN 'Comp.'
		ELSE med.Unidade_de_Cadastro
	END AS Unidade_de_Cadastro,
	med.Preco_Proposto
FROM Medicamento med
LEFT JOIN Venda ven ON ven.Codigo_Medicamento = med.Codigo
WHERE ven.Codigo_Medicamento IS NULL;

-- Nome dos clientes que compraram Amiodarona
SELECT cli.Nome
FROM Cliente cli
INNER JOIN Venda ven ON cli.CPF = ven.CPF_cliente
INNER JOIN Medicamento med ON ven.Codigo_Medicamento = med.Codigo
WHERE med.Nome LIKE '%Amiodarona%';

-- CPF do cliente, endereço concatenado, nome do medicamento (como nome de remédio),  
-- 		apresentação do remédio, unidade, preço proposto, quantidade vendida 
--		e valor total dos remédios vendidos a Maria Zélia	
SELECT 
	cli.CPF AS cpf_cliente,
	cli.Rua + ', ' +
		CAST(cli.Num AS VARCHAR(12)) + ' - ' +
		cli.Bairro
	AS endereco_cliente,
	med.Nome AS nome_do_remedio,
	med.Apresentacao AS apresentacao_remedio,
	med.Unidade_de_Cadastro AS unidade_remedio,
	med.Preco_Proposto AS preco_remedio,
	ven.Quantidade AS quantidade_vendida_remedio,
	ven.Valor_Total AS valor_total_remedio
FROM Cliente cli
INNER JOIN Venda ven ON cli.CPF = ven.CPF_cliente
INNER JOIN Medicamento med ON ven.Codigo_Medicamento = med.Codigo
WHERE cli.Nome LIKE '%Maria Zélia%';
	
-- Data de compra, convertida, de Carlos Campos
SELECT
	CONVERT(VARCHAR, ven.Dia, 103) AS Data_de_Compra
FROM Cliente cli
INNER JOIN Venda ven ON cli.CPF = ven.CPF_cliente
WHERE cli.Nome LIKE '%Carlos Campos%'
GROUP BY ven.Dia;

-- Alterar o nome da  Amitriptilina(Cloridrato) para Cloridrato de Amitriptilina	
UPDATE Medicamento
SET Nome = 'Cloridrato de Amitriptilina'
WHERE Nome = 'Amitriptilina(Cloridrato)';
