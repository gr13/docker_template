CREATE DATABASE IF NOT EXISTS database_name;
use database_name;

-- ###################################################################
-- table users
-- ###################################################################
CREATE TABLE IF NOT EXISTS users (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    ts TIMESTAMP  DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    email VARCHAR(255) NOT NULL,
    password VARCHAR(110) NOT NULL,
    right_id SMALLINT UNSIGNED NOT NULL,
    username VARCHAR(100) NOT NULL,
    position VARCHAR(100) NOT NULL,
    can_edit SMALLINT(1) UNSIGNED NOT NULL DEFAULT 0,
    can_seelog SMALLINT(1) UNSIGNED NOT NULL DEFAULT 0,
    can_seeusers SMALLINT(1) UNSIGNED NOT NULL DEFAULT 0,
    hide SMALLINT(1) UNSIGNED NOT NULL DEFAULT 0,
    log_user_id INT UNSIGNED NOT NULL DEFAULT 0,
    log_comment VARCHAR(255) NOT NULL DEFAULT '',
    PRIMARY KEY (id),
    INDEX rights (right_id)
);

CREATE TABLE IF NOT EXISTS users_log (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    ts TIMESTAMP  DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    logger_event VARCHAR(50),
    log_id INT UNSIGNED,
    email VARCHAR(255),
    right_id SMALLINT UNSIGNED,
    username VARCHAR(100),
    position VARCHAR(100),
    can_edit SMALLINT(1) UNSIGNED NOT NULL DEFAULT 0,
    can_seelog SMALLINT(1) UNSIGNED NOT NULL DEFAULT 0,
    can_seeusers SMALLINT(1) UNSIGNED NOT NULL DEFAULT 0,
    hide SMALLINT(1) UNSIGNED NOT NULL DEFAULT 0,
    log_user_id INT UNSIGNED DEFAULT 0,
    log_comment VARCHAR(255) DEFAULT '',
    PRIMARY KEY (id),
    INDEX rights (right_id),
    INDEX log_id (log_id),
    INDEX log_user_id (log_user_id)
);

DELIMITER ;;
CREATE TRIGGER users_log_ai AFTER INSERT ON users FOR EACH ROW
INSERT INTO users_log(logger_event, log_id, email, right_id, username,
          position, can_edit, can_seelog, can_seeusers,
          hide, log_user_id, log_comment)
    VALUES (
           'insert',
           NEW.id,
           NEW.email,
           NEW.right_id,
           NEW.username,
           NEW.position,
           NEW.can_edit,
           NEW.can_seelog,
           NEW.can_seeusers,
           NEW.hide,
           NEW.log_user_id,
           NEW.log_comment
           );;
DELIMITER ;
DELIMITER ;;
CREATE TRIGGER users_log_au AFTER UPDATE ON users FOR EACH ROW
INSERT INTO users_log(logger_event, log_id, email, right_id, username,
          position, hide, can_edit, can_seelog, can_seeusers,
          log_user_id, log_comment)
    VALUES (
           'update',
           NEW.id,
           NEW.email,
           NEW.right_id,
           NEW.username,
           NEW.position,
           NEW.can_edit,
           NEW.can_seelog,
           NEW.can_seeusers,
           NEW.hide,
           NEW.log_user_id,
           NEW.log_comment
           );;
DELIMITER ;

-- ###################################################################
-- table rights
-- ###################################################################

CREATE TABLE IF NOT EXISTS rights(
    id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    user_right VARCHAR(20) NOT NULL,
    log_user_id INT UNSIGNED DEFAULT 0,
    PRIMARY KEY (id),
    UNIQUE (user_right)
);

CREATE TABLE IF NOT EXISTS rights_log(
    id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    ts TIMESTAMP  DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    logger_event VARCHAR(50),
    log_id INT UNSIGNED,
    user_right VARCHAR(20) NOT NULL,
    log_user_id INT UNSIGNED DEFAULT 0,
    PRIMARY KEY (id),
    UNIQUE (user_right),
    INDEX log_id (log_id),
    INDEX log_user_id (log_user_id)
);

DELIMITER ;;
CREATE TRIGGER rights_log_ai AFTER INSERT ON rights FOR EACH ROW
INSERT INTO rights_log(logger_event, log_id, user_right, log_user_id)
    VALUES (
           'insert',
           NEW.id,
           NEW.user_right,
           NEW.log_user_id
           );;
DELIMITER ;
DELIMITER ;;
CREATE TRIGGER rights_log_au AFTER UPDATE ON rights FOR EACH ROW
INSERT INTO rights_log(logger_event, log_id, user_right, log_user_id)
    VALUES (
           'update',
           NEW.id,
           NEW.user_right,
           NEW.log_user_id
           );;
DELIMITER ;

INSERT IGNORE INTO rights ( user_right) VALUES ('blocked');
INSERT IGNORE INTO rights ( user_right) VALUES ('customer');
INSERT IGNORE INTO rights ( user_right) VALUES ('operator');
INSERT IGNORE INTO rights ( user_right) VALUES ('manager');
INSERT IGNORE INTO rights ( user_right) VALUES ('admin');

-- ###################################################################
-- table countries
-- ###################################################################

CREATE TABLE IF NOT EXISTS countries(
    id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    ts TIMESTAMP  DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    title VARCHAR(50) NOT NULL,
    description VARCHAR(250) NOT NULL DEFAULT '',
    hide SMALLINT(1) UNSIGNED NOT NULL DEFAULT 0,
    log_user_id INT UNSIGNED NOT NULL DEFAULT 0,
    PRIMARY KEY (id),
    UNIQUE (title)
);

CREATE TABLE IF NOT EXISTS countries_log(
    id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    ts TIMESTAMP  DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    logger_event VARCHAR(50),
    log_id INT UNSIGNED,
    title VARCHAR(50) NOT NULL,
    description VARCHAR(250) NOT NULL DEFAULT '',
    hide SMALLINT(1) UNSIGNED NOT NULL DEFAULT 0,
    log_user_id INT UNSIGNED NOT NULL DEFAULT 0,
    PRIMARY KEY (id),
    INDEX log_id (log_id),
    INDEX log_user_id (log_user_id)
);

DELIMITER ;;
CREATE TRIGGER countries_log_ai AFTER INSERT ON countries FOR EACH ROW
INSERT INTO countries_log(logger_event, log_id, title, description, hide,
          log_user_id)
    VALUES (
           'insert',
           NEW.id,
           NEW.title,
           NEW.description,
           NEW.hide,
           NEW.log_user_id
           );;
DELIMITER ;
DELIMITER ;;
CREATE TRIGGER countries_log_au AFTER UPDATE ON countries FOR EACH ROW
INSERT INTO countries_log(logger_event, log_id, title, description, hide,
          log_user_id)
    VALUES (
           'update',
           NEW.id,
           NEW.title,
           NEW.description,
           NEW.hide,
           NEW.log_user_id
           );;
DELIMITER ;

INSERT IGNORE INTO countries (title) VALUES ('Russia');
INSERT IGNORE INTO countries (title) VALUES ('USA');
INSERT IGNORE INTO countries (title) VALUES ('Germany');

-- ###################################################################
-- table regions
-- ###################################################################

CREATE TABLE IF NOT EXISTS regions(
    id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    ts TIMESTAMP  DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    title VARCHAR(100) NOT NULL,
    description VARCHAR(255) NOT NULL DEFAULT '',
    country_id INT UNSIGNED NOT NULL,
    hide SMALLINT(1) UNSIGNED NOT NULL DEFAULT 0,
    log_user_id INT UNSIGNED NOT NULL DEFAULT 0,
    PRIMARY KEY (id)
);



CREATE TABLE IF NOT EXISTS regions_log(
    id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    ts TIMESTAMP  DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    logger_event VARCHAR(50),
    log_id INT UNSIGNED,
    title VARCHAR(100) NOT NULL,
    description VARCHAR(255) NOT NULL DEFAULT '',
    country_id INT UNSIGNED NOT NULL,
    hide SMALLINT(1) UNSIGNED NOT NULL DEFAULT 0,
    log_user_id INT UNSIGNED NOT NULL DEFAULT 0,
    PRIMARY KEY (id),
    INDEX log_id (log_id),
    INDEX log_user_id (log_user_id)
);

DELIMITER ;;
CREATE TRIGGER regions_log_ai AFTER INSERT ON regions FOR EACH ROW
INSERT INTO regions_log(logger_event, log_id, title, description,
                    country_id, hide, log_user_id)
    VALUES (
           'insert',
           NEW.id,
           NEW.title,
           NEW.description,
           NEW.country_id,
           NEW.hide,
           NEW.log_user_id
           );;
DELIMITER ;
DELIMITER ;;
CREATE TRIGGER regions_log_au AFTER UPDATE ON regions FOR EACH ROW
INSERT INTO regions_log(logger_event, log_id, title, description,
                    country_id, hide, log_user_id)
    VALUES (
           'update',
           NEW.id,
           NEW.title,
           NEW.description,
           NEW.country_id,
           NEW.hide,
           NEW.log_user_id
           );;
DELIMITER ;

INSERT IGNORE INTO regions (title, country_id) VALUES ('Moscow',1);

-- ###################################################################
-- table shops
-- ###################################################################

CREATE TABLE IF NOT EXISTS shops(
    id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    ts TIMESTAMP  DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    country_id INT UNSIGNED NOT NULL,
    region_id INT UNSIGNED NOT NULL,
    title VARCHAR(100) NOT NULL,
    shop_address VARCHAR(255) NOT NULL DEFAULT '',
    shop_folder VARCHAR(20) NOT NULL,
    hide SMALLINT(1) UNSIGNED NOT NULL DEFAULT 0,
    log_user_id INT UNSIGNED NOT NULL DEFAULT 0,
    PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS shops_log(
    id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    ts TIMESTAMP  DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    logger_event VARCHAR(50),
    log_id INT UNSIGNED,
    country_id INT UNSIGNED NOT NULL,
    region_id INT UNSIGNED NOT NULL,
    title VARCHAR(100) NOT NULL,
    shop_address VARCHAR(255) NOT NULL DEFAULT '',
    shop_folder VARCHAR(20) NOT NULL,
    hide SMALLINT(1) UNSIGNED NOT NULL DEFAULT 0,
    log_user_id INT UNSIGNED NOT NULL DEFAULT 0,
    INDEX log_id (log_id),
    INDEX log_user_id (log_user_id),
    PRIMARY KEY (id)
);

DELIMITER ;;
CREATE TRIGGER shops_log_ai AFTER INSERT ON shops FOR EACH ROW
INSERT INTO shops_log(logger_event, log_id, country_id, region_id,
                      title, shop_address, shop_folder, hide, log_user_id)
    VALUES (
           'insert',
           NEW.id,
           NEW.country_id,
           NEW.region_id,
           NEW.title,
           NEW.shop_address,
           NEW.shop_folder,
           NEW.hide,
           NEW.log_user_id
           );;
DELIMITER ;
DELIMITER ;;
CREATE TRIGGER shops_log_au AFTER UPDATE ON shops FOR EACH ROW
INSERT INTO shops_log(logger_event, log_id, country_id, region_id,
                      title, shop_address, shop_folder, hide, log_user_id)
    VALUES (
           'update',
           NEW.id,
           NEW.country_id,
           NEW.region_id,
           NEW.title,
           NEW.shop_address,
           NEW.shop_folder,
           NEW.hide,
           NEW.log_user_id
           );;
DELIMITER ;

-- ###################################################################
-- table images
-- ###################################################################

-- images
-- consent: consent to processing of personal data
CREATE TABLE IF NOT EXISTS images(
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    user_id INT UNSIGNED NOT NULL,
    shop_id INT UNSIGNED NOT NULL,
    ts TIMESTAMP  DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    date_server VARCHAR(8) NOT NULL  DEFAULT '',
    unixts_server BIGINT DEFAULT 0,
    dt_local  VARCHAR(50) NOT NULL DEFAULT '',

    image_folder VARCHAR(250) NOT NULL DEFAULT '',
    image_file VARCHAR(20) NOT NULL DEFAULT 'default.jpg',

    user_info_id BIGINT UNSIGNED NOT NULL,

    PRIMARY KEY (id),
    INDEX users (user_id),
    INDEX shops (shop_id),
    INDEX dateservers (date_server)
    
);

-- ###################################################################
-- table images
-- ###################################################################

-- images
-- the table account info stores access data
-- ip, platform, browser and version
-- of images and log_login tables
CREATE TABLE IF NOT EXISTS account_info(
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    ts TIMESTAMP  DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    date_server VARCHAR(8) NOT NULL  DEFAULT '',

    user_id INT UNSIGNED,
    image_id BIGINT UNSIGNED,
    log_login_id BIGINT UNSIGNED,

    shop_id INT UNSIGNED,

    ip VARCHAR(20),
    platform VARCHAR(20),
    browser VARCHAR(20),
    version VARCHAR(20),

    PRIMARY KEY (id),
    INDEX users (user_id),
    INDEX shops (shop_id),
    INDEX dateservers (date_server),
    INDEX ips (ip),
    INDEX platforms (platform),
    INDEX browsers (browser),
    INDEX versions (version)
);

-- logs
-- ###################################################################
-- table log_login
-- ###################################################################
CREATE TABLE IF NOT EXISTS log_login (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  ts TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  user_id INT UNSIGNED NOT NULL DEFAULT 0,
  logger_event VARCHAR(50) NOT NULL,
  email VARCHAR(255) NOT NULL,
  right_id SMALLINT UNSIGNED NOT NULL,
  user_info_id BIGINT UNSIGNED NOT NULL,

  PRIMARY KEY (id),
  INDEX users (user_id)
);
