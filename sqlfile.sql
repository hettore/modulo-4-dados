CREATE DATABASE ubs; /*  Comando para criar o banco de dados  */

USE ubs; /*  Comando para usar/selecionar o banco de dados  */

CREATE TABLE ubs_uf (
codigo_uf INT PRIMARY KEY NOT NULL,
unidade_da_federacao VARCHAR(50) NOT NULL,
uf CHAR(2) NOT NULL
); /*  Comando para criar uma tabela já incluindo o título da coluna obs: tabela ainda sem conteúdo  */

INSERT INTO ubs_uf (
codigo_uf,
unidade_da_federacao,
uf) VALUES (52, 'Goiás', 'GO'); 
/* Comando para inserir dados manualmente, necessário informar o título da coluna e depois passar os valores */

UPDATE ubs_uf SET uf='SP' WHERE codigo_uf=35; 
/*  Comando para atualizar um registro especifico usando o WHERE  */

SELECT * FROM ubs_uf; /*  Comando para mostrar todo o conteúdo de uma tabela  */

SELECT * FROM data_ubs; /*  Comando para mostrar todo o conteúdo de uma tabela  */

SELECT COUNT(*) as TOTAL_DE_LINHAS FROM ubs_uf; /*  Comando para contar a  quantidade de linhas dentro de uma tabela  */

SELECT COUNT(*) as TOTAL_DE_LINHAS FROM data_ubs; /*  Comando para contar a  quantidade de linhas dentro de uma tabela  */

truncate table ubs_uf; /*  Comando para apagar todo o conteúdo de uma tabela  */

TRUNCATE TABLE data_ubs;
/* Apaga todas as linhas de uma tabela */

DROP TABLE data_ubs; 
/*  Comando para apagar uma tabela inteira  */

ALTER DATABASE ubs DEFAULT CHARACTER SET utf8mb4 COLLATE utf8_general_ci; /*  Comando para mudar o encoding  */
 
SELECT * FROM ubs_uf where unidade_da_federacao = 'Rondônia'; 

DELETE FROM ubs_uf WHERE codigo_uf='52'; 
/*  Comando para apagar uma linha que tenha um conteúdo especifico usando o where  */

CREATE TABLE data_ubs (
CNES INT PRIMARY KEY NOT NULL,
UF INT NOT NULL,
IBGE INT NOT NULL,
NOME VARCHAR(100) NOT NULL,
LOGRADOURO VARCHAR(100) NOT NULL,
BAIRRO VARCHAR(60) NOT NULL,
LATITUDE VARCHAR(100) NOT NULL,
LONGITUDE VARCHAR(100) NOT NULL
);

CREATE TABLE data_municipios (
UF_MUNICIPIO VARCHAR(100) NOT NULL,
IBGE INT PRIMARY KEY NOT NULL,
IBGE7 INT NOT NULL,
UF CHAR(2) NOT NULL,
MUNICIPIO VARCHAR(100) NOT NULL,
REGIAO VARCHAR(50) NOT NULL,
POPULACAO_2010 LONG NOT NULL,
PORTE VARCHAR(50) NOT NULL,
CAPITAL VARCHAR(30)
);

SELECT * FROM data_municipios; 

TRUNCATE data_municipios;

/* 
Atividade - 1

Manipulação e validação de hipóteses
Com os dados disponibilizados na base de dados em MySQL, a equipe deve validar as seguintes hipóteses:

O estado de São Paulo (SP) possui um número de UBSs maior que o
somatório de todas as UBSs dos estados da região nordeste.
R:  Falso.
Estados do nordeste -
Maranhão, São Luís; Piauí, Teresina; Ceará, Fortaleza; Rio Grande do Norte, Natal; Paraíba, João Pessoa; Pernambuco, Recife; Alagoas, Maceió; Sergipe, Aracaju; e Bahia, Salvador
São paulo = 5031 unidades;
nordeste = 15463 unidades.
*/
SELECT * FROM ubs_uf; /*  Mostrar os estados e seus respectivos códigos sendo sp=35 e estados do nordeste de 21 à 29*/

SELECT COUNT(*) AS TOTAL_UBS_SP FROM data_ubs WHERE UF=35; 
/*  Faz a contagem de quantas linhas cadastradas que tenham uf=35 (São Paulo)  */

SELECT COUNT(*) AS TOTAL_UBS_NORDESTE FROM data_ubs WHERE uf BETWEEN 21 AND 29; 
/*  Faz a contagem de todas as linhas cadastradas que tenham uf=21;22;23;24;25;26;27;28 e 29  */

/*  testes  */
SELECT uf.uf AS Estado_ou_Região, count(dt.CNES) AS Total_UBS
FROM data_ubs AS dt
INNER JOIN ubs_uf AS uf
ON uf.codigo_uf = dt.uf
WHERE uf.uf = 'sp'
UNION
SELECT 'Nordeste', SUM(Total_UBS) FROM (SELECT uf.uf, count(dt.CNES) AS Total_UBS
FROM data_ubs AS dt
INNER JOIN ubs_uf AS uf
ON uf.codigo_uf = dt.uf
WHERE dt.uf BETWEEN 21 AND 29
group by UF) AS Q;

/*
A maioria das UBSs, nos respectivos estados, estão localizados nas
regiões centrais das cidades (use como base os bairros intitulados
como CENTRO).
R: Falso.
uf=11 - rondonia - centro=41, total=281 
uf=12 - Acre - centro=27, total= 228
*/

SELECT uf AS Estado, COUNT(*) AS total_ubs_centro FROM data_ubs WHERE UF = 11 AND bairro = 'centro';
/* Consulta a sigla do estado e retorna com a condição de ser 11 que é Rondônia e ser bairro centro */

SELECT uf AS CODIGO_UF, COUNT(*) AS total_ubs_estado FROM data_ubs WHERE UF = 11;
/* Consulta a sigla do estado e retorna o total de ubs do estado */

SELECT COUNT(*) AS qtd_ubs_centro FROM data_ubs WHERE UF = 12 AND bairro = 'centro';
SELECT COUNT(*) FROM data_ubs WHERE UF = 12;

SELECT UF, count(UF) AS quantidade_ubs FROM data_ubs group by UF;

SELECT UF, count(UF) AS quantidade_ubs FROM data_ubs group by UF
UNION
SELECT UF, count(BAIRRO) AS quantidade_ubs_centro FROM data_ubs WHERE BAIRRO='CENTRO' group by UF order by UF;

/*  Da certo com o total!  */
SELECT data_ubs.uf AS UF, ubs_uf.unidade_da_federacao AS ESTADO,
       (SELECT COUNT(CNES)
        FROM data_ubs
        WHERE data_ubs.bairro = "centro" AND data_ubs.uf = ubs_uf.codigo_uf) AS UBS_CENTRO,
       COUNT(data_ubs.CNES) AS UBS_MENOS_CENTRO,
       (SELECT COUNT(CNES)
        FROM data_ubs
        WHERE data_ubs.uf = ubs_uf.codigo_uf) AS TOTAL_UBS
FROM data_ubs
INNER JOIN ubs_uf ON data_ubs.uf = ubs_uf.codigo_uf
WHERE data_ubs.bairro <> "centro"
GROUP BY data_ubs.uf, ubs_uf.codigo_uf;

ALTER TABLE ubs_uf ADD PRIMARY KEY (codigo_uf);
/*  Comando para adicionar um campo como chave primária  */

ALTER TABLE ubs_uf 
CHANGE uf CIDADE int;
/* Comando para alterar o nome e o tipo de dado */

ALTER TABLE ubs_uf
RENAME COLUMN codigo_uf TO codigo_uff;
/* Comando para renomear o nome da coluna */

/*
sum TOTAL_UBS_CENTRO (case when bairro = 'centro' then 0 else 1 end)

DESAFIO: Observe nos dados das UBSs que existe uma coluna intitulada “IBGE”. Crie
um relatório que liste todas as UBS de um respectivo município/distrito/subdistrito.
R:
DICA: Observe como são estruturados os dados que descrevem os municípios/distrito/subdistritos elencados pelo IBGE. */

SELECT * FROM data_ubs; /*  Comando para mostrar todo o conteúdo de uma tabela  */

SELECT uf.uf as Estado, dt.IBGE as Cod_cidade, dt.NOME as Nome_da_UBS
FROM data_ubs AS dt
INNER JOIN ubs_uf AS uf
ON uf.codigo_uf = dt.uf
WHERE dt.IBGE = 355620;

 /* cod valinhos = 355620 
 Baixei uma lista q envolve o numero do ibge e nome do municipio */ 

SELECT du.UF AS Cod_Estado, du.IBGE AS Cod_IBGE_cidade, dt.MUNICIPIO AS CIDADE, du.CNES AS CNES, du.NOME
FROM data_municipios AS dt
INNER JOIN data_ubs AS du
ON dt.IBGE = du.IBGE
WHERE dt.MUNICIPIO = 'maragogipe';

SELECT * FROM data_municipios;

/* 
DDL - Data Definition Language - Linguagem de Definição de Dados.
São os comandos que interagem com os objetos do banco.
São comandos DDL : CREATE, ALTER e DROP

DML - Data Manipulation Language - Linguagem de Manipulação de Dados.
São os comandos que interagem com os dados dentro das tabelas.
São comandos DML : INSERT, DELETE e UPDATE
 */