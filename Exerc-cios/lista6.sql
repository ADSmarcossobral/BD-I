/* a) Criação das tabelas Candidato, Votacao e Zona_Secao, especificando chave primária e
chaves estrangeiras; */

CREATE SEQUENCE seq_partido START 1;

CREATE TABLE partido(
	cod_partido INT DEFAULT nextval('seq_partido'),
	nome_partido VARCHAR (30) NULL,
	CONSTRAINT pk_partido PRIMARY KEY (cod_partido)
);

CREATE SEQUENCE seq_cargo START 1;

CREATE TABLE cargo(
	cod_cargo INT DEFAULT nextval('seq_cargo'),
	nome_cargo VARCHAR (30) NULL,
	CONSTRAINT pk_cargo PRIMARY KEY (cod_cargo)
);

CREATE TABLE zona_secao(
	num_zona INT NOT NULL,
	num_secao INT NOT NULL,
	nome_zona_secao VARCHAR (30) NULL,
	qtd_eleitores INT,
	CONSTRAINT pk_zona PRIMARY KEY (num_zona, num_secao)
);

CREATE SEQUENCE seq_candidato START 1;

CREATE TABLE candidato(
	num_candidato INT DEFAULT nextval('seq_candidato'),
	nome_candidato VARCHAR (30) NULL,
	cod_cargo INT NOT NULL,
	cod_partido INT NOT NULL,
	CONSTRAINT pk_candidato PRIMARY KEY (num_candidato),
	CONSTRAINT fk_cargo FOREIGN KEY (cod_cargo) REFERENCES cargo (cod_cargo),
	CONSTRAINT fk_partido FOREIGN KEY (cod_partido) REFERENCES partido (cod_partido)
);

CREATE SEQUENCE seq_votacao START 1;

CREATE TABLE votacao(
	cod_votacao INT DEFAULT nextval('seq_votacao'),
	qtd_votos INT,
	num_zona INT NOT NULL,
	num_secao INT NOT NULL,
	num_candidato INT NOT NULL,
	CONSTRAINT pk_votacao PRIMARY KEY (cod_votacao),
	CONSTRAINT fk_zona FOREIGN KEY (num_zona, num_secao) REFERENCES zona_secao (num_zona, num_secao),
	CONSTRAINT fk_candidato FOREIGN KEY (num_candidato) REFERENCES candidato (num_candidato)
);

/* b) Alteração da estrutura da tabela Votacao, adicionando um atributo data_votacao;  */

ALTER TABLE votacao
ADD COLUMN data_votacao DATE;

/* c) Alteração da estrutura da tabela Candidato, removendo a chave estrangeira com a
tabela Partido; */

ALTER TABLE candidato
DROP CONSTRAINT fk_partido; 

/* d) Criar um índice “não-clustered” na tabela Candidato, com os atributos cod_cargo e
cod_partido; */ 

CREATE INDEX ON candidato (num_candidato);

/* e) Inserir um registro na tabela Votacao. (qtd_votos = 1000, num_secao = 10,
num_zona = 5, num_candidato = 555);  */

INSERT INTO votacao (qtd_votos, num_secao, num_zona, num_candidato)
VALUES (1000,10,5,555);

/* f) Inserir um registro na tabela Zona_Secao (qtd_eleitores = 300, nome_zona_secao =
“Zona Teste”, num_zona = 7, num_secao = 99). */

INSERT INTO zona_secao (qtd_eleitores, nome_zona_secao, num_zona, num_secao)
VALUES (300, 'Zona Teste', 7, 99);

/* g) Alterar a quantidade de votos, multiplicando por 2, para os candidatos a governador
(código do cargo = 1) e do Partido Democrático (código de partido = 5); */

UPDATE votacao
SET qtd_votos = qtd_votos * 2
WHERE num_candidato IN (
	SELECT num_candidato
	FROM candidato AS c 
	WHERE c.cod_cargo = 1 AND c.cod_partido = 5
);

/* h) Alterar a quantidade de eleitores, somando 100, para as zonas/seções onde ocorreu
votação para candidatos ao Senado (código do cargo = 2); */

UPDATE zona_secao
SET qtd_eleitores = qtd_eleitores + 100
WHERE num_zona IN(
	SELECT v.num_zona
	FROM votacao AS v
	INNER JOIN candidato AS c
	ON (c.num_candidato = v.num_candidato AND c.cod_cargo = 2)) AND
	num_secao IN(
	SELECT v.num_secao
	FROM votacao AS v
	INNER JOIN candidato AS c
	ON (c.num_candidato = v.num_candidato AND c.cod_cargo = 2));

/* i) Apagar todos os cargos que não possuem candidatos; */

DELETE FROM cargo
WHERE cod_cargo NOT IN(
	SELECT can.cod_cargo
	FROM candidato AS can
);

/* j) Apagar as zonas/seções que possuam menos de 1.000 eleitores e que o nome comecem
com a letra “A”; */

DELETE FROM zona_secao
WHERE qtd_eleitores < 1000 AND nome_zona_secao LIKE 'A%';

/* k) Selecionar nome do partido, nome do candidato e nome do cargo, em ordem alfabética
do nome do partido; */

SELECT p.nome_partido, c.nome_candidato, car.nome_cargo
FROM candidato AS c
INNER JOIN partido AS p
ON(p.cod_partido = c.cod_partido)
INNER JOIN cargo AS car
ON(c.cod_cargo = car.cod_cargo)
ORDER BY p.nome_partido ASC;

/* l) Selecionar código e nome do partido, nome do cargo e a quantidade de candidatos por
partido, para cada cargo; */

SELECT car.nome_cargo
FROM cargo AS car

/* m) Selecionar as zonas/seções onde não ocorreu votação; */

/* n) Selecionar número do candidato, nome do candidato, nome do cargo, nome do partido
e quantidade total de votos de cada candidato, apenas para os candidatos que tiveram
uma votação superior 100.000 votos; */

/* o) Selecionar o número do candidato, nome do candidato e a sua média de votos obtidos
nas zonas/seções; */

/* p) Selecionar o código do partido, nome do partido, nome do candidato e a média de
votos obtidos, apenas para os candidatos que tiveram média de votos superior à média
de votos do seu partido. */

INSERT INTO zona_secao VALUES(4,21,'Caja', 254);

SELECT *
FROM zona_secao

INSERT INTO cargo VALUES(1, 'Prefeito');

SELECT *
FROM cargo

INSERT INTO partido VALUES(1,'BO');

SELECT *
FROM partido

INSERT INTO candidato VALUES(13,'Goku',1,1);

SELECT *
FROM candidato

INSERT INTO votacao(qtd_votos, num_zona, num_secao, num_candidato)
	VALUES(354, 5, 21, 13);

UPDATE votacao
SET data_votacao = '21/09/2017'
WHERE num_zona = 5 AND num_secao = 21;

SELECT *
FROM votacao
