USE jam_fp_db;

-- DROP USER 'asim';
CREATE USER 'asim'@'%' IDENTIFIED BY 'asimk123';
GRANT ALL PRIVILEGES ON `jam_fp_db`.* TO 'asim'@'%';

-- DROP USER 'jenny';
CREATE USER 'jenny'@'%' IDENTIFIED BY 'jennyk123';
GRANT ALL PRIVILEGES ON `jam_fp_db`.* TO 'jenny'@'%';