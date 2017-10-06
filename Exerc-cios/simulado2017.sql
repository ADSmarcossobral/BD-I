CREATE TABLE time(
	tim_oid INT NOT NULL,
	tim_nome varchar(30),
	CONSTRAINT pk_tim_oid PRIMARY KEY (tim_oid)
);

CREATE TABLE jogador(
	jog_oid INT NOT NULL,
	jog_nome varchar(30),
	jog_gols INT,
	tim_oid INT NOT NULL,
	CONSTRAINT pk_jog_oid PRIMARY KEY (jog_oid),
	CONSTRAINT fk_tim_oid FOREIGN KEY (tim_oid) REFERENCES time(tim_oid)
);

CREATE TABLE campeonato(
	cam_oid INT NOT NULL,
	cam_nome varchar(30),
	cam_estado char(1),
	cam_ano INT,
	cam_num_jogos INT,
	CONSTRAINT pk_cam_oid PRIMARY KEY (cam_oid)
);

CREATE TABLE campeonato_time(
	cat_oid INT NOT NULL,
	cam_oid INT NOT NULL,
	tim_oid INT NOT NULL,
	CONSTRAINT pk_cat_oid PRIMARY KEY (cat_oid),
	CONSTRAINT fk_cam_oid FOREIGN KEY (cam_oid) REFERENCES campeonato (cam_oid),
	CONSTRAINT fk_tim_oid FOREIGN KEY (tim_oid) REFERENCES time (tim_oid)
);

INSERT INTO time(tim_oid, tim_nome)
	VALUES (1, 'BAHIA'), (2, 'VITORIA'), (3, 'FLAMENGO'), (4, 'PALMEIRAS'), (5, 'JUVENTUDE');

INSERT INTO jogador(jog_oid, jog_nome, jog_gols, tim_oid)
	VALUES (1, 'BOBO', 46, 1), (2, 'VALDOMIRO', 4, 1), (3, 'VAMPETA', 14, 2), (4, 'ZICO', 56, 2),
		(5, 'CEREZO', 500, 3), (6, 'ZANATA', 500, 5);

INSERT INTO campeonato(cam_oid, cam_nome, cam_estado, cam_ano, cam_num_jogos)
	VALUES (1, 'PRIMEIRA DIVISAO', 'A', 2006, 10), (2, 'SEGUNDA DIVISAO', 'A', 2005, 23),
		(3, 'PRIMEIRA DIVISAO', 'F', 2003, 29), (4, 'COPA DO BRASIL', 'A', 2004, 34),
		(5, 'COPA DO BRASIL', 'B', 2007, 15), (6, 'COPA DO BRASIL', 'C', 2016, 21);

INSERT INTO campeonato_time(cat_oid, cam_oid, tim_oid)
	VALUES (1,1,2), (2,2,1), (3,3,1), (4,3,2), (5,4,2), (6,5,3), (7,6,4);

/* a) Selecione o time que não possui nenhum jogador cadastrado. */

SELECT t.tim_nome
FROM time AS t
WHERE t.tim_oid NOT IN(
	SELECT t.tim_oid
	FROM time AS t INNER JOIN jogador AS j
		ON(t.tim_oid = j.tim_oid)
);

/* b) Selecione o jogador que não participou de qualquer campeonato. */

SELECT j.jog_nome
FROM jogador AS j
WHERE j.tim_oid NOT IN(
	SELECT t.tim_oid
	FROM time AS t INNER JOIN campeonato_time AS ct
		ON(t.tim_oid = ct.tim_oid)
);

/* c) Selecione os jogadores que participaram de pelo menos 3 (três) campeonatos. */

SELECT j.jog_nome
FROM jogador AS j
WHERE j.jog_oid IN(
	SELECT j.jog_oid
	FROM jogador AS j
	WHERE j.tim_oid IN(
		SELECT tim_oid
		FROM campeonato_time
		GROUP BY tim_oid
		HAVING COUNT(tim_oid) > 2
	)
);

/* d) Selecione o (s) jogador (es) que mais fizeram gols. */

SELECT j.jog_nome
FROM jogador AS j
WHERE j.jog_gols IN(
	SELECT max(jog_gols)
	FROM jogador AS j
);

/* e) Selecione os jogadores e a soma do número de jogos dos campeonatos de
2004 a 2007 que ele participou. */

SELECT jogador.jog_nome, SUM(c.cam_num_jogos)
FROM jogador INNER JOIN time ON(time.tim_oid = jogador.tim_oid)
	INNER JOIN campeonato_time AS ct ON(ct.tim_oid = time.tim_oid)
	INNER JOIN campeonato AS c ON(c.cam_oid = ct.cam_oid)
WHERE c.cam_ano BETWEEN 2004 AND 2007
GROUP BY jogador.jog_nome;

/* f) Selecione os jogadores que participaram de dois campeonatos apenas e
tenham feito menos que 10 gols. */ 

SELECT j.jog_nome
FROM jogador AS j
WHERE j.tim_oid IN(
	SELECT tim_oid
	FROM time
	WHERE tim_oid IN(
		SELECT tim_oid
		FROM campeonato_time
		GROUP BY tim_oid
		HAVING COUNT(tim_oid) = 2
	)
) AND j.jog_gols < 10;

/* g) Apague o jogador cujo time possua a letra 'e' e tenha participado APENAS de
um campeonato. */

DELETE FROM jogador AS j
WHERE j.tim_oid IN(
	SELECT tim_oid
	FROM time
	WHERE tim_nome LIKE '%E%' AND tim_oid IN(
		SELECT tim_oid
		FROM campeonato_time
		GROUP BY tim_oid
		HAVING COUNT(tim_oid) = 1
	)
);

/* h) Altere para o nome ‘Grinaldo’ o jogador que participe de um time que tenha
participado de um campeonato com pelo menos 30 jogos. */

UPDATE jogador
SET jog_nome = 'Grinaldo'
WHERE tim_oid IN(
	SELECT ct.tim_oid
	FROM campeonato_time AS ct
	WHERE (
		SELECT cam_oid
		FROM campeonato
		WHERE cam_num_jogos >= 30) = ct.cam_oid);