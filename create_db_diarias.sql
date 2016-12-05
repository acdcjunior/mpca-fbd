-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema diarias
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `diarias` ;

-- -----------------------------------------------------
-- Schema diarias
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `diarias` DEFAULT CHARACTER SET utf8 ;
USE `diarias` ;

-- -----------------------------------------------------
-- Table `diarias`.`orgao_superior`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `diarias`.`orgao_superior` ;

CREATE TABLE IF NOT EXISTS `diarias`.`orgao_superior` (
  `codigo` INT NOT NULL,
  `nome` VARCHAR(200) NOT NULL,
  PRIMARY KEY (`codigo`),
  UNIQUE INDEX `nome_UNIQUE` (`nome` ASC))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `diarias`.`orgao_subordinado`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `diarias`.`orgao_subordinado` ;

CREATE TABLE IF NOT EXISTS `diarias`.`orgao_subordinado` (
  `codigo` INT NOT NULL,
  `nome` VARCHAR(200) NOT NULL,
  PRIMARY KEY (`codigo`),
  UNIQUE INDEX `nome_UNIQUE` (`nome` ASC))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `diarias`.`unidade_gestora`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `diarias`.`unidade_gestora` ;

CREATE TABLE IF NOT EXISTS `diarias`.`unidade_gestora` (
  `codigo` INT NOT NULL,
  `nome` VARCHAR(200) NOT NULL,
  PRIMARY KEY (`codigo`),
  UNIQUE INDEX `nome_UNIQUE` (`nome` ASC))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `diarias`.`funcao`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `diarias`.`funcao` ;

CREATE TABLE IF NOT EXISTS `diarias`.`funcao` (
  `codigo` INT NOT NULL,
  `nome` VARCHAR(200) NOT NULL,
  PRIMARY KEY (`codigo`),
  UNIQUE INDEX `nome_UNIQUE` (`nome` ASC))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `diarias`.`subfuncao`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `diarias`.`subfuncao` ;

CREATE TABLE IF NOT EXISTS `diarias`.`subfuncao` (
  `codigo` INT NOT NULL,
  `nome` VARCHAR(200) NOT NULL,
  PRIMARY KEY (`codigo`),
  UNIQUE INDEX `nome_UNIQUE` (`nome` ASC))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `diarias`.`programa`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `diarias`.`programa` ;

CREATE TABLE IF NOT EXISTS `diarias`.`programa` (
  `codigo` INT NOT NULL,
  `nome` VARCHAR(200) NOT NULL,
  PRIMARY KEY (`codigo`),
  UNIQUE INDEX `nome_UNIQUE` (`nome` ASC))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `diarias`.`acao`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `diarias`.`acao` ;

CREATE TABLE IF NOT EXISTS `diarias`.`acao` (
  `codigo` INT NOT NULL,
  `nome` VARCHAR(200) NOT NULL,
  PRIMARY KEY (`codigo`),
  UNIQUE INDEX `nome_UNIQUE` (`nome` ASC))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `diarias`.`linguagem_cidada`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `diarias`.`linguagem_cidada` ;

CREATE TABLE IF NOT EXISTS `diarias`.`linguagem_cidada` (
  `codigo` INT NOT NULL AUTO_INCREMENT,
  `descricao` VARCHAR(200) NOT NULL,
  PRIMARY KEY (`codigo`),
  UNIQUE INDEX `descricao_UNIQUE` (`descricao` ASC))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `diarias`.`favorecido`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `diarias`.`favorecido` ;

CREATE TABLE IF NOT EXISTS `diarias`.`favorecido` (
  `codigo` INT NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(300) NOT NULL,
  `cpf` VARCHAR(11) NULL,
  PRIMARY KEY (`codigo`),
  UNIQUE INDEX `nome_UNIQUE` (`nome` ASC))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `diarias`.`diaria`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `diarias`.`diaria` ;

CREATE TABLE IF NOT EXISTS `diarias`.`diaria` (
  `codigo` INT NOT NULL AUTO_INCREMENT,
  `documento` VARCHAR(15) NOT NULL,
  `gestao` VARCHAR(10) NOT NULL,
  `dt_diaria` DATE NOT NULL,
  `valor` DECIMAL(10,2) NOT NULL,
  `favorecido` INT NOT NULL,
  `orgao_superior` INT NOT NULL,
  `orgao_subordinado` INT NOT NULL,
  `funcao` INT NOT NULL,
  `unidade_gestora` INT NOT NULL,
  `linguagem_cidada` INT NOT NULL,
  `acao` INT NOT NULL,
  `subfuncao` INT NOT NULL,
  `programa` INT NOT NULL,
  PRIMARY KEY (`codigo`),
  UNIQUE INDEX `documento_UNIQUE` (`documento` ASC),
  INDEX `fk_diaria_favorecido_idx` (`favorecido` ASC),
  INDEX `fk_diaria_orgao_superior1_idx` (`orgao_superior` ASC),
  INDEX `fk_diaria_orgao_subordinado1_idx` (`orgao_subordinado` ASC),
  INDEX `fk_diaria_funcao1_idx` (`funcao` ASC),
  INDEX `fk_diaria_unidade_gestora1_idx` (`unidade_gestora` ASC),
  INDEX `fk_diaria_linguagem_cidada1_idx` (`linguagem_cidada` ASC),
  INDEX `fk_diaria_acao1_idx` (`acao` ASC),
  INDEX `fk_diaria_subfuncao1_idx` (`subfuncao` ASC),
  INDEX `fk_diaria_programa1_idx` (`programa` ASC),
  CONSTRAINT `fk_diaria_favorecido`
    FOREIGN KEY (`favorecido`)
    REFERENCES `diarias`.`favorecido` (`codigo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_diaria_orgao_superior1`
    FOREIGN KEY (`orgao_superior`)
    REFERENCES `diarias`.`orgao_superior` (`codigo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_diaria_orgao_subordinado1`
    FOREIGN KEY (`orgao_subordinado`)
    REFERENCES `diarias`.`orgao_subordinado` (`codigo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_diaria_funcao1`
    FOREIGN KEY (`funcao`)
    REFERENCES `diarias`.`funcao` (`codigo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_diaria_unidade_gestora1`
    FOREIGN KEY (`unidade_gestora`)
    REFERENCES `diarias`.`unidade_gestora` (`codigo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_diaria_linguagem_cidada1`
    FOREIGN KEY (`linguagem_cidada`)
    REFERENCES `diarias`.`linguagem_cidada` (`codigo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_diaria_acao1`
    FOREIGN KEY (`acao`)
    REFERENCES `diarias`.`acao` (`codigo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_diaria_subfuncao1`
    FOREIGN KEY (`subfuncao`)
    REFERENCES `diarias`.`subfuncao` (`codigo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_diaria_programa1`
    FOREIGN KEY (`programa`)
    REFERENCES `diarias`.`programa` (`codigo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

USE `diarias` ;

-- -----------------------------------------------------
-- procedure inserir_orgao_subordinado
-- -----------------------------------------------------

USE `diarias`;
DROP procedure IF EXISTS `diarias`.`inserir_orgao_subordinado`;

DELIMITER $$
USE `diarias`$$
CREATE PROCEDURE inserir_orgao_subordinado (IN cod INT, IN nm VARCHAR(200))
BEGIN
	declare cd INT;
	SELECT codigo INTO cd FROM orgao_subordinado where codigo = cod;
    if cd is null then
		insert into orgao_subordinado(codigo, nome) values (cod, nm);
	end if;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure inserir_orgao_superior
-- -----------------------------------------------------

USE `diarias`;
DROP procedure IF EXISTS `diarias`.`inserir_orgao_superior`;

DELIMITER $$
USE `diarias`$$
CREATE PROCEDURE inserir_orgao_superior (IN cod INT, IN nm VARCHAR(200))
BEGIN
	declare cd INT;
	SELECT codigo INTO cd FROM orgao_superior where codigo = cod;
    if cd is null then
		insert into orgao_superior(codigo, nome) values (cod, nm);
	end if;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure inserir_funcao
-- -----------------------------------------------------

USE `diarias`;
DROP procedure IF EXISTS `diarias`.`inserir_funcao`;

DELIMITER $$
USE `diarias`$$
CREATE PROCEDURE inserir_funcao (IN cod INT, IN nm VARCHAR(200))
BEGIN
	declare cd INT;
	SELECT codigo INTO cd FROM funcao where codigo = cod;
    if cd is null then
		insert into funcao(codigo, nome) values (cod, nm);
	end if;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure inserir_unidade_gestora
-- -----------------------------------------------------

USE `diarias`;
DROP procedure IF EXISTS `diarias`.`inserir_unidade_gestora`;

DELIMITER $$
USE `diarias`$$
CREATE PROCEDURE inserir_unidade_gestora (IN cod INT, IN nm VARCHAR(200))
BEGIN
	declare cd INT;
	SELECT codigo INTO cd FROM unidade_gestora where codigo = cod;
    if cd is null then
		insert into unidade_gestora(codigo, nome) values (cod, nm);
	end if;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure inserir_subfuncao
-- -----------------------------------------------------

USE `diarias`;
DROP procedure IF EXISTS `diarias`.`inserir_subfuncao`;

DELIMITER $$
USE `diarias`$$
CREATE PROCEDURE inserir_subfuncao (IN cod INT, IN nm VARCHAR(200))
BEGIN
	declare cd INT;
	SELECT codigo INTO cd FROM subfuncao where codigo = cod;
    if cd is null then
		insert into subfuncao(codigo, nome) values (cod, nm);
	end if;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure inserir_linguagem_cidada
-- -----------------------------------------------------

USE `diarias`;
DROP procedure IF EXISTS `diarias`.`inserir_linguagem_cidada`;

DELIMITER $$
USE `diarias`$$
CREATE PROCEDURE inserir_linguagem_cidada (INOUT cod INT, IN nm VARCHAR(200))
BEGIN
	SELECT codigo INTO cod FROM linguagem_cidada where descricao = nm;
    if cod is null then
		insert into linguagem_cidada(codigo, descricao) values (cod, nm);
        set cod = LAST_INSERT_ID();
	end if;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure inserir_acao
-- -----------------------------------------------------

USE `diarias`;
DROP procedure IF EXISTS `diarias`.`inserir_acao`;

DELIMITER $$
USE `diarias`$$
CREATE PROCEDURE inserir_acao (IN cod INT, IN nm VARCHAR(200))
BEGIN
	declare cd INT;
	SELECT codigo INTO cd FROM acao where codigo = cod;
    if cd is null then
		insert into acao(codigo, nome) values (cod, nm);
	end if;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure inserir_programa
-- -----------------------------------------------------

USE `diarias`;
DROP procedure IF EXISTS `diarias`.`inserir_programa`;

DELIMITER $$
USE `diarias`$$
CREATE PROCEDURE inserir_programa (IN cod INT, IN nm VARCHAR(200))
BEGIN
	declare cd INT;
	SELECT codigo INTO cd FROM programa where codigo = cod;
    if cd is null then
		insert into programa(codigo, nome) values (cod, nm);
	end if;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure inserir_favorecido
-- -----------------------------------------------------

USE `diarias`;
DROP procedure IF EXISTS `diarias`.`inserir_favorecido`;

DELIMITER $$
USE `diarias`$$
CREATE PROCEDURE inserir_favorecido (OUT cod INT, IN nm VARCHAR(300), IN cpf VARCHAR(11))
BEGIN
	SELECT codigo INTO cod FROM favorecido where nome = nm;
    if cod is null then
		insert into favorecido(nome, cpf) values (nm, cpf);
        set cod = LAST_INSERT_ID();
	end if;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure inserir_diaria
-- -----------------------------------------------------

USE `diarias`;
DROP procedure IF EXISTS `diarias`.`inserir_diaria`;

DELIMITER $$
USE `diarias`$$
CREATE PROCEDURE inserir_diaria (
	IN cd_org_sup INT, IN nm_org_sup VARCHAR(200),
    IN cd_org_sub INT, IN nm_org_sub VARCHAR(200),
    IN cd_un_gest INT, IN nm_un_gest VARCHAR(200),
    IN cd_funcao INT, IN nm_funcao VARCHAR(200),
    IN cd_subfuncao INT, IN nm_subfuncao VARCHAR(200),
    IN cd_prog INT, IN nm_prog VARCHAR(200),
    IN cd_acao INT, IN nm_acao VARCHAR(200),
    IN ling_cidada VARCHAR(200),
    IN cpf_fav VARCHAR(11), IN nm_fav VARCHAR(300), 
    IN doc VARCHAR(15), IN gestao VARCHAR(11), IN dt DATE, IN val DECIMAL(10,2), 
    OUT cod INT)
BEGIN
	DECLARE cd_ling_cidada INT;
    DECLARE cd_fav INT;
    
    CALL inserir_orgao_superior(cd_org_sup, nm_org_sup);
    CALL inserir_orgao_subordinado(cd_org_sub, nm_org_sub);
    CALL inserir_unidade_gestora(cd_un_gest, nm_un_gest);
    CALL inserir_funcao(cd_funcao, nm_funcao);
    CALL inserir_subfuncao(cd_subfuncao, nm_subfuncao);
    CALL inserir_programa(cd_prog, nm_prog);
    CALL inserir_acao(cd_acao, nm_acao);
       
    CALL inserir_linguagem_cidada(cd_ling_cidada, ling_cidada);
       
    CALL inserir_favorecido(cd_fav, nm_fav, cpf_fav);
    
    insert into diaria(
		orgao_superior, orgao_subordinado, unidade_gestora, 
        funcao, subfuncao, programa, acao, linguagem_cidada, favorecido,
        documento, gestao, dt_diaria, valor)
	values(
		cd_org_sup, cd_org_sub, cd_un_gest, 
        cd_funcao, cd_subfuncao, cd_prog, cd_acao, cd_ling_cidada, cd_fav,
        doc, gestao, dt, val);
	
    set cod = LAST_INSERT_ID();
END$$

DELIMITER ;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
