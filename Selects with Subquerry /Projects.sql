USE	master

IF	EXISTS	(SELECT	name	FROM	sys.database	WHERE	name = 'projetos')
	DROP	DATABASE	projetos
GO

CREATE	DATABASE	projetos
GO

USE	projetos

CREATE	TABLE	users(
	id		INT		NOT NULL	IDENTITY(1,1),
	name		VARCHAR(45)	NOT NULL,
	username	VARCHAR(45)	NOT NULL	UNIQUE,
	password	VARCHAR(45)	NOT NULL	DEFAULT('123mudar'),
	email		VARCHAR(45)	NOT NULL,
	PRIMARY	KEY	(id)
)

CREATE	TABLE	projects(
	id		INT		NOT NULL	IDENTITY(10001,1),
	name		VARCHAR(45)	NOT NULL,
	description	VARCHAR(45),
	data		DATE		NOT NULL	CHECK(date > '2014-09-01'),
	PRIMARY	KEY	(id)
)

GO

CREATE	TABLE	user_has_projects(
	id_users	INT		NOT NULL,
	id_projects	INT		NOT NULL,
	PRIMARY	KEY	(id_users, id_projects),
	FOREIGN	KEY	(id_users)	REFERENCES	users(id),
	FOREIGN	KEY	(id_projects)	REFERENCES	projects(id)
)

GO

ALTER	TABLE	users
ALTER	COLUMN	username	VARCHAR(10);

ALTER	TABLE	users
ALTER	COLUMN	password	VARCHAR(8);

GO

INSERT	INTO	users
(name,		username,	password,	email)
VALUES
('Maria',	'Rh_maria',	'123mudar',	'maria@empresa.com'),
('Paulo',	'Ti_paulo',	'123@456',	'paulo@empresa.com'),
('Ana',		'Rh_ana',	'123mudar',	'ana@empresa.com'),
('Clara',	'Ti_clara',	'123mudar',	'clara@empresa.com'),
  ('Aparecido',	'Rh_aparecido',	'55@!cido',	'aparecido@empresa.com')

INSERT	INTO	projects
(name,			description,		data)
VALUES
('Re-folha',		'Refatoração das Folhas',	'2014-09-05'),
('Manutenção PC´s',	'Manutenção PC´s',		'2014-09-06'),
('Auditoria',		NULL,				'2014-09-07')

GO

UPDATE	projects
SET	data = '2014-09-12'
WHERE	name	LIKE	'%Manutenção%'

UPDATE	users
SET	username = 'Rh_cido'
WHERE	name = 'Aparecido'

UPDATE	users
SET	password = '888@*'
WHERE	username = 'Rh_maria'	AND	password = '123mudar'

DELETE	FROM	user_has_projects
WHERE	id_users = 2	AND	id_projects = 10002

SELECT id, name, email, username,
  CASE 
    WHEN  password <> '123mudar' 
      THEN  '********'
    ELSE  password
  END AS password
FROM  users;

SELECT nome, description, data,
  DATE_ADD(data, INTERVAL 15 DAY) AS data_final
  FROM projects
  WHERE id = 10001 AND id IN(
    SELECT id_projects
    FROM user_has_projects
    WHERE id_users IN(
      SELECT id
      FROM users
      WHERE email = 'aparecido@empresa.com'
    )
  )

SELECT nome, email
FROM users
WHERE id IN (
  SELECT id_users
  FROM user_has_projects
  WHERE id_projects IN (
    SELECT id
    FROM projects
    WHERE nome = 'Auditoria'
  )
)

SELECT nome, description, data, 
  '2014-09-16' AS data_final,
  DATE_DIFF('2014-09-16', INTERVAL date) * 79.85 AS custo_total
FROM projects
WHERE nome LIKE '%Manuten%'
