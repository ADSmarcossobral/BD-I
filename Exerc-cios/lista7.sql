CREATE TABLE jobs(
	job_id INT NOT NULL,
	job_desc varchar(30),
	CONSTRAINT pk_job_id PRIMARY KEY (job_id)
);

CREATE TABLE publishers(
	pub_id INT NOT NULL,
	pub_name VARCHAR(30) NULL,
	city VARCHAR(30),
	state VARCHAR(30),
	country VARCHAR(30),
	CONSTRAINT pk_pub_id PRIMARY KEY (pub_id)
);

CREATE TABLE titles(
	title_id INT NOT NULL,
	title VARCHAR(30),
	type VARCHAR(30),
	price FLOAT,
	pubdate DATE,
	pub_id INT NOT NULL,
	CONSTRAINT pk_title_id PRIMARY KEY (title_id),
	CONSTRAINT fk_pub_id FOREIGN KEY (pub_id) REFERENCES publishers (pub_id)
);

CREATE TABLE employee(
	emp_id INT NOT NULL,
	fname VARCHAR(30),
	minit VARCHAR(30),
	lname VARCHAR(30),
	job_id INT NOT NULL,
	pub_id INT NOT NULL,
	CONSTRAINT pk_emp_id PRIMARY KEY (emp_id),
	CONSTRAINT fk_job_id FOREIGN KEY (job_id) REFERENCES jobs (job_id),
	CONSTRAINT fk_pub_id FOREIGN KEY (pub_id) REFERENCES publishers (pub_id)
);

CREATE TABLE authors(
	au_id INT NOT NULL,
	au_lname VARCHAR(30),
	au_fname VARCHAR(30),
	phone VARCHAR(12),
	address VARCHAR(30),
	city VARCHAR(30),
	state VARCHAR(30),
	zip VARCHAR(30),
	CONSTRAINT pk_au_id PRIMARY KEY (au_id)
);

CREATE TABLE titleauthor(
	title_id INT NOT NULL,
	au_id INT NOT NULL,
	CONSTRAINT fk_title_id FOREIGN KEY (title_id) REFERENCES titles (title_id),
	CONSTRAINT fk_au_id FOREIGN KEY (au_id) REFERENCES authors (au_id)
);

CREATE TABLE stores(
	stor_id INT NOT NULL,
	stor_name VARCHAR(30),
	stor_address VARCHAR(30),
	city VARCHAR(30),
	state VARCHAR(30),
	ZIP VARCHAR(30),
	CONSTRAINT pk_stor_id PRIMARY KEY (stor_id)
);


CREATE TABLE sales(
	stor_id INT NOT NULL,
	ord_num INT,
	ord_date DATE,
	qty INT,
	title_id INT NOT NULL,
	payterms VARCHAR(30),
	CONSTRAINT fk_stor_id FOREIGN KEY (stor_id) REFERENCES stores (stor_id),
	CONSTRAINT fk_title_id FOREIGN KEY (title_id) REFERENCES titles (title_id)
);

INSERT INTO authors(au_id, au_lname, au_fname)
	VALUES(1, 'Sobral', 'Marcos'), (2, 'Jordao', 'Caio');

UPDATE authors
SET city = 'Oakland'
WHERE au_id = 1;

INSERT INTO publishers(pub_id, pub_name, city, state, country)
	VALUES(1, 'AC', 'Salvado', 'Bahia', 'Brasil');

INSERT INTO publishers(pub_id, pub_name, city, state, country)
	VALUES(4, '2W', 'São Paulo', 'São Paulo', 'Brasil');

INSERT INTO titles(title_id, title, type, price, pubdate, pub_id)
	VALUES(1, 'Sorvete de Chocolate', 'E-Book', 29.90, '23/01/1994', 1),
		(2, 'Frases de Amor', 'Fisico', 19.90, '12/12/2012', 1);

INSERT INTO titleauthor(title_id, au_id)
	VALUES(1,1), (2,2);

INSERT INTO titleauthor(title_id, au_id)
	VALUES(2,1);

INSERT INTO jobs(job_id, job_desc)
	VALUES(1, 'Programador'), (2, 'Designer'), (3, 'DBA');

INSERT INTO employee(emp_id, job_id, pub_id, fname, minit, lname)
	VALUES(1, 2, 1, 'Jose', 'Maria', 'Cabral'), (2, 1, 1, 'Robert', 'Greco', 'Romano');

INSERT INTO publishers(pub_id, pub_name, city, state, country)
	VALUES(2, 'Hotel', 'Feira de Santana', 'Bahia', 'Brasil');

INSERT INTO publishers(pub_id, pub_name, city, state, country)
	VALUES(3, 'BT', 'Boston', 'Massachusetts', 'EUA');

INSERT INTO titles(title_id, title, type, price, pubdate, pub_id)
	VALUES(3, 'Computer Science', 'E-Book', 39.90, '21/01/2000', 3),
		(4, 'Estrelar', 'E-Book', 69.90, '12/12/2017', 2);

INSERT INTO stores(stor_id, stor_name, stor_address, city, state, zip)
	VALUES(1, 'Saraiva', 'Rua Estrela', 'Salvador', 'Bahia', '40280-920'),
		(2, 'Cultura', 'Rua Solar', 'Belo Horizonte', 'Minas Gerais', '40732-922');

INSERT INTO stores(stor_id, stor_name, stor_address, city, state, zip)
	VALUES(3, 'Sub Read', 'Rua Canela Seca', 'City Two', 'CA', '90726');

INSERT INTO sales(stor_id, ord_num, ord_date, qty, title_id, payterms)
	VALUES(2, 1, '06/10/2017', 4, 1, 'Cash'), (1, 2, '06/10/2017', 10, 1, 'Cash'), 
	(2, 3, '06/10/2017', 12, 2, 'Credit');
	
/* a) Selecionar todas as informações sobre todos os autores (authors);  */

SELECT *
FROM authors;

/* b) Selecionar o código, primeiro nome e último nome de todos os autores (authors) em
ordem alfabética pelo último nome (au_lname);  */

SELECT au_id, au_fname, au_lname
FROM authors 
ORDER BY au_lname ASC;

/* c) Selecionar todas as informações sobre todos os autores (authors) da cidade "Oakland"; */

SELECT *
FROM authors
WHERE city LIKE 'Oakland';

/* d) Selecionar o código, título e preço dos livros (titles) em ordem decrescente de preço; */

SELECT title_id, title, price
FROM titles
ORDER BY price DESC;

/* e) Selecionar o código, título e preço dos livros (titles) cujo preço é superior a $15;  */

SELECT title_id, title, price
FROM titles
WHERE price > 15;

/* f) Selecionar o código e título dos livros (titles), primeiro e último nome dos seus
respectivos autores (authors); */

SELECT t.title_id, t.title, a.au_fname, a.au_lname
FROM titles AS t INNER JOIN titleauthor AS ta
	ON(t.title_id = ta.title_id) INNER JOIN authors AS a
	ON(ta.au_id = a.au_id);

/* g) Selecionar o código e título dos livros e quantidade de autores de cada livro (titles); */

SELECT t.title_id, t.title, COUNT(ta.au_id) AS Autores
FROM titles AS t INNER JOIN titleauthor AS ta
	ON(t.title_id = ta.title_id)
GROUP BY t.title_id;

/* h) Selecionar o código e título dos livros (titles) que foram escritos por mais de 2 autores;  */

SELECT t.title_id, t.title
FROM titles AS t
WHERE t.title_id IN(
	SELECT title_id
	FROM titleauthor
	GROUP BY title_id
	HAVING COUNT(title_id) > 2
);

/* i) Selecionar o primeiro nome (fname), inicial do nome do meio (minit) e o último nome
(lname) dos empregados (employee); */

SELECT fname, substr(minit, 1,1), lname
FROM employee;

/* j) Selecionar o código e a descrição dos cargos (jobs);  */

SELECT job_id, job_desc
FROM jobs;

/* k) Selecionar o primeiro nome, inicial do nome do meio, ultimo nome dos empregados
(employee) e a descrição do seu respectivo cargo (jobs);  */

SELECT fname, substr(minit,1,1), lname, job_desc
FROM employee INNER JOIN jobs
	ON(employee.job_id = jobs.job_id);

/* l) Selecionar o código, nome e a cidade das editoras (publishers), ordenado pelo nome; */

SELECT pub_id, pub_name, city
FROM publishers
ORDER BY pub_name ASC;

/* m) Selecionar o código e título do livro (titles), código e nome da respectiva editora
(publishers); */

SELECT t.title_id, t.title, p.pub_id, p.pub_name
FROM titles AS t INNER JOIN publishers AS p
	ON(t.pub_id = p.pub_id);

/* n) Selecionar o código e título do livro (titles), código e nome da respectiva editora
(publishers), cuja editora se localiza na cidade de “Boston”; */

SELECT t.title_id, t.title, p.pub_id, p.pub_name
FROM titles AS t INNER JOIN publishers AS p
	ON(p.pub_id = t.pub_id AND p.city LIKE 'Boston');

/* o) Selecionar o nome, endereço e cidade das lojas (stores) do estado "CA";  */

SELECT stor_name, stor_address, city
FROM stores
WHERE state LIKE 'CA';

/* p) Selecionar código livro, titulo e a quantidade total de livros vendidos, em ordem
decrescente da quantidade total de livros vendidos; */

SELECT t.title_id, t.title, SUM(s.qty)
FROM titles AS t INNER JOIN sales AS s
	ON(t.title_id = s.title_id)
GROUP BY t.title_id
ORDER BY SUM(s.qty) DESC;

/* q) Selecionar código livro, titulo do livro, código e nome da loja (stores) e a quantidade
total de livros vendidos pela loja (nas diversa vendas realizadas), em ordem
decrescente da quantidade de livros vendidos;  */

SELECT t.title_id, t.title, st.stor_id, st.stor_name, SUM(sa.qty)
FROM titles AS t INNER JOIN sales AS sa
	ON(t.title_id = sa.title_id) INNER JOIN stores AS st
	ON(sa.stor_id = st.stor_id)
GROUP BY st.stor_id, t.title_id
ORDER BY SUM(sa.qty) DESC;

/* r) Selecionar o código e nome da loja (stores), e a sua respectiva média de livros
vendidos; */

SELECT st.stor_id, st.stor_name, AVG(sa.qty)
FROM stores AS st INNER JOIN sales AS sa
	on(st.stor_id = sa.stor_id)
GROUP BY st.stor_id;

/* s) Selecionar os livros (titles) que nunca foram vendidos;  */

SELECT title
FROM titles
WHERE title_id NOT IN(
	SELECT title_id
	FROM sales
);


/* t) Selecionar as editoras (publishers) que não editaram nenhum livro.  */

SELECT pub_name 
FROM publishers
WHERE pub_id NOT IN(
	SELECT pub_id
	FROM titles
);
