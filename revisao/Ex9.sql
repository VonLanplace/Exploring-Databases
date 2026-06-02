USE master;

IF EXISTS (SELECT * FROM sys.databases WHERE name = 'ex9')
BEGIN
    ALTER DATABASE ex9 SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE ex9;
END;

CREATE DATABASE ex9;

USE ex9;

CREATE TABLE editora (
	codigo INT NOT NULL,
	nome VARCHAR(30) NOT NULL,
	site VARCHAR(40) NULL,
	PRIMARY KEY (codigo)
);

CREATE TABLE autor (
	codigo INT NOT NULL,
	nome VARCHAR(30) NOT NULL,
	biografia VARCHAR(100) NOT NULL,
	PRIMARY KEY (codigo)
);

CREATE TABLE estoque (
	codigo INT NOT NULL,
	nome VARCHAR(100) NOT NULL UNIQUE,
	quantidade INT NOT NULL,
	valor DECIMAL(7,2) NOT NULL CHECK(valor > 0.00),
	codEditora INT NOT NULL,
	codAutor INT NOT NULL, 
	PRIMARY KEY (codigo),
	FOREIGN KEY (codEditora) REFERENCES editora (codigo),
	FOREIGN KEY (codAutor) REFERENCES autor (codigo)
);

CREATE TABLE compra (
	codigo INT NOT NULL,
	codEstoque INT NOT NULL,
	qtdComprada INT NOT NULL,
	valor DECIMAL(7,2) NOT NULL,
	dataCompra DATE NOT NULL,
	PRIMARY KEY (codigo, codEstoque, dataCompra),
	FOREIGN KEY (codEstoque) REFERENCES estoque (codigo)
);

INSERT INTO editora VALUES
(1,'Pearson','www.pearson.com.br'),
(2,'Civilização Brasileira',NULL),
(3,'Makron Books','www.mbooks.com.br'),
(4,'LTC','www.ltceditora.com.br'),
(5,'Atual','www.atualeditora.com.br'),
(6,'Moderna','www.moderna.com.br');

INSERT INTO autor VALUES
(101,'Andrew Tannenbaun','Desenvolvedor do Minix'),
(102,'Fernando Henrique Cardoso','Ex-Presidente do Brasil'),
(103,'Diva Marilia Flemming','Professora adjunta da UFSC'),
(104,'David Halliday','Ph.D. da University of Pittsburgh'),
(105,'Alfredo Steinbruch','Professor de Matematica da UFRS e da PUCRS'),
(106,'Willian Roberto Cereja','Doutorado em Linguistica Aplicada e Estudos da Linguagem'),
(107,'William Stallings','Doutorado em Ciencias da Computacão pelo MIT'),
(108,'Carlos Morimoto','Criador do Kurumin Linux');

INSERT INTO estoque VALUES
(10001,'Sistemas Operacionais Modernos ',4,108.00,1,101),
(10002,'A Arte da Política',2,55.00,2,102),
(10003,'Calculo A',12,79.00,3,103),
(10004,'Fundamentos de Fisica I',26,68.00,4,104),
(10005,'Geometria Analitica',1,95.00,3,105),
(10006,'Gramática Reflexiva',10,49.00,5,106),
(10007,'Fundamentos de Fisica III',1,78.00,4,104),
(10008,'Calculo B',3,95.00,3,103);

-- Datas alteradas para o formato YYYY-MM-DD
INSERT INTO compra VALUES
(15051,10003,2,158.00,'2024-07-04'),
(15051,10008,1,95.00,'2024-07-04'),
(15051,10004,1,68.00,'2024-07-04'),
(15051,10007,1,78.00,'2024-07-04'),
(15052,10006,1,49.00,'2024-07-05'),
(15052,10002,3,165.00,'2024-07-05'),
(15053,10001,1,108.00,'2024-07-05'),
(15054,10003,1,79.00,'2024-08-06'),
(15054,10008,1,95.00,'2024-08-06');

-- 1) Consultar nome, valor unitário, nome da editora e nome do autor dos livros do estoque que foram vendidos. Não pode haver repetições.
SELECT	DISTINCT
		est.nome, est.valor,
		aut.nome AS nome_autor,
		edi.nome AS nome_editora
FROM	estoque est
INNER JOIN autor aut ON est.codAutor = aut.codigo 
INNER JOIN editora edi ON est.codEditora = edi.codigo
INNER JOIN compra com ON com.codEstoque = est.codigo;

-- 2) Consultar nome do livro, quantidade comprada e valor de compra da compra 15051
SELECT 
		est.nome AS nome_do_livro,
		com.qtdComprada AS quantidade_comprada,
		com.valor AS valor_de_compra
FROM compra com
INNER JOIN estoque est ON com.codEstoque = est.codigo
WHERE com.codigo = 15051;

-- 3) Consultar Nome do livro e site da editora dos livros da Makron books (Caso o site tenha mais de 10 dígitos, remover o www.).
SELECT 
		est.nome AS nome_do_livro,
		CASE
			WHEN LEN(edi.site) > 10
			THEN SUBSTRING(edi.site, 5, LEN(edi.site))
			ELSE edi.site
		END AS site_editora
FROM	estoque est
INNER JOIN editora edi ON est.codEditora = edi.codigo
WHERE edi.nome LIKE '%Makron%';

-- 4) Consultar nome do livro e Breve Biografia do David Halliday
SELECT	DISTINCT
		est.nome,
		aut.biografia AS biografia_autor
FROM	estoque est
INNER JOIN autor aut ON est.codAutor = aut.codigo 
WHERE aut.nome = 'David Halliday';

-- 5) Consultar código de compra e quantidade comprada do livro Sistemas Operacionais Modernos
SELECT 
		com.codigo  AS codigo_de_compra,
		com.qtdComprada AS quantidade_comprada
FROM compra com
INNER JOIN estoque est ON com.codEstoque = est.codigo
WHERE est.nome LIKE '%Sistemas Operacionais Modernos%';

-- 6) Consultar quais livros não foram vendidos
SELECT
		est.nome AS nome_livro
FROM estoque est 
LEFT JOIN compra com ON com.codEstoque = est.codigo
WHERE com.codEstoque  IS NULL;

-- 7) Consultar quais livros foram vendidos e não estão cadastrados. Caso o nome dos livros termine com espaço, fazer o trim apropriado.
SELECT
		RTRIM(est.nome) AS nome_livro
FROM compra com
LEFT JOIN estoque est ON com.codEstoque = est.codigo
WHERE est.codigo   IS NULL;

-- 8) Consultar Nome e site da editora que não tem Livros no estoque (Caso o site tenha mais de 10 dígitos, remover o www.)
SELECT 
		edi.nome AS nome_da_editora,
		CASE
			WHEN LEN(edi.site) > 10
			THEN SUBSTRING(edi.site, 5, LEN(edi.site))
			ELSE edi.site
		END AS site_editora
FROM editora edi
LEFT JOIN estoque est ON est.codEditora = edi.codigo
WHERE est.codEditora IS NULL;

-- 9) Consultar Nome e biografia do autor que não tem Livros no estoque (Caso a biografia inicie com Doutorado, substituir por Ph.D.)
SELECT
		aut.nome AS nome_autor,
		CASE
			WHEN aut.biografia LIKE 'Doutorado%'
			THEN REPLACE(aut.biografia ,'Doutorado','Ph.D.')
			ELSE aut.biografia 
		END biografia_autor
FROM autor aut
LEFT JOIN estoque est ON aut.codigo = est.codAutor
WHERE est.codigo IS NULL;

-- 10) Consultar o nome do Autor, e o maior valor de Livro no estoque. Ordenar por valor descendente
SELECT
		aut.nome AS nome_autor,
		MAX(est.valor) AS valor_livro
FROM autor aut
LEFT JOIN estoque est ON aut.codigo = est.codAutor
GROUP BY aut.nome
ORDER BY valor_livro DESC;

-- 11) Consultar o código da compra, o total de livros comprados e a soma dos valores gastos. Ordenar por Código da Compra ascendente.
SELECT
		com.codigo AS codigo_compra,
		SUM(com.qtdComprada) AS total_livros,
		SUM(com.valor) AS valores_gastos
FROM compra com
GROUP BY com.codigo 
ORDER BY com.codigo ASC;

-- 12) Consultar o nome da editora e a média de preços dos livros em estoque. Ordenar pela Média de Valores ascendente.
SELECT
		edi.nome AS nome_editora,
		CAST(AVG(est.valor) AS DECIMAL(7,2)) AS media_precos
FROM editora edi
INNER JOIN estoque est ON edi.codigo = est.codEditora
GROUP BY edi.nome 
ORDER BY media_precos ASC;

-- 13) Consultar o nome do Livro, a quantidade em estoque o nome da editora, o site da editora (Caso o site tenha mais de 10 dígitos, remover o www.), criar uma coluna status onde:
-- 		Caso tenha menos de 5 livros em estoque, escrever Produto em Ponto de Pedido
-- 		Caso tenha entre 5 e 10 livros em estoque, escrever Produto Acabando
-- 		Caso tenha mais de 10 livros em estoque, escrever Estoque Suficiente
-- 		A Ordenacao deve ser por Quantidade ascendente
SELECT
		est.nome AS nome_livro,
		est.quantidade AS qtd_estoque,
		edi.nome AS nome_editora,
		CASE
			WHEN LEN(edi.site) > 10
			THEN REPLACE(edi.site ,'www.','')
			ELSE edi.site
		END AS site_editora,
		CASE 
			WHEN est.quantidade  > 10
			THEN 'Estoque Suficiente'
			WHEN est.quantidade  >= 5 AND est.quantidade <= 10
			THEN 'Produto Acabando'
			ELSE 'Produto em Ponto de Pedido'
		END AS status
FROM estoque est
INNER JOIN editora edi ON est.codEditora = edi.codigo
ORDER BY est.quantidade ASC;

-- 14) Para montar um relatório, é necessário montar uma consulta com a seguinte saída: 
-- 		Código do Livro, Nome do Livro, Nome do Autor, Info Editora (Nome da Editora + Site) de todos os livros
-- 		Só pode concatenar sites que não são nulos
SELECT
		est.codigo AS Codigo_do_Livro,
		est.nome AS Nome_do_Livro,
		aut.nome AS Nome_do_Autor,
		CONCAT('Editora: ', edi.nome , ISNULL(' - Site: ' +edi.site ,'')) AS Info_Editora
FROM estoque est
INNER JOIN autor aut ON est.codAutor = aut.codigo 
INNER JOIN editora edi ON est.codEditora = edi.codigo

-- 15) Consultar Codigo da compra, quantos dias da compra até hoje e quantos meses da compra até hoje
SELECT
		com.codigo AS Codigo_da_compra,
		DATEDIFF(DAY, com.dataCompra ,GETDATE()) AS dias_da_compra,
		DATEDIFF(MONTH, com.dataCompra ,GETDATE()) AS meses_da_compra
FROM compra com;

-- 16) Consultar o código da compra e a soma dos valores gastos das compras que somam mais de 200.00
SELECT
		com.codigo AS codigo_da_compra,
		CAST(SUM(com.valor) AS DECIMAL(7,2)) AS valores_gastos
FROM compra com
GROUP BY com.codigo 
HAVING CAST(SUM(com.valor) AS DECIMAL(7,2)) > 200.00
ORDER BY com.codigo;
