-- Created by Vertabelo (http://vertabelo.com)
-- Last modification date: 2017-10-27 01:39:15.5

-- tables
-- Table: aluno
CREATE TABLE aluno (
    matricula int NOT NULL,
    nome varchar(255) NULL,
    endereco varchar(255) NULL,
    telefone varchar(14) NULL,
    curso_cod_curso int NULL,
    CONSTRAINT aluno_pk PRIMARY KEY (matricula)
);

-- Table: avaliacao
CREATE TABLE avaliacao (
    cod_avaliacao int  NOT NULL,
    media_final real NULL,
    aluno_matricula int  NOT NULL,
    semestre_disciplina_id int  NOT NULL,
    CONSTRAINT avaliacao_pk PRIMARY KEY (cod_avaliacao)
);

-- Table: curso
CREATE TABLE curso (
    cod_curso int  NOT NULL,
    descricao varchar(225)  NOT NULL,
    CONSTRAINT curso_pk PRIMARY KEY (cod_curso)
);

-- Table: disciplina
CREATE TABLE disciplina (
    cod_disciplina int  NOT NULL,
    descricao varchar(225)  NOT NULL,
    CONSTRAINT disciplina_pk PRIMARY KEY (cod_disciplina)
);

-- Table: professor
CREATE TABLE professor (
    id int  NOT NULL,
    nome varchar(255)  NOT NULL,
    CONSTRAINT professor_pk PRIMARY KEY (id)
);

-- Table: semestre
CREATE TABLE semestre (
    cod_semestre int  NOT NULL,
    descricao varchar(225)  NOT NULL,
    curso_cod_curso int  NOT NULL,
    CONSTRAINT semestre_pk PRIMARY KEY (cod_semestre)
);

-- Table: semestre_disciplina
CREATE TABLE semestre_disciplina (
    semestre_cod_semestre int  NOT NULL,
    disciplina_cod_disciplina int  NOT NULL,
    id int  NOT NULL,
    professor_id int  NOT NULL,
    CONSTRAINT semestre_disciplina_pk PRIMARY KEY (id)
);

-- foreign keys
-- Reference: aluno_curso (table: aluno)
ALTER TABLE aluno ADD CONSTRAINT aluno_curso
    FOREIGN KEY (curso_cod_curso)
    REFERENCES curso (cod_curso)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: avaliacao_aluno (table: avaliacao)
ALTER TABLE avaliacao ADD CONSTRAINT avaliacao_aluno
    FOREIGN KEY (aluno_matricula)
    REFERENCES aluno (matricula)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: avaliacao_semestre_disciplina (table: avaliacao)
ALTER TABLE avaliacao ADD CONSTRAINT avaliacao_semestre_disciplina
    FOREIGN KEY (semestre_disciplina_id)
    REFERENCES semestre_disciplina (id)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: semestre_curso (table: semestre)
ALTER TABLE semestre ADD CONSTRAINT semestre_curso
    FOREIGN KEY (curso_cod_curso)
    REFERENCES curso (cod_curso)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: semestre_disciplina_disciplina (table: semestre_disciplina)
ALTER TABLE semestre_disciplina ADD CONSTRAINT semestre_disciplina_disciplina
    FOREIGN KEY (disciplina_cod_disciplina)
    REFERENCES disciplina (cod_disciplina)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: semestre_disciplina_professor (table: semestre_disciplina)
ALTER TABLE semestre_disciplina ADD CONSTRAINT semestre_disciplina_professor
    FOREIGN KEY (professor_id)
    REFERENCES professor (id)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: semestre_disciplina_semestre (table: semestre_disciplina)
ALTER TABLE semestre_disciplina ADD CONSTRAINT semestre_disciplina_semestre
    FOREIGN KEY (semestre_cod_semestre)
    REFERENCES semestre (cod_semestre)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- INSERÇÕES

INSERT INTO aluno(matricula, nome)
	VALUES (1, 'Marcos'),(2, 'Joao'), (3, 'Caio'), (4, 'Pedro');

INSERT INTO professor(id, nome)
	VALUES(1, 'Grinaldo'), (2, 'Tiago'), (3, 'Carlos'), (4, 'Marcela');

INSERT INTO disciplina(cod_disciplina, descricao)
	VALUES(1, 'BD'), (2, 'POO'), (3, 'Web'), (4, 'Redes');

INSERT INTO curso(cod_curso, descricao)
	VALUES(1, 'Analise de Sistema'), (2, 'Engenharia');

INSERT INTO semestre(cod_semestre, descricao, curso_cod_curso)
	VALUES(1, 'Primeiro Semestre', 1), (2, 'Segundo Semestre', 1),
	 (3, 'Terceiro Semestre', 1), (4, 'Quarto Semestre', 1), 
	 (5, 'Primeiro Semestre', 2), (6, 'Segundo Semestre', 2),
	 (7, 'Terceiro Semestre', 2), (8, 'Quarto Semestre', 2);

INSERT INTO semestre_disciplina(id, semestre_cod_semestre, disciplina_cod_disciplina, professor_id)
	VALUES(1, 3, 1, 1), (2, 1, 4, 3);


INSERT INTO semestre_disciplina(id, semestre_cod_semestre, disciplina_cod_disciplina, professor_id)
	VALUES(3, 5, 4, 3);

INSERT INTO avaliacao(cod_avaliacao, media_final, aluno_matricula, semestre_disciplina_id)
	VALUES(1, 7.5, 1, 1);

-- a. Escolha uma determinada disciplina e LISTE os cursos as quais ela não pertence.

SELECT descricao
FROM curso
WHERE cod_curso NOT IN(
	SELECT s.curso_cod_curso
	FROM semestre AS s INNER JOIN semestre_disciplina AS sd
		ON(sd.semestre_cod_semestre = s.cod_semestre AND sd.disciplina_cod_disciplina = 1)
);
	
/* b. Escolha uma determinada disciplina de um curso e verifique quais alunos
tiraram a maior média final de todos os tempos. Liste o nome do aluno e o
semestre letivo em que isto ocorreu. */

/* c. Escolha um determinado professor e calcule a média de notas dos alunos
dele por disciplina lecionada. */


-- End of file.