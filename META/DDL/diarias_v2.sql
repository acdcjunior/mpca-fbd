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
-- Table `diarias`.`orgao`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `diarias`.`orgao` ;

CREATE TABLE IF NOT EXISTS `diarias`.`orgao` (
  `codigo` INT NOT NULL,
  `nome` VARCHAR(200) NOT NULL,
  `orgao_sup` INT NULL,
  PRIMARY KEY (`codigo`),
  INDEX `fk_orgao_sup_idx` (`orgao_sup` ASC),
  CONSTRAINT `fk_orgao_sup`
    FOREIGN KEY (`orgao_sup`)
    REFERENCES `diarias`.`orgao` (`codigo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `diarias`.`funcao`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `diarias`.`funcao` ;

CREATE TABLE IF NOT EXISTS `diarias`.`funcao` (
  `codigo` INT NOT NULL,
  `nome` VARCHAR(200) NOT NULL,
  PRIMARY KEY (`codigo`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `diarias`.`subfuncao`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `diarias`.`subfuncao` ;

CREATE TABLE IF NOT EXISTS `diarias`.`subfuncao` (
  `codigo` INT NOT NULL,
  `nome` VARCHAR(200) NOT NULL,
  `funcao` INT NOT NULL,
  PRIMARY KEY (`codigo`),
  INDEX `fk_funcao_idx` (`funcao` ASC),
  CONSTRAINT `fk_funcao`
    FOREIGN KEY (`funcao`)
    REFERENCES `diarias`.`funcao` (`codigo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `diarias`.`programa`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `diarias`.`programa` ;

CREATE TABLE IF NOT EXISTS `diarias`.`programa` (
  `codigo` INT NOT NULL,
  `nome` VARCHAR(200) NOT NULL,
  `subfuncao` INT NOT NULL,
  PRIMARY KEY (`codigo`),
  INDEX `fk_subfuncao_idx` (`subfuncao` ASC),
  CONSTRAINT `fk_subfuncao`
    FOREIGN KEY (`subfuncao`)
    REFERENCES `diarias`.`subfuncao` (`codigo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `diarias`.`acao`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `diarias`.`acao` ;

CREATE TABLE IF NOT EXISTS `diarias`.`acao` (
  `codigo` VARCHAR(200) NOT NULL,
  `nome` VARCHAR(200) NOT NULL,
  `linguagem_cidada` VARCHAR(200) NULL,
  `programa` INT NOT NULL,
  PRIMARY KEY (`codigo`),
  INDEX `fk_programa_idx` (`programa` ASC),
  CONSTRAINT `fk_programa`
    FOREIGN KEY (`programa`)
    REFERENCES `diarias`.`programa` (`codigo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `diarias`.`unidade_gestora`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `diarias`.`unidade_gestora` ;

CREATE TABLE IF NOT EXISTS `diarias`.`unidade_gestora` (
  `codigo` INT NOT NULL,
  `nome` VARCHAR(200) NOT NULL,
  `orgao` INT NOT NULL,
  PRIMARY KEY (`codigo`),
  INDEX `fk_orgao_idx` (`orgao` ASC),
  CONSTRAINT `fk_orgao`
    FOREIGN KEY (`orgao`)
    REFERENCES `diarias`.`orgao` (`codigo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `diarias`.`favorecido`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `diarias`.`favorecido` ;

CREATE TABLE IF NOT EXISTS `diarias`.`favorecido` (
  `nome` VARCHAR(200) NOT NULL,
  `cpf` VARCHAR(11) NOT NULL,
  PRIMARY KEY (`cpf`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `diarias`.`diaria`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `diarias`.`diaria` ;

CREATE TABLE IF NOT EXISTS `diarias`.`diaria` (
  `documento` VARCHAR(15) NOT NULL,
  `gestao` VARCHAR(10) NOT NULL,
  `dt_diaria` DATE NOT NULL,
  `valor` DECIMAL(10,2) NOT NULL,
  `favorecido` VARCHAR(11) NOT NULL,
  `ug_pagadora` INT NOT NULL,
  `acao` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`documento`),
  INDEX `fk_diaria_ug_pagadora_idx` (`ug_pagadora` ASC),
  INDEX `fk_acao_idx` (`acao` ASC),
  INDEX `fk_favorecido_idx` (`favorecido` ASC),
  CONSTRAINT `fk_diaria_ug_pagadora`
    FOREIGN KEY (`ug_pagadora`)
    REFERENCES `diarias`.`unidade_gestora` (`codigo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_acao`
    FOREIGN KEY (`acao`)
    REFERENCES `diarias`.`acao` (`codigo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_favorecido`
    FOREIGN KEY (`favorecido`)
    REFERENCES `diarias`.`favorecido` (`cpf`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `diarias`.`log`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `diarias`.`log` ;

CREATE TABLE IF NOT EXISTS `diarias`.`log` (
  `codigo` INT NOT NULL AUTO_INCREMENT,
  `data` DATETIME NOT NULL,
  `operacao` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`codigo`))
ENGINE = InnoDB;

USE `diarias` ;

-- -----------------------------------------------------
-- Placeholder table for view `diarias`.`vw_diarias`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `diarias`.`vw_diarias` (`cd_orgao_superior` INT, `nm_orgao_superior` INT, `cd_orgao_subordinado` INT, `nm_orgao_subordinado` INT, `cd_unidade_gestora` INT, `nm_unidade_gestora` INT, `cd_funcao` INT, `nm_funcao` INT, `cd_subfuncao` INT, `nm_subfuncao` INT, `cd_programa` INT, `nm_programa` INT, `cd_acao` INT, `nm_acao` INT, `linguagem_cidada` INT, `cpf_favorecido` INT, `nm_favorecido` INT, `documento` INT, `gestao` INT, `dt_diaria` INT, `valor` INT);

-- -----------------------------------------------------
-- procedure inserir_orgao_subordinado
-- -----------------------------------------------------

USE `diarias`;
DROP procedure IF EXISTS `diarias`.`inserir_orgao_subordinado`;

DELIMITER $$
USE `diarias`$$
CREATE PROCEDURE inserir_orgao_subordinado (IN cod INT, IN nm VARCHAR(200), IN cd_org_sup INT)
BEGIN
	declare cd INT;
	SELECT codigo INTO cd FROM orgao where codigo = cod;
    if cd is null then
		insert into orgao(codigo, nome, orgao_sup) values (cod, nm, cd_org_sup);
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
	SELECT codigo INTO cd FROM orgao where codigo = cod;
    if cd is null then
		insert into orgao(codigo, nome) values (cod, nm);
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
CREATE PROCEDURE inserir_unidade_gestora (IN cod INT, IN nm VARCHAR(200), IN cd_orgao INT)
BEGIN
	declare cd INT;
	SELECT codigo INTO cd FROM unidade_gestora where codigo = cod;
    if cd is null then
		insert into unidade_gestora(codigo, nome, orgao) values (cod, nm, cd_orgao);
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
CREATE PROCEDURE inserir_subfuncao (IN cod INT, IN nm VARCHAR(200), IN cd_funcao INT)
BEGIN
	declare cd INT;
	SELECT codigo INTO cd FROM subfuncao where codigo = cod;
    if cd is null then
		insert into subfuncao(codigo, nome, funcao) values (cod, nm, cd_funcao);
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
CREATE PROCEDURE inserir_acao (IN cod INT, IN nm VARCHAR(200), IN lng_cidada VARCHAR(200), IN cd_programa INT)
BEGIN
	declare cd INT;
	SELECT codigo INTO cd FROM acao where codigo = cod;
    if cd is null then
		insert into acao(codigo, nome, linguagem_cidada, programa) values (cod, nm, lng_cidada, cd_programa);
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
CREATE PROCEDURE inserir_programa (IN cod INT, IN nm VARCHAR(200), IN cd_subfuncao INT)
BEGIN
	declare cd INT;
	SELECT codigo INTO cd FROM programa where codigo = cod;
    if cd is null then
		insert into programa(codigo, nome, subfuncao) values (cod, nm, cd_subfuncao);
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
CREATE PROCEDURE inserir_favorecido (IN nm VARCHAR(300), IN cpf_fav VARCHAR(11))
BEGIN
	declare cp INT;
	SELECT cpf INTO cp FROM favorecido where cpf = cpf_fav;
    if cp is null then
		insert into favorecido(nome, cpf) values (nm, cpf_fav);

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
    IN doc VARCHAR(15), IN gestao VARCHAR(11), IN dt DATE, IN val DECIMAL(10,2))
BEGIN
	DECLARE cd_ling_cidada INT;
    DECLARE cd_fav INT;
    
    CALL inserir_orgao_superior(cd_org_sup, nm_org_sup);
    CALL inserir_orgao_subordinado(cd_org_sub, nm_org_sub, cd_org_sup);
    CALL inserir_unidade_gestora(cd_un_gest, nm_un_gest, cd_org_sub);
    CALL inserir_funcao(cd_funcao, nm_funcao);
    CALL inserir_subfuncao(cd_subfuncao, nm_subfuncao, cd_funcao);
    CALL inserir_programa(cd_prog, nm_prog, cd_subfuncao);
    CALL inserir_acao(cd_acao, nm_acao, ling_cidada, cd_prog);
       
    CALL inserir_favorecido(nm_fav, cpf_fav);
    
    insert into diaria(
		favorecido, ug_pagadora, acao, 
        documento, gestao, dt_diaria, valor)
	values(
		cpf_fav, cd_un_gest, cd_acao, 
        doc, gestao, dt, val);
	
END$$

DELIMITER ;

-- -----------------------------------------------------
-- View `diarias`.`vw_diarias`
-- -----------------------------------------------------
DROP VIEW IF EXISTS `diarias`.`vw_diarias` ;
DROP TABLE IF EXISTS `diarias`.`vw_diarias`;
USE `diarias`;
create  OR REPLACE view vw_diarias as
select 
	osup.codigo cd_orgao_superior, osup.nome nm_orgao_superior,
    osub.codigo cd_orgao_subordinado, osub.nome nm_orgao_subordinado,
    ug.codigo cd_unidade_gestora, ug.nome nm_unidade_gestora,
    fun.codigo cd_funcao, fun.nome nm_funcao,
    sf.codigo cd_subfuncao, sf.nome nm_subfuncao,
    p.codigo cd_programa, p.nome nm_programa,
    a.codigo cd_acao, a.nome nm_acao, a.linguagem_cidada linguagem_cidada,
    f.cpf cpf_favorecido, f.nome nm_favorecido,
	d.documento, d.gestao, d.dt_diaria, d.valor
from diaria d 
	join favorecido f on d.favorecido = f.cpf
    join unidade_gestora ug on d.ug_pagadora = ug.codigo
    join orgao osub on ug.orgao = osub.codigo
    join orgao osup on osub.orgao_sup = osup.codigo
    join acao a on d.acao = a.codigo
    join programa p on a.programa = p.codigo
    join subfuncao sf on p.subfuncao = sf.codigo
    join funcao fun on sf.funcao = fun.codigo
    ;
USE `diarias`;

DELIMITER $$

USE `diarias`$$
DROP TRIGGER IF EXISTS `diarias`.`diaria_AFTER_INSERT` $$
USE `diarias`$$
CREATE DEFINER = CURRENT_USER TRIGGER `diarias`.`diaria_AFTER_INSERT` AFTER INSERT ON `diaria` FOR EACH ROW
BEGIN
	insert into log(data, operacao) values (now(), concat('nova diária - código: ', new.documento));
END$$


DELIMITER ;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
