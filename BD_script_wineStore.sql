CREATE DATABASE WineStore
GO
USE WineSTore
GO
/*** Cria��o da tabela categoria ***/

CREATE TABLE CATEGORIA (
	idCATEGORIA		SMALLINT		NOT NULL,
	nome			VARCHAR(255)	NOT NULL,
	CONSTRAINT PK_categoria			PRIMARY KEY (idCATEGORIA),
	CONSTRAINT AK_categoria_nome	UNIQUE(nome)
)

/*** Cria��o da tabela  PAIS ***/

CREATE TABLE PAIS(
	idPAIS			SMALLINT		NOT NULL,
	nome			VARCHAR(255)	NOT NULL,
	CONSTRAINT PK_pais				PRIMARY KEY (idPAIS),
	CONSTRAINT AK_pais_nome			UNIQUE(nome)
)

/*** Cria��o da tabela  REGIAO ***/

CREATE TABLE REGIAO(
	idREGIAO			SMALLINT		NOT NULL,
	nome				VARCHAR(255)	NOT NULL,
	idPAIS				SMALLINT		NOT NULL,
	CONSTRAINT PK_regiao				PRIMARY KEY (idREGIAO),
	CONSTRAINT AK_regiao_nome			UNIQUE(nome),
	CONSTRAINT FK_regiao_pais			FOREIGN KEY (idPAIS) REFERENCES PAIS
)

/*** Cria��o da tabela  PRODUTOR ***/

CREATE TABLE PRODUTOR(
	idPRODUTOR			SMALLINT		NOT NULL,
	nome				VARCHAR(255)	NOT NULL,
	telefone			VARCHAR(255)	NOT NULL,
	idREGIAO			SMALLINT		NOT NULL,
	CONSTRAINT PK_produtor				PRIMARY KEY (idPRODUTOR),
	CONSTRAINT AK_produtor_nome			UNIQUE(nome),
	CONSTRAINT AK_produtor_telefone		UNIQUE(telefone),
	CONSTRAINT FK_produtor_regiao		FOREIGN KEY(idREGIAO) REFERENCES REGIAO
)

/*** Cria��o da tabela  ROTULO ***/

CREATE TABLE ROTULO(	
	idROTULO				SMALLINT		NOT NULL,
	nome					VARCHAR(255)	NOT NULL,
	descricao				VARCHAR(255)	NOT NULL,
	percentual_alcoolico	DECIMAL(5,2)	NOT NULL,
	preco					DECIMAL(8,2)	NOT NULL,
	ano_producao			INT				NOT NULL,
	idCATEGORIA				SMALLINT		NOT NULL,
	idPRODUTOR				SMALLINT		NOT NULL,

	CONSTRAINT PK_rotulo				PRIMARY KEY (idROTULO),
	CONSTRAINT AK_rotulo_nome			UNIQUE(nome),
	CONSTRAINT PK_rotulo_categoria		FOREIGN KEY(idCATEGORIA) REFERENCES CATEGORIA,
	CONSTRAINT FK_rotulo_produtor		FOREIGN KEY(idPRODUTOR) REFERENCES PRODUTOR
)

/*** Cria��o da tabela  VINICOLA ***/

CREATE TABLE VINICOLA(	
	idPRODUTOR				SMALLINT		NOT NULL,
	nome					VARCHAR(255)	NOT NULL,
	rua						VARCHAR(45)		NOT NULL,
	bairro					VARCHAR(45)		NOT NULL,
	cep						VARCHAR(45)		NOT NULL,

	CONSTRAINT PK_vinicola					PRIMARY KEY(idPRODUTOR,nome),
	CONSTRAINT AK_vinicola_nome				UNIQUE(nome),
	CONSTRAINT FK_vinicola_produtor			FOREIGN KEY(idPRODUTOR) REFERENCES PRODUTOR
)

/*** Cria��o da tabela  CIDADE ***/

CREATE TABLE CIDADE(	
	idCIDADE				SMALLINT		NOT NULL,
	nome					VARCHAR(255)	NOT NULL,
	idPAIS					SMALLINT		NOT NULL,

	CONSTRAINT PK_cidade				PRIMARY KEY(idCIDADE),
	CONSTRAINT AK_cidade_nome			UNIQUE(nome),
	CONSTRAINT FK_cidade_pais			FOREIGN KEY(idPAIS) REFERENCES PAIS
)

/*** Cria��o da tabela LOJA ***/

CREATE TABLE LOJA(	
	idLOJA					SMALLINT		NOT NULL,
	nome					VARCHAR(255)	NOT NULL,
	telefone				VARCHAR(45)		NULL,
	email					VARCHAR(45)		NULL,
	idCIDADE				SMALLINT		NOT NULL,

	CONSTRAINT PK_loja						PRIMARY KEY(idLOJA),
	CONSTRAINT AK_loja_nome					UNIQUE(nome),
	CONSTRAINT FK_loja_cidade				FOREIGN KEY(idCIDADE) REFERENCES CIDADE
)

/*** Cria��o da tabela ESTOQUE ***/

CREATE TABLE ESTOQUE(	
	idLOJA					SMALLINT		NOT NULL,
	idROTULO				SMALLINT		NOT NULL,
	quantidade				INT				NOT NULL,

	CONSTRAINT PK_estoque					PRIMARY KEY(idLOJA, idROTULO),
	CONSTRAINT FK_estoque_rotulo			FOREIGN KEY(idROTULO) REFERENCES ROTULO,
	CONSTRAINT FK_estoque_loja				FOREIGN KEY(idLOJA) REFERENCES LOJA,
	CONSTRAINT CK_quantidade				CHECK(quantidade >= 0)
)

/*** Cria��o da tabela DISTRIBUIDOR ***/

CREATE TABLE DISTRIBUIDOR(	
	idDISTRIBUIDOR			SMALLINT		NOT NULL,
	nome					VARCHAR(255)	NOT NULL,
	telefone				VARCHAR(45)		NULL,

	CONSTRAINT PK_distribuidor				PRIMARY KEY(idDISTRIBUIDOR),
	CONSTRAINT AK_distribuidor_nome			UNIQUE(nome),
	CONSTRAINT AK_distribuidor_telefone		UNIQUE(telefone),
)

/*** Cria��o da tabela PEDIDO ***/

CREATE TABLE PEDIDO(
	idPEDIDO			SMALLINT			IDENTITY(1,1) NOT NULL,	
	data				DATE				NOT NULL,
	idDISTRIBUIDOR		SMALLINT			NOT NULL,
	idLOJA				SMALLINT			NOT NULL,
	idROTULO			SMALLINT			NOT NULL,
	quantidade			int					NOT NULL,

	CONSTRAINT PK_pedido					PRIMARY KEY(idPEDIDO),
	CONSTRAINT AK_pedido					UNIQUE(data, idLOJA, idROTULO),
	CONSTRAINT FK_pedido_distribuidor		FOREIGN KEY(idDISTRIBUIDOR) REFERENCES DISTRIBUIDOR,
	CONSTRAINT FK_pedido_loja				FOREIGN KEY(idLOJA) REFERENCES LOJA,
	CONSTRAINT FK_pedido_rotulo				FOREIGN KEY(idROTULO) REFERENCES ROTULO,
	CONSTRAINT CK_pedido_quantidade				CHECK(quantidade>0)
)

/*** Cria��o da tabela FUNCIONARIO ***/

CREATE TABLE FUNCIONARIO(	
	idFUNCIONARIO		SMALLINT			NOT NULL,
	nome				VARCHAR(255)		NOT NULL,
	telefone			VARCHAR(45)			NOT NULL,
	email				VARCHAR(255)		NOT NULL,
	ativo				TINYINT				NOT NULL,
	idLOJA				SMALLINT			NOT NULL,
	idchefia			SMALLINT			NULL,

	CONSTRAINT PK_funcionario				PRIMARY KEY(idFUNCIONARIO),
	CONSTRAINT AK_funcionario_nome			UNIQUE(nome),
	CONSTRAINT AK_funcionario_telefone		UNIQUE(telefone),
	CONSTRAINT FK_funcionario_loja			FOREIGN KEY(idLOJA) REFERENCES LOJA,
	CONSTRAINT FK_funcionario_chefia		FOREIGN KEY(idchefia) REFERENCES FUNCIONARIO
)

/*** Cria��o da tabela MOTORISTA ***/

CREATE TABLE MOTORISTA(	
	idFUNCIONARIO		SMALLINT			NOT NULL,
	cnh					VARCHAR(45)			NOT NULL,

	CONSTRAINT PK_motorista					PRIMARY KEY(idFUNCIONARIO),
	CONSTRAINT FK_motorista					FOREIGN KEY(idFUNCIONARIO) REFERENCES FUNCIONARIO,
	CONSTRAINT CK_CNH						CHECK(LEN(cnh)=6)
)

/*** Cria��o da tabela VENDEDOR ***/

CREATE TABLE VENDEDOR(	
	idFUNCIONARIO		SMALLINT		NOT NULL,
	comissao			INT				NOT NULL,

	CONSTRAINT PK_vendedor				PRIMARY KEY(idFUNCIONARIO),
	CONSTRAINT FK_vendedor				FOREIGN KEY(idFUNCIONARIO) REFERENCES FUNCIONARIO,
)

/*** CRIACA��O DA TABELA CARTAO FIDELIDADE ***/

CREATE TABLE CARTAO(
	idCARTAO		SMALLINT		NOT NULL,
	pontos			SMALLINT		DEFAULT 100,
	CONSTRAINT PK_cartao_fidelidade		PRIMARY KEY(idCARTAO),
)

/*** Cria��o da tabela CLIENTE ***/

CREATE TABLE CLIENTE(	
	idCLIENTE			SMALLINT		NOT NULL,
	nome				VARCHAR(255)	NOT NULL,
	telefone			VARCHAR(45)		NOT NULL,
	email				VARCHAR(255)	NOT NULL,
	data_nasc			DATE			NOT NULL,
	idCARTAO			SMALLINT		NULL,

	CONSTRAINT PK_cliente				PRIMARY KEY(idCLIENTE),
	CONSTRAINT FK_cliente_cartao		FOREIGN KEY(idCARTAO) REFERENCES CARTAO,
	CONSTRAINT CK_data_nasc				CHECK((YEAR(GETDATE()) - YEAR(data_nasc))>=18)
)

/*** Cria��o da tabela PROMO��O ***/

CREATE TABLE PROMOCAO(	
	idPROMOCAO			SMALLINT		NOT NULL,
	nome				VARCHAR(255)	NOT NULL,
	data_expiracao		DATE			NOT NULL,
	desconto			DECIMAL(2,2)	NOT NULL,

	CONSTRAINT PK_promocao				PRIMARY KEY(idPROMOCAO),
	CONSTRAINT CK_data_exp				CHECK(data_expiracao > GETDATE())
)

/*** Cria��o da tabela COMPRA ***/

CREATE TABLE COMPRA(	
	idCOMPRA			SMALLINT		NOT NULL,
	idCLIENTE			SMALLINT		NOT NULL,
	idVENDEDOR			SMALLINT		NOT NULL,
	data				DATE			NOT NULL,
	idPROMOCAO			SMALLINT		NOT NULL,

	CONSTRAINT PK_compra				PRIMARY KEY(idCOMPRA),
	CONSTRAINT FK_compra_cliente		FOREIGN KEY(idCLIENTE) REFERENCES CLIENTE,
	CONSTRAINT FK_compra_vendedor		FOREIGN KEY(idVENDEDOR) REFERENCES VENDEDOR,
	CONSTRAINT FK_compra_promocao		FOREIGN KEY(idPROMOCAO)	REFERENCES PROMOCAO,
)

/*** Cria��o da tabela COMPRA-ROTULO ***/

CREATE TABLE COMPRA_ROTULO(	
	idCOMPRA			SMALLINT		NOT NULL,
	idROTULO			SMALLINT		NOT NULL,
	quantidade			INT				NOT NULL,

	CONSTRAINT PK_compra_rotulo			PRIMARY KEY(idCOMPRA,idROTULO),
	CONSTRAINT FK_compra_compra			FOREIGN KEY(idCOMPRA) REFERENCES COMPRA,
	CONSTRAINT FK_compra_rotulo_rotulo	FOREIGN KEY(idROTULO) REFERENCES ROTULO,
	CONSTRAINT CK_compra_quantidade		CHECK(quantidade>0)
)



