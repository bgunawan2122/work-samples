#WORK SAMPLE: CREATING STAR SCHEMA FOR URBAN PLANNING BASED ON EV POPULATION PROJECT

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema ev_schema
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema ev_schema
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `ev_schema` DEFAULT CHARACTER SET utf8 ;
USE `ev_schema` ;

-- -----------------------------------------------------
-- Table `ev_schema`.`ev_population`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ev_schema`.`ev_population` (
  `population_id` INT NOT NULL,
  `zipcode` VARCHAR(45) NOT NULL,
  `city` VARCHAR(45) NULL,
  `count` VARCHAR(45) NOT NULL,
  `date` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`population_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ev_schema`.`demographics`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ev_schema`.`demographics` (
  `zip_demo` VARCHAR(10) NOT NULL,
  `geo_id` VARCHAR(45) NOT NULL,
  `name` VARCHAR(45) NOT NULL,
  `median_income` VARCHAR(45) NOT NULL,
  `edu_less_than_9th_grade` VARCHAR(45) NOT NULL,
  `edu_9th_to_12th_grade_no_diploma` VARCHAR(45) NOT NULL,
  `edu_high_school_graduate` VARCHAR(45) NOT NULL,
  `edu_some_college_no_degree` VARCHAR(45) NOT NULL,
  `edu_associates_degree` VARCHAR(45) NOT NULL,
  `edu_bachelors_degree` VARCHAR(45) NOT NULL,
  `edu_graduate_or_professional_degree` VARCHAR(45) NOT NULL,
  `race_pct_white_only` VARCHAR(45) NOT NULL,
  `race_pct_black_affrican_american_only` VARCHAR(45) NOT NULL,
  `race_pct_native_american_alaska_native_only` VARCHAR(45) NOT NULL,
  `race_pct_asian_only` VARCHAR(45) NOT NULL,
  `race_pct_native_hawaiian_pac_islander_only` VARCHAR(45) NOT NULL,
  `race_pct_some_other_race` VARCHAR(45) NOT NULL,
  `race_pct_two_or_more_races` VARCHAR(45) NOT NULL,
  `ethnicity_pct_hispanic_or_latino` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`zip_demo`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ev_schema`.`ev_stations`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ev_schema`.`ev_stations` (
  `station_id` VARCHAR(45) NOT NULL,
  `zip_station` VARCHAR(10) NOT NULL,
  `station_address` VARCHAR(45) NOT NULL,
  `station_name` VARCHAR(45) NOT NULL,
  `intersection_directions` VARCHAR(45) NULL,
  `city` VARCHAR(45) NOT NULL,
  `state` VARCHAR(45) NOT NULL,
  `status_code` VARCHAR(45) NOT NULL,
  `station_phone` INT NOT NULL,
  `expected_date` DATE NULL,
  `groups_with_access_code` VARCHAR(45) NULL,
  `access_days_time` VARCHAR(45) NULL,
  `cards_accepted` VARCHAR(45) NULL,
  `ev_level1_evse_num` VARCHAR(45) NULL,
  `ev_level2_evse_num` VARCHAR(45) NULL,
  `ev_dc_fast_count` VARCHAR(45) NULL,
  `ev_other_info` VARCHAR(45) NULL,
  `ev_network` VARCHAR(45) NOT NULL,
  `ev_network_web` VARCHAR(45) NULL,
  `geocode_status` VARCHAR(45) NOT NULL,
  `latitude` FLOAT NOT NULL,
  `longitude` FLOAT NOT NULL,
  `date_last_confirmed` DATE NULL,
  `updated_at` DATETIME NULL,
  `owner_type_code` VARCHAR(45) NULL,
  `federal_agency_id` VARCHAR(45) NULL,
  `federal_agency_name` VARCHAR(45) NULL,
  `open_date` DATE NULL,
  `ev_connector_types` VARCHAR(45) NULL,
  `access_code` VARCHAR(45) NULL,
  `access_detail_code` VARCHAR(45) NULL,
  `federal_agency_code` VARCHAR(45) NULL,
  `facility_type` VARCHAR(45) NULL,
  `ev_pricing` VARCHAR(45) NULL,
  `ev_on-site_renewable_source` VARCHAR(45) NULL,
  `restricted_access` VARCHAR(45) NULL,
  PRIMARY KEY (`station_id`))
ENGINE = InnoDB;

CREATE INDEX `zip_station` ON `ev_schema`.`ev_stations` (`zip_station` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `ev_schema`.`fact_ev`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ev_schema`.`fact_ev` (
  `zip_key(PK)` INT NOT NULL,
  `population_id` INT NOT NULL,
  `zip_demo` VARCHAR(10) NOT NULL,
  `zip_station` VARCHAR(10) NOT NULL,
  `count_level_2_chargers` VARCHAR(45) NOT NULL,
  `count_dc_fast_chargers` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`zip_key(PK)`),
  CONSTRAINT `population_id`
    FOREIGN KEY (`population_id`)
    REFERENCES `ev_schema`.`ev_population` (`population_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `zip_demo`
    FOREIGN KEY (`zip_demo`)
    REFERENCES `ev_schema`.`demographics` (`zip_demo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `zip_stations`
    FOREIGN KEY (`zip_station`)
    REFERENCES `ev_schema`.`ev_stations` (`zip_station`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `population_id_idx` ON `ev_schema`.`fact_ev` (`population_id` ASC) VISIBLE;

CREATE INDEX `zip_demo_idx` ON `ev_schema`.`fact_ev` (`zip_demo` ASC) VISIBLE;

CREATE INDEX `zip_stations_idx` ON `ev_schema`.`fact_ev` (`zip_station` ASC) VISIBLE;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
