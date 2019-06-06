-- phpMyAdmin SQL Dump
-- version 4.8.4
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jun 05, 2019 at 09:50 AM
-- Server version: 10.1.37-MariaDB
-- PHP Version: 7.3.0

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `my_aum`
--

-- --------------------------------------------------------

--
-- Table structure for table `areas`
--

CREATE TABLE `areas` (
  `area_id` smallint(5) UNSIGNED NOT NULL AUTO_INCREMENT,
  `area_name` varchar(50) NOT NULL,
  PRIMARY KEY (`area_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 AUTO_INCREMENT=2;

--
-- Dumping data for table `areas`
--

INSERT INTO `areas` (`area_id`, `area_name`) VALUES
(1, 'Test Area');

-- --------------------------------------------------------

--
-- Table structure for table `branches`
--

CREATE TABLE `branches` (
  `branch_id` smallint(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `branch_name` varchar(50) NOT NULL,
  PRIMARY KEY (`branch_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `commits`
--

CREATE TABLE `commits` (
  `commit_id` mediumint(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `creation_timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `title` varchar(100) NOT NULL,
  `description` text NOT NULL,
  `author_user_id` smallint(10) UNSIGNED NOT NULL,
  `components` text NOT NULL,
  `branch_id` smallint(10) UNSIGNED NOT NULL,
  `approval_status` enum('0','1','-1') NOT NULL DEFAULT '0',
  `approvation_timestamp` timestamp NULL DEFAULT NULL,
  `approvation_comment` text DEFAULT NULL,
  `approver_user_id` smallint(10) UNSIGNED DEFAULT NULL,
  PRIMARY KEY (`commit_id`),
  KEY `author_user_id` (`author_user_id`),
  KEY `branch_id` (`branch_id`),
  KEY `approver_user_id` (`approver_user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Triggers `commits`
--
DELIMITER $$
CREATE TRIGGER `commit_approve_insert` BEFORE INSERT ON `commits` FOR EACH ROW BEGIN
    IF NEW.approval_status = '1' OR NEW.approval_status = '-1'
    THEN SET NEW.approvation_timestamp = NOW();
    END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `commit_approve_update` BEFORE UPDATE ON `commits`
 FOR EACH ROW BEGIN
    IF NEW.approval_status = '1' OR NEW.approval_status = '-1'
    THEN SET NEW.approvation_timestamp = NOW();
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `requests`
--

CREATE TABLE `requests` (
  `request_id` mediumint(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `title` varchar(100) NOT NULL,
  `description` text NOT NULL,
  `components` text NOT NULL,
  `branch_id` smallint(10) UNSIGNED NOT NULL,
  `author_user_id` smallint(10) UNSIGNED NOT NULL,
  `creation_timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `approval_status` enum('-1','0','1','2') NOT NULL DEFAULT '0',
  `approvation_timestamp` timestamp NULL DEFAULT NULL,
  `approvation_comment` text DEFAULT NULL,
  `approver_user_id` smallint(10) UNSIGNED DEFAULT NULL,
  `sender_user_id` smallint(10) UNSIGNED DEFAULT NULL,
  `send_timestamp` timestamp NULL DEFAULT NULL,
  `install_type` enum('0','1') NOT NULL,
  `install_link` text DEFAULT NULL,
  PRIMARY KEY (`request_id`),
  KEY `author_user_id` (`author_user_id`),
  KEY `approver_user_id` (`approver_user_id`),
  KEY `branch_id` (`branch_id`),
  KEY `sender_user_id` (`sender_user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Triggers `requests`
--
DELIMITER $$
CREATE TRIGGER `request_approve_insert` BEFORE INSERT ON `requests` FOR EACH ROW BEGIN
    IF NEW.approval_status = '1' OR NEW.approval_status = '-1'
    THEN SET NEW.approvation_timestamp = NOW();
	ELSEIF NEW.approval_status = '2'
    THEN SET NEW.send_timestamp = NOW();
    END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `request_approve_update` BEFORE UPDATE ON `requests` FOR EACH ROW BEGIN
    IF NEW.approval_status = '1' OR NEW.approval_status = '-1'
    THEN SET NEW.approvation_timestamp = NOW();
	ELSEIF NEW.approval_status = '2'
    THEN SET NEW.send_timestamp = NOW();
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `requests_clients`
--

CREATE TABLE `requests_clients` (
  `request_id` mediumint(10) UNSIGNED NOT NULL,
  `client_user_id` smallint(10) UNSIGNED NOT NULL,
  `install_timestamp` timestamp NULL DEFAULT NULL,
  `install_status` enum('-1','0','1') NOT NULL DEFAULT '0',
  `comment` text DEFAULT NULL,
  PRIMARY KEY (`request_id`,`client_user_id`),
  KEY `client_user_id` (`client_user_id`),
  KEY `request_id` (`request_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `requests_commits`
--

CREATE TABLE `requests_commits` (
  `request_id` mediumint(10) UNSIGNED NOT NULL,
  `commit_id` mediumint(10) UNSIGNED NOT NULL,
  PRIMARY KEY (`request_id`,`commit_id`),
  KEY `request_id` (`request_id`),
  KEY `commit_id` (`commit_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `roles`
--

CREATE TABLE `roles` (
  `role_id` smallint(1) NOT NULL AUTO_INCREMENT,
  `role_name` varchar(25) NOT NULL,
  `role_string` varchar(50) NOT NULL,
  PRIMARY KEY (`role_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 AUTO_INCREMENT=6;

--
-- Dumping data for table `roles`
--

INSERT INTO `roles` (`role_id`, `role_name`, `role_string`) VALUES
(1, 'programmer', 'Programmer'),
(2, 'technicalAreaManager', 'Technical Area Manager'),
(3, 'revisionOfficeManager', 'Revision Office Manager'),
(4, 'client', 'Client'),
(5, 'powerUser', 'Power User');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `user_id` smallint(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `username` varchar(50) NOT NULL,
  `hash_pass` char(60) NOT NULL,
  `email` varchar(50) NOT NULL,
  `name` varchar(50) NOT NULL,
  `area_id` smallint(5) UNSIGNED DEFAULT NULL,
  PRIMARY KEY (`user_id`),
  KEY `area_id` (`area_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 AUTO_INCREMENT=2;

--
-- Dump dei dati per la tabella `users`
--

INSERT INTO `users` (`user_id`, `username`, `hash_pass`, `email`, `name`, `area_id`) VALUES
(1, 'admin', '$2y$10$autYx1CjNHiMTaMst4d/3u801S17cocdlVRle217eNjJh2b7Mff.K', 'admin@aum.com', 'Test Admin', 1);

-- --------------------------------------------------------

--
-- Table structure for table `users_roles`
--

CREATE TABLE `users_roles` (
  `user_id` smallint(10) UNSIGNED NOT NULL,
  `role_id` smallint(1) NOT NULL,
  PRIMARY KEY (`user_id`,`role_id`),
  KEY `role_id` (`role_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `users_roles`
--

INSERT INTO `users_roles` (`user_id`, `role_id`) VALUES
(1, 1),
(1, 2),
(1, 3),
(1, 4),
(1, 5);

-- --------------------------------------------------------

--
-- Table structure for table `users_tokens`
--

CREATE TABLE `users_tokens` (
  `token` char(40) NOT NULL,
  `user_id` smallint(10) UNSIGNED NOT NULL,
  `token_expire` int(10) NOT NULL,
  PRIMARY KEY (`user_id`,`token`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Constraints for table `commits`
--
ALTER TABLE `commits`
  ADD CONSTRAINT `commits_ibfk_1` FOREIGN KEY (`author_user_id`) REFERENCES `users` (`user_id`),
  ADD CONSTRAINT `commits_ibfk_3` FOREIGN KEY (`branch_id`) REFERENCES `branches` (`branch_id`),
  ADD CONSTRAINT `commits_ibfk_4` FOREIGN KEY (`approver_user_id`) REFERENCES `users` (`user_id`),
  ADD CHECK (`approval_status` != '0' AND `approver_user_id` IS NOT NULL);

--
-- Constraints for table `requests`
--
ALTER TABLE `requests`
  ADD CONSTRAINT `requests_ibfk_1` FOREIGN KEY (`author_user_id`) REFERENCES `users` (`user_id`),
  ADD CONSTRAINT `requests_ibfk_2` FOREIGN KEY (`approver_user_id`) REFERENCES `users` (`user_id`),
  ADD CONSTRAINT `requests_ibfk_3` FOREIGN KEY (`branch_id`) REFERENCES `branches` (`branch_id`),
  ADD CONSTRAINT `requests_ibfk_4` FOREIGN KEY (`sender_user_id`) REFERENCES `users` (`user_id`),
  ADD CHECK ((`approval_status` = '1' OR `approval_status` = '-1') AND `approver_user_id` IS NOT NULL),
  ADD CHECK (`approval_status` = '2' AND `approver_user_id` IS NOT NULL AND `sender_user_id` IS NOT NULL AND `install_link` IS NOT NULL);

--
-- Constraints for table `requests_clients`
--
ALTER TABLE `requests_clients`
  ADD CONSTRAINT `requests_clients_ibfk_1` FOREIGN KEY (`client_user_id`) REFERENCES `users` (`user_id`),
  ADD CONSTRAINT `requests_clients_ibfk_2` FOREIGN KEY (`request_id`) REFERENCES `requests` (`request_id`) ON DELETE CASCADE,
  ADD CHECK (`install_status` != '0' AND `install_timestamp` IS NOT NULL);

--
-- Constraints for table `requests_commits`
--
ALTER TABLE `requests_commits`
  ADD CONSTRAINT `requests_commits_ibfk_1` FOREIGN KEY (`commit_id`) REFERENCES `commits` (`commit_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `requests_commits_ibfk_2` FOREIGN KEY (`request_id`) REFERENCES `requests` (`request_id`) ON DELETE CASCADE;

--
-- Constraints for table `users`
--
ALTER TABLE `users`
  ADD CONSTRAINT `users_ibfk_1` FOREIGN KEY (`area_id`) REFERENCES `areas` (`area_id`);

--
-- Constraints for table `users_roles`
--
ALTER TABLE `users_roles`
  ADD CONSTRAINT `users_roles_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`),
  ADD CONSTRAINT `users_roles_ibfk_2` FOREIGN KEY (`role_id`) REFERENCES `roles` (`role_id`);

--
-- Constraints for table `users_tokens`
--
ALTER TABLE `users_tokens`
  ADD CONSTRAINT `users_tokens_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
