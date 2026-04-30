CREATE	DATABASE	mecanica
GO

USE	mecanica
GO

CREATE TABLE 	peca(
	id			INT				NOT	NULL	IDENTITY(3411,7),
	nome		VARCHAR(100)	NOT	NULL	UNIQUE,
	preco		DECIMAL(4,2)	NOT	NULL	CHECK(preco >= 0),
	estoque		INT				NOT	NULL	CHECK(estoque >= 10),
	PRIMARY	KEY	(id)
)

CREATE TABLE	cliente(
	id			INT				NOT NULL	IDENTITY(3401,15),
	nome		VARCHAR(100)	NOT	NULL,
	logradouro	VARCHAR(200)	NOT NULL,
	numero		INT				NOT NULL	CHECK(numero >= 0),
	cep			CHAR(8)			NOT	NULL	CHECK(LEN(cep) = 8),
	complemento	VARCHAR(255)	NOT	NULL,
	PRIMARY KEY	(id)
)

CREATE TABLE	categoria(
	id			INT				NOT NULL	IDENTITY,
	categoria	VARCHAR(10)		NOT	NULL	CHECK(UPPER(categoria) IN ('ESTAGIÁRIO', 'NÍVEL 1', 'NÍVEL 2' , 'NÍVEL 3')),
	valor_hora	DECIMAL(4,2)	NOT	NULL,
	CONSTRAINT	CHK_ValorPorCategoria	CHECK(
		valor_hora >= 0
		AND	(
			(UPPER(categoria) = 'ESTAGIÁRIO'	AND	valor_hora > 15.00)
			OR	(UPPER(categoria) = 'NÍVEL 1'	AND	valor_hora > 25.00)
			OR	(UPPER(categoria) = 'NÍVEL 2'	AND	valor_hora > 35.00)
			OR	(UPPER(categoria) = 'NÍVEL 3'	AND	valor_hora > 50.00)
		)
	),
	PRIMARY KEY (id)
)

GO

CREATE	TABLE	telefone(
	id_cliente	INT				NOT	NULL,
	telefone	VARCHAR(11)		NOT	NULL	CHECK(LEN(telefone) = 10 OR LEN(telefone) = 11),
	PRIMARY	KEY (id_cliente,telefone),
	FOREIGN KEY	(id_cliente)	REFERENCES cliente(id)
)

CREATE	TABLE	veiculo(
	placa			CHAR(7)		NOT NULL	CHECK(LEN(placa) = 7),
	marca			VARCHAR(30)	NOT	NULL,
	modelo			VARCHAR(30)	NOT	NULL,
	cor				VARCHAR(15)	NOT	NULL,
	ano_fabricacao	INT			NOT NULL	CHECK(ano_fabricacao > 1997),
	ano_modelo		INT			NOT	NULL,
	CONSTRAINT CTK_AnoModeloAnoFabricacao	CHECK(
		ano_modelo > 1997 
		AND (
			(ano_modelo = ano_fabricacao) 
			OR (ano_modelo = ano_fabricacao + 1)
		)
	),
	data_aquisicao	DATE		NOT	NULL,
	id_cliente		INT			NOT	NULL,
	PRIMARY	KEY	(placa),
	FOREIGN	KEY	(id_cliente)	REFERENCES cliente(id)
)

CREATE	TABLE	funcionario(
	id						INT				NOT NULL	IDENTITY(101,1),
	nome					VARCHAR(100)	NOT	NULL,
	logradouro				VARCHAR(200)	NOT	NULL,
	numero					INT				NOT NULL	CHECK(numero > 0),
	telefone				CHAR(11)		NOT	NULL	CHECK(LEN(telefone) = 10 OR LEN(telefone) = 11),
	categoria_habilitacao	VARCHAR(2)		NOT	NULL	CHECK(UPPER(categoria_habilitacao) IN ('A','B','C','D','E')),
	id_categoria			INT				NOT NULL,
	PRIMARY KEY	(id),
	FOREIGN KEY	(id_categoria)	REFERENCES	categoria(id)
)

GO

CREATE	TABLE	reparo(
	placa_veiculo	CHAR(7)			NOT	NULL,
	id_funcionario	INT				NOT	NULL,
	id_peca			INT				NOT	NULL,
	dia				DATE			NOT	NULL	DEFAULT(GETDATE()),
	custo_total		DECIMAL(4,2)	NOT	NULL	CHECK(custo_total >= 0),
	tempo			INT				NOT	NULL	CHECK(tempo >= 0),
	PRIMARY KEY (placa_veiculo,id_funcionario,id_peca,dia),
	FOREIGN	KEY	(placa_veiculo)		REFERENCES	veiculo(placa),
	FOREIGN	KEY	(id_funcionario)	REFERENCES	funcionario(id),
	FOREIGN	KEY	(id_peca)			REFERENCES	peca(id),
)
