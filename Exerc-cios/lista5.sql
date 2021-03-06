create sequence seq_editora start 1;

create table editora(
   cod_editora int default nextval('seq_editora'),
   descricao varchar (30) null,
   endereco varchar (30) null,
   constraint pk_editora primary key (cod_editora)
);   

insert into editora (descricao, endereco)
  values ('Campus', 'Rua do Timbó'), 
         ('Abril', null),
         ('Editora Teste',null);

create sequence seq_autor start 1;
create table autor(
    cod_autor int default nextval ('seq_autor'),
    nome varchar (45) null,
    sexo char null,
    data_nascimento date null,
    constraint pk_autor primary key (cod_autor)
); 

insert into autor (nome, sexo, data_nascimento)
  values ('João','M','1970/01/01'),
         ('Maria', 'F', '1974/05/17'),
         ('José', 'M', '1977/10/10'),
         ('Carla', 'F', '1964/08/12');

create sequence seq_livro start 1;
create table livro (
    cod_livro int default nextval ('seq_livro'),
    isbn varchar (20) null,
    titulo varchar (45) null,
    num_edicao int null,
    preco float null,
    cod_editora int not null,
    constraint pk_livro primary key (cod_livro),
    constraint fk_livro foreign key (cod_editora)
               references editora (cod_editora)
);

insert into livro 
    (isbn, titulo, num_edicao, preco, cod_editora)
values ('12345','Banco de Dados',3, 70.00, 1),
       ('35790','SGBD',1, 85.00, 2),
       ('98765','Redes de Computadores',2, 80.00,2);

create table livro_autor (
   cod_livro int not null,
   cod_autor int not null,
   constraint pk_livro_autor 
       primary key (cod_livro, cod_autor),
   constraint fk_livro foreign key (cod_livro)
       references livro (cod_livro),
   constraint fk_autor foreign key (cod_autor)
       references autor (cod_autor)
);  

insert into livro_autor (cod_livro, cod_autor)
   values (1,1), (1,2), (2, 2), (2,4) , (3, 3);    

---1. Atualizar o endereço da Editora Campus para ‘Av. ACM’

update editora
set endereco = 'AV. ACM'
where cod_editora = 1;

--2. Atualizar os preços dos livros em 10%

update livro
set preco = preco * 1.1;

--3. Excluir a ‘Editora Teste’

delete from editora
where cod_editora = 3;

--4. Apresentar o nome e data de nascimento de todos os autores

select nome, data_nascimento
from autor

--5. Apresentar o nome e a data de nascimento dos autores 
--por ordem de nome.

select nome, data_nascimento
from autor
order by nome

--6. Apresentar o nome e a data de nascimento dos autores do 
--sexo feminino ordenados pelo nome.

select nome, data_nascimento
from autor
where sexo = 'F'
order by nome;

--7. Apresentar o nome das editoras que não tem o endereço cadastrado.

SELECT descricao
FROM editora 
WHERE endereco is NULL;

--8. Apresentar o título do livro e o nome da sua editora

-- Primeira forma de JOIN
SELECT l.titulo, e.descricao
FROM livro AS l, editora AS e
WHERE l.cod_editora = e.cod_editora;
-- Segunda forma de JOIN
SELECT l.titulo, e.descricao
FROM livro AS l INNER JOIN editora as e
	ON (l.cod_editora = e.cod_editora);
  

--9. Apresentar o título do livro e o nome da sua editora. Caso haja alguma
editora sem livro publicado, informar os dados da editora com valores
nulos para os livros.

SELECT l.titulo, e.descricao
FROM livro AS l RIGHT JOIN editora AS e
	ON (l.cod_editora = e.cod_editora)

-- 10. Apresentar o título do livro e o nome dos seus autores

SELECT l.titulo, a.nome
FROM livro AS l INNER JOIN livro_autor AS la
	ON (l.cod_livro = la.cod_livro)
	INNER JOIN autor as a
	ON (la.cod_autor = a.cod_autor)

-- 11. Apresentar o nome da editora e o nome dos autores que já publicaram
algum livro na editora.

SELECT e.descricao, a.nome
FROM livro AS l INNER JOIN editora AS e
	ON(l.cod_editora = e.cod_editora)
	INNER JOIN livro_autor AS la
	ON(l.cod_livro = la.cod_livro)
	INNER JOIN AUTOR AS a
	ON(la.cod_autor = a.cod_autor);
	

-- 12. Apresentar o título dos livros que começam a string ‘Banco’.

SELECT l.titulo
FROM livro as l
WHERE l.titulo LIKE 'Banco%';

-- 13. Apresentar o título dos livros que tem a string ‘do’.

SELECT l.titulo
FROM livro as l
WHERE l.titulo LIKE '%do%';

-- 14. Apresentar o nome de cada livro e seu preço reajustado em 5%

SELECT l.titulo, l.preco * 1.05 as preco_reajustado
FROM livro as l;


-- 15. Apresentar o nome dos autores que nasceram no mês de outubro

SELECT nome
FROM autor
WHERE extract(MONTH FROM data_nascimento) = 10;

-- 16. Apresentar o número de livros do acervo

SELECT  COUNT(*) AS qtde_livro
FROM livro

-- 17. Apresentar o número de autores do livro ‘Banco de Dados’

SELECT COUNT(*) as qtde_autor
FROM livro_autor
WHERE cod_livro = 1;

-- 18. Apresentar o somatório dos preços dos livros do acervo

SELECT SUM(preco) AS soma_total
FROM livro;

-- 19. Apresentar a média de preços dos livros da editora Campus

SELECT AVG(preco)
FROM livro
WHERE cod_editora = 1;

-- 20. Apresentar o maior preço dentre todos os livros do acervo.

SELECT MAX(preco)
FROM livro

SELECT *
FROM livro
WHERE preco IN (
	SELECT MAX(preco)
	FROM livro
);

-- 21. Apresentar a data de nascimento do autor mais velho

SELECT data_nascimento
FROM autor
WHERE data_nascimento IN(
	SELECT MIN(data_nascimento)
	FROM autor
);


-- 22. Apresentar o número de livros por editora

SELECT e.descricao, COUNT(*) qtde_livro
FROM editora AS e INNER JOIN livro AS l
	ON(e.cod_editora = l.cod_editora)
GROUP BY e.cod_editora;

-- 23. Apresentar o somatório e média de preço dos livros por editora

SELECT e.descricao, SUM(l.preco) AS somatorio_precos, AVG(l.preco) AS media_precos
FROM editora AS e INNER JOIN livro AS l
	ON(e.cod_editora = l.cod_editora)
GROUP BY e.cod_editora;


-- 24. Apresentar o número de autores por livro, mas apenas dos livros que possuem mais de 1 autor

SELECT l.titulo, COUNT(*) as qtde_autor
FROM livro AS l INNER JOIN livro_autor AS la
	ON(l.cod_livro = la.cod_livro)
GROUP BY l.cod_livro
HAVING COUNT(*) > 1;


-- 25. Apresentar a média de preços geral por editora, mas apenas as editoras que possuem média maior que R$ 80,00

SELECT e.descricao, AVG(l.preco) AS media 
FROM editora AS e INNER JOIN livro as l
	ON(e.cod_editora = l.cod_editora)
GROUP BY e.cod_editora
HAVING AVG(l.preco) > 80;

-- 26. Apresentar o nome dos autores que não são autores do livro Banco de Dados

SELECT nome
FROM autor
WHERE cod_autor NOT IN(
	SELECT cod_autor
	FROM livro_autor
	WHERE cod_livro = 1
);

SELECT nome
FROM autor as a
WHERE NOT EXISTS(
	SELECT *
	FROM livro_autor as la
	WHERE la.cod_auor = a.cod_autor
	AND la.cod_livro = 1
);

SELECT nome
FROM autor AS a LEFT JOIN livro_autor as la
	ON(a.cod_autor = la.cod_autor AND cod_livro = 1)
WHERE cod_livro IS NULL

-- 27. Apresentar a quantidade de livros da editora Campus e Abril em colunas diferentes.

SELECT SUM(campus) AS campus, SUM(abril) AS abril
FROM(
	SELECT COUNT(*) AS campus, 0 AS abril
	FROM editora AS e INNER JOIN livro AS l
		ON(e.cod_editora = l.cod_editora)
	WHERE e.cod_editora = 1
	GROUP BY e.cod_editora
	UNION
	SELECT 0, COUNT(*) AS abril
	FROM editora AS e INNER JOIN livro AS l
		ON(e.cod_editora = l.cod_editora)
	WHERE e.cod_editora = 2
	GROUP BY e.cod_editora) AS tabela
