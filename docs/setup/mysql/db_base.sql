-- phpMyAdmin SQL Dump
-- version 4.1.7
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: May 15, 2019 at 10:57 AM
-- Server version: 5.6.33-log
-- PHP Version: 5.3.10

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `my_aum`
--

-- --------------------------------------------------------

--
-- Table structure for table `areas`
--

CREATE TABLE IF NOT EXISTS `areas` (
  `area_id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `area_name` varchar(50) NOT NULL,
  PRIMARY KEY (`area_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8mb4 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `branches`
--

CREATE TABLE IF NOT EXISTS `branches` (
  `branch_id` smallint(10) unsigned NOT NULL AUTO_INCREMENT,
  `branch_name` varchar(50) NOT NULL,
  PRIMARY KEY (`branch_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8mb4 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `commits`
--

CREATE TABLE IF NOT EXISTS `commits` (
  `commit_id` mediumint(10) unsigned NOT NULL AUTO_INCREMENT,
  `creation_timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `title` varchar(100) NOT NULL,
  `description` text NOT NULL,
  `author_user_id` smallint(10) unsigned NOT NULL,
  `components` text NOT NULL,
  `branch_id` smallint(10) unsigned NOT NULL,
  `approval_status` enum('0','1','-1') NOT NULL DEFAULT '0',
  `approvation_timestamp` timestamp NULL DEFAULT NULL,
  `approvation_comment` text,
  `approver_user_id` smallint(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`commit_id`),
  KEY `author_user_id` (`author_user_id`),
  KEY `branch_id` (`branch_id`),
  KEY `approver_user_id` (`approver_user_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8mb4 AUTO_INCREMENT=1 ;

--
-- Triggers `commits`
--
DROP TRIGGER IF EXISTS `commit_approve`;
DELIMITER //
CREATE TRIGGER `commit_approve` BEFORE UPDATE ON `commits`
 FOR EACH ROW BEGIN
    IF NEW.approval_status = '1' OR NEW.approval_status = '-1'
    THEN SET NEW.approvation_timestamp = NOW();
    END IF;
END
//
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `requests`
--

CREATE TABLE IF NOT EXISTS `requests` (
  `request_id` mediumint(10) unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(100) NOT NULL,
  `description` text NOT NULL,
  `components` text NOT NULL,
  `branch_id` smallint(10) unsigned NOT NULL,
  `author_user_id` smallint(10) unsigned NOT NULL,
  `creation_timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `approval_status` enum('-1','0','1','2') NOT NULL DEFAULT '0',
  `approvation_timestamp` timestamp NULL DEFAULT NULL,
  `approvation_comment` text,
  `approver_user_id` smallint(10) unsigned DEFAULT NULL,
  `sender_user_id` smallint(10) unsigned DEFAULT NULL,
  `send_timestamp` timestamp NULL DEFAULT NULL,
  `install_type` enum('0','1') NOT NULL,
  `install_link` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`request_id`),
  KEY `author_user_id` (`author_user_id`),
  KEY `approver_user_id` (`approver_user_id`),
  KEY `branch_id` (`branch_id`),
  KEY `sender_user_id` (`sender_user_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8mb4 AUTO_INCREMENT=1 ;

--
-- Triggers `requests`
--
DROP TRIGGER IF EXISTS `request_approve`;
DELIMITER //
CREATE TRIGGER `request_approve` BEFORE UPDATE ON `requests`
 FOR EACH ROW BEGIN
    IF NEW.approval_status = '1' OR NEW.approval_status = '-1'
    THEN SET NEW.approvation_timestamp = NOW();
    END IF;
END
//
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `requests_clients`
--

CREATE TABLE IF NOT EXISTS `requests_clients` (
  `request_id` mediumint(10) unsigned NOT NULL,
  `client_user_id` smallint(10) unsigned NOT NULL,
  `install_timestamp` timestamp NULL DEFAULT NULL,
  `install_status` enum('-1','0','1') NOT NULL DEFAULT '0',
  `comment` text,
  PRIMARY KEY (`request_id`,`client_user_id`),
  KEY `client_user_id` (`client_user_id`),
  KEY `request_id` (`request_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `requests_commits`
--

CREATE TABLE IF NOT EXISTS `requests_commits` (
  `request_id` mediumint(10) unsigned NOT NULL,
  `commit_id` mediumint(10) unsigned NOT NULL,
  PRIMARY KEY (`request_id`,`commit_id`),
  KEY `commit_id` (`commit_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `roles`
--

CREATE TABLE IF NOT EXISTS `roles` (
  `role_id` smallint(1) NOT NULL AUTO_INCREMENT,
  `role_name` varchar(25) NOT NULL,
  `role_string` varchar(50) NOT NULL,
  PRIMARY KEY (`role_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8mb4 AUTO_INCREMENT=6 ;

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

CREATE TABLE IF NOT EXISTS `users` (
  `user_id` smallint(10) unsigned NOT NULL AUTO_INCREMENT,
  `username` varchar(30) NOT NULL,
  `hash_pass` varchar(255) NOT NULL,
  `email` varchar(50) NOT NULL,
  `name` varchar(50) NOT NULL,
  `area_id` smallint(5) unsigned DEFAULT NULL,
  PRIMARY KEY (`user_id`),
  KEY `area_id` (`area_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8mb4 AUTO_INCREMENT=2 ;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`user_id`, `username`, `hash_pass`, `email`, `name`, `area_id`) VALUES
(1, 'admin', '$2y$10$autYx1CjNHiMTaMst4d/3u801S17cocdlVRle217eNjJh2b7Mff.K', 'admin@aum.com', 'Test Admin', 1);

-- --------------------------------------------------------

--
-- Table structure for table `users_roles`
--

CREATE TABLE IF NOT EXISTS `users_roles` (
  `user_id` smallint(10) unsigned NOT NULL,
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

CREATE TABLE IF NOT EXISTS `users_tokens` (
  `token` varchar(100) NOT NULL,
  `user_id` smallint(10) unsigned NOT NULL,
  `token_expire` int(10) NOT NULL,
  PRIMARY KEY (`user_id`,`token`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `commits`
--
ALTER TABLE `commits`
  ADD CONSTRAINT `commits_ibfk_1` FOREIGN KEY (`author_user_id`) REFERENCES `users` (`user_id`),
  ADD CONSTRAINT `commits_ibfk_3` FOREIGN KEY (`branch_id`) REFERENCES `branches` (`branch_id`),
  ADD CONSTRAINT `commits_ibfk_4` FOREIGN KEY (`approver_user_id`) REFERENCES `users` (`user_id`);

--
-- Constraints for table `requests`
--
ALTER TABLE `requests`
  ADD CONSTRAINT `requests_ibfk_1` FOREIGN KEY (`author_user_id`) REFERENCES `users` (`user_id`),
  ADD CONSTRAINT `requests_ibfk_2` FOREIGN KEY (`approver_user_id`) REFERENCES `users` (`user_id`),
  ADD CONSTRAINT `requests_ibfk_4` FOREIGN KEY (`branch_id`) REFERENCES `branches` (`branch_id`),
  ADD CONSTRAINT `requests_ibfk_5` FOREIGN KEY (`sender_user_id`) REFERENCES `users` (`user_id`);

--
-- Constraints for table `requests_clients`
--
ALTER TABLE `requests_clients`
  ADD CONSTRAINT `requests_clients_ibfk_1` FOREIGN KEY (`client_user_id`) REFERENCES `users` (`user_id`),
  ADD CONSTRAINT `requests_clients_ibfk_2` FOREIGN KEY (`request_id`) REFERENCES `requests` (`request_id`);

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

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
