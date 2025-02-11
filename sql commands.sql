-- Database: onlinestock
CREATE DATABASE IF NOT EXISTS `onlinestock` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;
USE `onlinestock`;

-- Table structure for table `child_user`
CREATE TABLE `child_user` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(255) DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL,
  `master_user` int(11) NOT NULL,
  `admin` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `master_user` (`master_user`),
  CONSTRAINT `child_user_ibfk_1` FOREIGN KEY (`master_user`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Table structure for table `inventory`
CREATE TABLE `inventory` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `inventory_name` text,
  `userid` int(11) DEFAULT NULL,
  `lockowner` int(11) DEFAULT NULL,
  `lockdate` datetime DEFAULT NULL,
  `rlock` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `userid` (`userid`),
  CONSTRAINT `inventory_ibfk_1` FOREIGN KEY (`userid`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Table structure for table `item`
CREATE TABLE `item` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` text,
  `location` text,
  `stock` int(11) DEFAULT NULL,
  `itemnotification` tinyint(1) NOT NULL DEFAULT '0',
  `lessthan` int(11) DEFAULT NULL,
  `inventoryid` int(11) DEFAULT NULL,
  `rlock` tinyint(1) NOT NULL DEFAULT '0',
  `lockowner` int(11) DEFAULT NULL,
  `lockdate` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `inventoryid` (`inventoryid`),
  CONSTRAINT `item_ibfk_1` FOREIGN KEY (`inventoryid`) REFERENCES `inventory` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Table structure for table `notification`
CREATE TABLE `notification` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` text,
  `lessthan` int(11) DEFAULT NULL,
  `inventoryid` int(11) DEFAULT NULL,
  `rlock` tinyint(1) NOT NULL DEFAULT '0',
  `lockowner` int(11) DEFAULT NULL,
  `lockdate` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `inventoryid` (`inventoryid`),
  CONSTRAINT `notification_ibfk_1` FOREIGN KEY (`inventoryid`) REFERENCES `inventory` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Table structure for table `session`
CREATE TABLE `session` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `userid` int(11) DEFAULT NULL,
  `logintoken` text,
  `logindate` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `validdate` datetime DEFAULT NULL,
  `child_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `userid` (`userid`),
  CONSTRAINT `session_ibfk_1` FOREIGN KEY (`userid`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Table structure for table `users`
CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `email` text,
  `phone` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Structure for view `item2`
CREATE OR REPLACE VIEW `item2` AS 
SELECT 
  `it`.`id`,
  `it`.`name`,
  `it`.`location`,
  `it`.`stock`,
  `it`.`itemnotification`,
  `it`.`lessthan`,
  `it`.`inventoryid`,
  `it`.`rlock`,
  `it`.`lockowner`,
  `it`.`lockdate`,
  `i`.`userid`
FROM 
  `item` `it`
  JOIN `inventory` `i` ON `it`.`inventoryid` = `i`.`id`;

-- Structure for view `notification2`
CREATE OR REPLACE VIEW `notification2` AS 
SELECT 
  `n`.`id`,
  `n`.`name`,
  `n`.`lessthan`,
  `n`.`inventoryid`,
  `n`.`rlock`,
  `n`.`lockowner`,
  `n`.`lockdate`,
  `i`.`userid`
FROM 
  `notification` `n`
  JOIN `inventory` `i` ON `n`.`inventoryid` = `i`.`id`;

-- Structure for view `users2`
CREATE OR REPLACE VIEW `users2` AS 
SELECT 
  `u`.`id` AS `master_id`,
  `u`.`email`,
  `u`.`phone`,
  `c`.`id` AS `child_id`,
  `c`.`username`,
  `c`.`password`,
  `c`.`admin`
FROM 
  `users` `u`
  LEFT JOIN `child_user` `c` ON `u`.`id` = `c`.`master_user`;
