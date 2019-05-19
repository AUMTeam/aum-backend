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
) ENGINE=InnoDB  DEFAULT CHARSET=utf8mb4 AUTO_INCREMENT=3 ;

--
-- Dumping data for table `areas`
--

INSERT INTO `areas` (`area_id`, `area_name`) VALUES
(1, 'Area 1'),
(2, 'Area 2');

-- --------------------------------------------------------

--
-- Table structure for table `branches`
--

CREATE TABLE IF NOT EXISTS `branches` (
  `branch_id` smallint(10) unsigned NOT NULL AUTO_INCREMENT,
  `branch_name` varchar(50) NOT NULL,
  PRIMARY KEY (`branch_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8mb4 AUTO_INCREMENT=6 ;

--
-- Dumping data for table `branches`
--

INSERT INTO `branches` (`branch_id`, `branch_name`) VALUES
(1, 'Tres-Zap'),
(2, 'Pannier'),
(3, 'Y-find'),
(4, 'Wrapsafe'),
(5, 'Aerified');

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
) ENGINE=InnoDB  DEFAULT CHARSET=utf8mb4 AUTO_INCREMENT=101 ;

--
-- Dumping data for table `commits`
--

INSERT INTO `commits` (`commit_id`, `creation_timestamp`, `title`, `description`, `author_user_id`, `components`, `branch_id`, `approval_status`, `approvation_timestamp`, `approvation_comment`, `approver_user_id`) VALUES
(1, '2018-11-07 10:45:31', 'Michaux''s Stitchwort', 'Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis.', 2, 'Phasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum.', 2, '0', NULL, NULL, NULL),
(2, '2019-02-27 00:09:02', 'Western Black Currant', 'In quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet.', 2, 'Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus.', 1, '1', '2018-05-13 07:49:05', '', 2),
(3, '2018-09-23 11:17:51', 'Papery Schiedea', 'Vestibulum quam sapien, varius ut, blandit non, interdum in, ante. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis faucibus accumsan odio. Curabitur convallis.', 2, 'Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum.', 2, '-1', '2019-03-14 22:20:28', '', 2),
(4, '2018-12-10 20:19:47', 'Smooth Strongbark', 'Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque.', 1, 'Nullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris.', 4, '-1', '2018-07-31 23:16:22', 'Curabitur at ipsum ac tellus semper interdum. Mauris ullamcorper purus sit amet nulla. Quisque arcu libero, rutrum ac, lobortis vel, dapibus at, diam.', 2),
(5, '2018-12-27 04:17:05', 'Viscid Acacia', 'Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem.', 2, 'Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius.', 1, '0', NULL, NULL, NULL),
(6, '2018-11-13 16:14:10', 'Myelochroa Lichen', 'Fusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem.', 2, 'Curabitur at ipsum ac tellus semper interdum. Mauris ullamcorper purus sit amet nulla. Quisque arcu libero, rutrum ac, lobortis vel, dapibus at, diam.', 5, '-1', '2018-06-16 22:47:23', 'Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit.', 2),
(7, '2019-03-04 19:34:51', 'Prostrate Yellowcress', 'Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum.', 2, 'Aenean lectus. Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum.', 4, '0', NULL, NULL, NULL),
(8, '2018-05-03 17:29:02', 'Flowery Phlox', 'Curabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem.', 1, 'In hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo.', 1, '-1', '2018-10-13 00:41:22', '', 2),
(9, '2019-02-19 15:18:52', 'Spreading Bladderpod', 'In hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo.', 1, 'Proin interdum mauris non ligula pellentesque ultrices. Phasellus id sapien in sapien iaculis congue. Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl.', 2, '-1', '2018-11-21 16:16:55', '', 2),
(10, '2018-06-09 06:47:58', 'Malheur Penstemon', 'Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit.', 1, 'Phasellus in felis. Donec semper sapien a libero. Nam dui.', 4, '-1', '2018-10-22 23:12:14', 'In hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo.', 2),
(11, '2018-05-29 23:05:06', 'Box Bedstraw', 'Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti.', 1, 'Fusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem.', 2, '1', '2019-03-19 15:22:18', '', 2),
(12, '2019-01-01 02:54:09', 'Australian Tallowwood', 'Fusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem.', 1, 'Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque.', 4, '-1', '2018-07-16 06:42:16', '', 2),
(13, '2018-07-27 15:04:24', 'Bioletti''s Rush Broom', 'In hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus.', 1, 'Etiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem.', 5, '-1', '2019-04-13 00:27:03', '', 2),
(14, '2018-05-09 08:43:35', 'Broadleaf Maidenhair', 'Duis bibendum. Morbi non quam nec dui luctus rutrum. Nulla tellus.', 1, 'Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus.', 1, '1', '2019-03-29 11:20:53', '', 2),
(15, '2018-08-05 05:40:15', 'Capeweed', 'Nullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum. Integer a nibh.', 1, 'Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.', 3, '-1', '2019-02-22 11:37:14', '', 2),
(16, '2019-01-03 04:00:14', 'Narrow-leaf Bottlebrush', 'Duis consequat dui nec nisi volutpat eleifend. Donec ut dolor. Morbi vel lectus in quam fringilla rhoncus.', 1, 'Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.', 3, '1', '2018-10-09 07:54:50', 'Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat.', 2),
(17, '2019-02-11 14:22:37', 'Cracked Lichen', 'Praesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio.', 1, 'In hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo.', 1, '0', NULL, NULL, NULL),
(18, '2018-11-21 23:26:26', 'Tall Alumroot', 'Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit.', 2, 'In hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo.', 4, '1', '2018-08-23 20:32:26', '', 2),
(19, '2019-01-26 06:38:07', 'Longtongue Muhly', 'Phasellus in felis. Donec semper sapien a libero. Nam dui.', 1, 'Curabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem.', 3, '-1', '2019-04-04 22:46:56', '', 2),
(20, '2018-12-29 21:20:02', 'American Bellflower', 'Vestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat.', 2, 'Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis. Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero.', 2, '-1', '2018-09-25 00:03:26', 'In congue. Etiam justo. Etiam pretium iaculis justo.', 2),
(21, '2018-04-28 00:57:09', 'Northern Selaginella', 'Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti.', 2, 'Aenean lectus. Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum.', 3, '1', '2018-11-22 14:01:11', '', 2),
(22, '2018-07-01 00:32:32', 'Sarsparilla Vine', 'Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis. Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero.', 2, 'Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst.', 2, '1', '2018-08-11 22:31:19', '', 2),
(23, '2018-06-18 15:44:24', 'South Idaho Onion', 'In congue. Etiam justo. Etiam pretium iaculis justo.', 2, 'Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem.', 1, '-1', '2018-05-10 13:19:35', 'Proin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem.', 2),
(24, '2019-03-01 23:28:54', 'Cajeput', 'Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti.', 2, 'Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.', 3, '-1', '2018-09-16 12:50:52', '', 2),
(25, '2019-03-04 13:06:47', 'Poranopsis', 'Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit.', 1, 'Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum.', 3, '1', '2018-06-20 19:00:39', '', 2),
(26, '2018-12-21 16:41:51', 'Woolly Bluestar', 'Nullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris.', 1, 'Fusce consequat. Nulla nisl. Nunc nisl.', 4, '-1', '2018-05-16 11:28:37', 'Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin risus. Praesent lectus.', 2),
(27, '2018-12-08 14:57:59', 'Newberry''s Cinquefoil', 'Pellentesque at nulla. Suspendisse potenti. Cras in purus eu magna vulputate luctus.', 1, 'Integer ac leo. Pellentesque ultrices mattis odio. Donec vitae nisi.', 4, '0', NULL, NULL, NULL),
(28, '2018-08-12 16:30:18', 'Yampa Beardtongue', 'Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst.', 1, 'Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui.', 2, '-1', '2018-05-10 08:21:53', 'Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat.', 2),
(29, '2018-12-28 15:39:57', 'Mameyuelo', 'Nullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris.', 2, 'Nullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris.', 1, '1', '2018-05-14 10:08:22', '', 2),
(30, '2018-05-31 18:45:27', 'White Leadtree', 'Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum.', 2, 'Fusce consequat. Nulla nisl. Nunc nisl.', 4, '1', '2018-05-15 14:16:08', 'Proin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem.', 2),
(31, '2018-09-04 17:14:48', 'Nodding Chickweed', 'Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit.', 2, 'Nullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum. Integer a nibh.', 3, '0', NULL, NULL, NULL),
(32, '2018-11-08 08:48:28', 'Mat Penstemon', 'Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque.', 2, 'Phasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum.', 1, '0', NULL, NULL, NULL),
(33, '2018-06-18 12:40:15', 'Fitch''s Tarweed', 'Nulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi.', 2, 'Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla. Sed vel enim sit amet nunc viverra dapibus. Nulla suscipit ligula in lacus.', 4, '1', '2019-03-19 17:07:30', '', 2),
(34, '2018-06-15 09:27:40', 'Hawkweed', 'Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum.', 1, 'Sed ante. Vivamus tortor. Duis mattis egestas metus.', 3, '1', '2018-04-24 12:02:54', 'Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis. Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero.', 2),
(35, '2018-05-03 18:21:47', 'Cereal Rye', 'Vestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat.', 1, 'Curabitur at ipsum ac tellus semper interdum. Mauris ullamcorper purus sit amet nulla. Quisque arcu libero, rutrum ac, lobortis vel, dapibus at, diam.', 2, '1', '2018-10-21 01:29:59', 'Fusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem.', 2),
(36, '2019-02-20 15:23:47', 'Arizona Sycamore', 'Fusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem.', 2, 'Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.', 1, '0', NULL, NULL, NULL),
(37, '2019-03-13 23:54:28', 'Black Highbush Blueberry', 'Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla. Sed vel enim sit amet nunc viverra dapibus. Nulla suscipit ligula in lacus.', 1, 'Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla. Sed vel enim sit amet nunc viverra dapibus. Nulla suscipit ligula in lacus.', 1, '-1', '2018-11-21 19:28:11', '', 2),
(38, '2018-12-04 07:00:38', 'Clustered Thistle', 'Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit.', 1, 'Vestibulum quam sapien, varius ut, blandit non, interdum in, ante. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis faucibus accumsan odio. Curabitur convallis.', 4, '-1', '2018-06-23 02:34:16', '', 2),
(39, '2018-07-31 06:27:58', 'Threelocule Corchorus', 'Nullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris.', 2, 'Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus.', 2, '1', '2019-02-28 14:24:17', 'Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat.', 2),
(40, '2018-12-07 21:53:25', 'Slender Monkeyflower', 'Praesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio.', 2, 'Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius.', 3, '0', NULL, NULL, NULL),
(41, '2018-05-05 10:43:59', 'Pitseed Goosefoot', 'Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit.', 2, 'Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis.', 5, '0', NULL, NULL, NULL),
(42, '2019-02-25 08:43:51', 'Gregg''s Prairie Clover', 'Fusce consequat. Nulla nisl. Nunc nisl.', 1, 'Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla. Sed vel enim sit amet nunc viverra dapibus. Nulla suscipit ligula in lacus.', 4, '-1', '2018-07-06 15:34:21', 'Curabitur at ipsum ac tellus semper interdum. Mauris ullamcorper purus sit amet nulla. Quisque arcu libero, rutrum ac, lobortis vel, dapibus at, diam.', 2),
(43, '2019-03-29 08:40:21', 'Island Sand Pea', 'Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus.', 1, 'Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit.', 5, '1', '2018-07-20 03:05:41', 'In quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet.', 2),
(44, '2018-11-16 23:33:10', 'Madiera Cranesbill', 'Nullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum. Integer a nibh.', 2, 'Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum.', 4, '0', NULL, NULL, NULL),
(45, '2018-05-15 01:22:54', 'Tomcat Clover', 'Proin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem.', 1, 'Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque.', 3, '1', '2018-10-03 02:03:19', 'Vestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat.', 2),
(46, '2019-04-06 19:10:29', 'Mountain Monardella', 'In hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus.', 2, 'Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti.', 1, '1', '2018-11-15 12:12:40', '', 2),
(47, '2019-01-02 07:31:07', 'Hoover''s Woollystar', 'Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius.', 1, 'Nullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum. Integer a nibh.', 1, '1', '2018-12-31 00:56:29', 'Praesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio.', 2),
(48, '2018-05-04 05:54:43', 'Ivy Buttercup', 'Nulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi.', 2, 'Fusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem.', 5, '1', '2018-09-14 05:04:44', '', 2),
(49, '2019-01-27 13:32:23', 'Rattan''s Monkeyflower', 'Proin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem.', 2, 'In hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo.', 1, '0', NULL, NULL, NULL),
(50, '2018-09-16 20:02:47', 'Dragon Milkvetch', 'Proin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem.', 1, 'Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque.', 5, '0', NULL, NULL, NULL),
(51, '2018-12-02 11:30:02', 'Royal Adder''s-mouth Orchid', 'Duis bibendum. Morbi non quam nec dui luctus rutrum. Nulla tellus.', 1, 'Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit.', 3, '-1', '2018-08-10 20:34:02', 'Duis bibendum. Morbi non quam nec dui luctus rutrum. Nulla tellus.', 2),
(52, '2018-06-25 19:30:53', 'Oahu Wild Coffee', 'Fusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem.', 1, 'Duis consequat dui nec nisi volutpat eleifend. Donec ut dolor. Morbi vel lectus in quam fringilla rhoncus.', 3, '-1', '2018-06-01 07:42:22', '', 2),
(53, '2018-07-19 05:23:03', 'Del Norte Pea', 'Phasellus in felis. Donec semper sapien a libero. Nam dui.', 2, 'Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque.', 4, '0', NULL, NULL, NULL),
(54, '2019-03-01 14:17:05', 'Desert Aspicilia', 'Aenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh.', 1, 'Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum.', 1, '0', NULL, NULL, NULL),
(55, '2018-05-09 16:17:14', 'Leptodontium Moss', 'Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin risus. Praesent lectus.', 2, 'Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius.', 4, '-1', '2019-04-18 05:30:52', '', 2),
(56, '2018-12-16 06:07:00', 'Stiff Tonguefern', 'Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat.', 1, 'In sagittis dui vel nisl. Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus.', 3, '0', NULL, NULL, NULL),
(57, '2018-11-25 01:14:50', 'Sharp''s Club Lichen', 'Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum.', 1, 'Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus.', 5, '-1', '2019-01-15 06:41:53', 'Fusce consequat. Nulla nisl. Nunc nisl.', 2),
(58, '2018-09-13 19:46:02', 'Desert Willow', 'Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat.', 1, 'Vestibulum quam sapien, varius ut, blandit non, interdum in, ante. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis faucibus accumsan odio. Curabitur convallis.', 1, '0', NULL, NULL, NULL),
(59, '2018-11-21 14:19:38', 'Phoenician Juniper', 'Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti.', 2, 'Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius.', 5, '0', NULL, NULL, NULL),
(60, '2018-09-15 08:19:51', 'Venturiella Moss', 'Nullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris.', 2, 'Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis.', 2, '0', NULL, NULL, NULL),
(61, '2018-05-19 07:34:31', 'False Foxglove', 'Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius.', 2, 'Praesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio.', 1, '1', '2019-01-16 07:15:48', 'Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum.', 2),
(62, '2018-04-30 14:38:48', 'Kern Plateau Bird''s-beak', 'Duis bibendum. Morbi non quam nec dui luctus rutrum. Nulla tellus.', 1, 'Duis consequat dui nec nisi volutpat eleifend. Donec ut dolor. Morbi vel lectus in quam fringilla rhoncus.', 1, '0', NULL, NULL, NULL),
(63, '2018-07-04 01:15:44', 'Drepanocladus Moss', 'In congue. Etiam justo. Etiam pretium iaculis justo.', 1, 'Sed ante. Vivamus tortor. Duis mattis egestas metus.', 5, '-1', '2019-01-26 01:52:05', '', 2),
(64, '2019-03-05 08:57:00', 'Ring Muhly', 'Duis consequat dui nec nisi volutpat eleifend. Donec ut dolor. Morbi vel lectus in quam fringilla rhoncus.', 2, 'In hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus.', 4, '-1', '2019-01-16 08:21:31', 'Sed ante. Vivamus tortor. Duis mattis egestas metus.', 2),
(65, '2018-12-17 06:20:35', 'Gadellia', 'Vestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat.', 1, 'Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin risus. Praesent lectus.', 4, '0', NULL, NULL, NULL),
(66, '2018-08-08 09:51:14', 'Leichhardt''s Duboisia', 'Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum.', 1, 'In hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus.', 5, '1', '2019-04-10 02:25:50', 'Integer ac leo. Pellentesque ultrices mattis odio. Donec vitae nisi.', 2),
(67, '2018-11-03 19:15:04', 'Sensitive Partridge Pea', 'Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque.', 2, 'Vestibulum quam sapien, varius ut, blandit non, interdum in, ante. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis faucibus accumsan odio. Curabitur convallis.', 1, '-1', '2018-08-01 08:11:01', 'Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat.', 2),
(68, '2018-10-16 23:36:20', 'Pinellia', 'In quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet.', 1, 'Pellentesque at nulla. Suspendisse potenti. Cras in purus eu magna vulputate luctus.', 3, '-1', '2018-07-07 04:11:08', 'Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin risus. Praesent lectus.', 2),
(69, '2018-06-08 08:55:48', 'Ironweed', 'Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis.', 1, 'Nulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi.', 2, '1', '2019-02-21 21:47:52', '', 2),
(70, '2018-08-07 00:43:20', 'Streamside Leptodictyum Moss', 'Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus.', 1, 'Praesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede.', 1, '-1', '2018-10-14 10:57:34', 'Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum.', 2),
(71, '2019-02-02 16:21:27', 'Clubmoss Mousetail', 'Aenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh.', 2, 'Nullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum. Integer a nibh.', 3, '1', '2018-12-18 23:16:21', '', 2),
(72, '2018-07-14 23:21:41', 'Long''s Blackberry', 'Phasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum.', 2, 'In quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet.', 1, '1', '2018-07-23 17:28:26', '', 2),
(73, '2018-05-13 05:48:57', 'Scaly Polypody', 'In congue. Etiam justo. Etiam pretium iaculis justo.', 2, 'Fusce consequat. Nulla nisl. Nunc nisl.', 5, '1', '2018-06-02 10:10:49', '', 2),
(74, '2018-11-19 10:23:59', 'Florida Anisetree', 'Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus.', 2, 'Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla. Sed vel enim sit amet nunc viverra dapibus. Nulla suscipit ligula in lacus.', 5, '0', NULL, NULL, NULL),
(75, '2018-05-21 02:54:26', 'Kaholuamanu Schiedea', 'Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus.', 1, 'Nulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi.', 1, '1', '2019-03-03 14:52:17', '', 2),
(76, '2019-03-31 17:38:47', 'European Hawkweed', 'Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui.', 1, 'Praesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio.', 3, '0', NULL, NULL, NULL),
(77, '2018-07-29 11:59:51', 'Hulten''s Crabseye Lichen', 'Duis bibendum. Morbi non quam nec dui luctus rutrum. Nulla tellus.', 2, 'Proin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem.', 3, '-1', '2018-11-22 23:54:24', 'Duis consequat dui nec nisi volutpat eleifend. Donec ut dolor. Morbi vel lectus in quam fringilla rhoncus.', 2),
(78, '2018-05-20 23:59:19', 'Giant Blue Iris', 'Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui.', 1, 'Praesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio.', 1, '-1', '2018-07-31 06:59:54', '', 2),
(79, '2018-05-25 12:16:50', 'Grugru Palm', 'Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat.', 1, 'Vestibulum quam sapien, varius ut, blandit non, interdum in, ante. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis faucibus accumsan odio. Curabitur convallis.', 4, '1', '2018-05-26 18:56:02', '', 2),
(80, '2018-08-02 17:41:22', 'Orange Lichen', 'Curabitur at ipsum ac tellus semper interdum. Mauris ullamcorper purus sit amet nulla. Quisque arcu libero, rutrum ac, lobortis vel, dapibus at, diam.', 1, 'In congue. Etiam justo. Etiam pretium iaculis justo.', 5, '1', '2018-07-18 07:57:01', '', 2),
(81, '2019-02-18 06:35:15', 'Spanish False Fleabane', 'Curabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem.', 1, 'Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem.', 2, '1', '2019-02-11 08:33:21', 'Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat.', 2),
(82, '2019-02-05 02:14:53', 'King Protea', 'Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.', 1, 'Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla. Sed vel enim sit amet nunc viverra dapibus. Nulla suscipit ligula in lacus.', 2, '0', NULL, NULL, NULL),
(83, '2018-11-20 04:12:01', 'Bull''s Coraldrops', 'Pellentesque at nulla. Suspendisse potenti. Cras in purus eu magna vulputate luctus.', 2, 'Curabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem.', 5, '-1', '2018-06-06 04:13:19', '', 2),
(84, '2019-02-15 04:32:40', 'Wall Germander', 'Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem.', 2, 'Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla. Sed vel enim sit amet nunc viverra dapibus. Nulla suscipit ligula in lacus.', 3, '1', '2018-07-27 03:15:23', 'Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus.', 2),
(85, '2018-10-24 05:47:06', 'Jelly Lichen', 'In congue. Etiam justo. Etiam pretium iaculis justo.', 2, 'In congue. Etiam justo. Etiam pretium iaculis justo.', 1, '0', NULL, NULL, NULL),
(86, '2018-05-26 07:01:26', 'Pepperweed', 'Aenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh.', 2, 'Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla. Sed vel enim sit amet nunc viverra dapibus. Nulla suscipit ligula in lacus.', 5, '-1', '2018-06-21 15:48:13', 'Proin interdum mauris non ligula pellentesque ultrices. Phasellus id sapien in sapien iaculis congue. Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl.', 2),
(87, '2019-03-16 22:20:25', 'Polyblastia Lichen', 'Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst.', 2, 'Vestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat.', 4, '0', NULL, NULL, NULL),
(88, '2019-01-19 06:47:17', 'Koaoha', 'Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis. Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero.', 1, 'In hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus.', 2, '1', '2018-12-19 19:43:04', 'Praesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio.', 2),
(89, '2018-10-31 04:47:57', 'Sticky Whiteleaf Manzanita', 'Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum.', 2, 'Phasellus in felis. Donec semper sapien a libero. Nam dui.', 1, '0', NULL, NULL, NULL),
(90, '2018-08-06 03:59:23', 'Buckroot', 'Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit.', 1, 'Duis consequat dui nec nisi volutpat eleifend. Donec ut dolor. Morbi vel lectus in quam fringilla rhoncus.', 4, '0', NULL, NULL, NULL),
(91, '2019-03-13 00:30:51', 'Blue Elderberry', 'Duis bibendum. Morbi non quam nec dui luctus rutrum. Nulla tellus.', 2, 'Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.', 3, '-1', '2018-11-07 13:32:36', 'Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus.', 2),
(92, '2018-10-20 08:26:41', 'Late Snakeweed', 'Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.', 1, 'Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat.', 1, '0', NULL, NULL, NULL),
(93, '2019-04-08 05:42:41', 'Wahiawa Cyanea', 'Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin risus. Praesent lectus.', 1, 'Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla. Sed vel enim sit amet nunc viverra dapibus. Nulla suscipit ligula in lacus.', 3, '1', '2019-05-14 08:29:17', '', 1),
(94, '2019-01-18 09:05:53', 'Cavedwelling Evening Primrose', 'Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui.', 2, 'In sagittis dui vel nisl. Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus.', 3, '-1', '2018-07-28 03:22:02', 'Phasellus in felis. Donec semper sapien a libero. Nam dui.', 2),
(95, '2018-08-11 22:49:53', 'Appalachian Avens', 'Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat.', 2, 'Proin interdum mauris non ligula pellentesque ultrices. Phasellus id sapien in sapien iaculis congue. Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl.', 4, '0', NULL, NULL, NULL),
(96, '2018-05-15 15:37:40', 'Sycamore Fig', 'Nullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris.', 2, 'In quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet.', 5, '0', NULL, NULL, NULL),
(97, '2018-07-02 08:49:13', 'Capejewels', 'Curabitur at ipsum ac tellus semper interdum. Mauris ullamcorper purus sit amet nulla. Quisque arcu libero, rutrum ac, lobortis vel, dapibus at, diam.', 2, 'Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque.', 4, '0', NULL, NULL, NULL),
(98, '2019-04-20 20:10:45', 'Clovenlip Toadflax', 'Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin risus. Praesent lectus.', 2, 'Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est.', 5, '1', '2018-11-27 22:25:10', '', 2),
(99, '2018-10-08 15:09:07', 'Bigpod Ceanothus', 'Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus.', 2, 'Praesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede.', 5, '0', NULL, NULL, NULL),
(100, '2018-05-12 21:44:22', 'Holboell''s Rockcress', 'Nullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris.', 1, 'Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus.', 3, '1', '2018-07-20 05:58:32', '', 2);

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
) ENGINE=InnoDB  DEFAULT CHARSET=utf8mb4 AUTO_INCREMENT=101 ;

--
-- Dumping data for table `requests`
--

INSERT INTO `requests` (`request_id`, `title`, `description`, `components`, `branch_id`, `author_user_id`, `creation_timestamp`, `approval_status`, `approvation_timestamp`, `approvation_comment`, `approver_user_id`, `sender_user_id`, `send_timestamp`, `install_type`, `install_link`) VALUES
(1, 'Red-hot Cat''s Tail', 'Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat.', 'Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus.', 1, 1, '2019-04-07 02:32:50', '2', '2018-12-27 08:23:24', 'Fusce consequat. Nulla nisl. Nunc nisl.', 2, 5, '2018-11-08 13:26:33', '1', 'http://163.com/faucibus/orci/luctus/et.png'),
(2, 'Bachmanniomyces Lichen', 'Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus.', 'Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin risus. Praesent lectus.', 5, 1, '2018-11-09 20:42:47', '2', '2018-07-30 16:27:35', '', 2, 5, '2018-09-27 05:58:38', '0', 'https://usda.gov/sit/amet.jpg'),
(3, 'Southwestern White Pine Dwarf Mistletoe', 'Phasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum.', 'Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque.', 5, 1, '2018-06-05 12:54:28', '2', '2019-03-21 02:48:19', '', 2, 5, '2018-08-08 08:30:06', '1', 'https://upenn.edu/non/velit/donec.xml'),
(4, 'Branched Tearthumb', 'In hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo.', 'Duis bibendum. Morbi non quam nec dui luctus rutrum. Nulla tellus.', 5, 1, '2018-11-22 02:12:33', '-1', '2019-05-13 15:20:35', '', 2, NULL, NULL, '0', NULL),
(5, 'Touret''s Scleropodium Moss', 'In sagittis dui vel nisl. Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus.', 'Pellentesque at nulla. Suspendisse potenti. Cras in purus eu magna vulputate luctus.', 5, 2, '2019-04-01 14:53:17', '-1', '2019-05-13 15:20:35', 'Fusce consequat. Nulla nisl. Nunc nisl.', 2, NULL, NULL, '0', NULL),
(6, 'Maemon Valley Maiden Fern', 'Praesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede.', 'Pellentesque at nulla. Suspendisse potenti. Cras in purus eu magna vulputate luctus.', 4, 1, '2018-07-02 12:17:55', '1', '2019-05-13 15:20:35', '', 2, NULL, NULL, '0', NULL),
(7, 'Caliche Sandmat', 'Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit.', 'Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin risus. Praesent lectus.', 5, 1, '2018-12-03 16:31:07', '0', NULL, NULL, NULL, NULL, NULL, '0', NULL),
(8, 'Barnacle Lichen', 'Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus.', 'Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui.', 4, 1, '2018-08-28 05:59:16', '0', NULL, NULL, NULL, NULL, NULL, '0', NULL),
(9, 'Serrate Spurge', 'Aenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh.', 'Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.', 1, 2, '2019-03-27 11:48:41', '2', '2019-02-07 15:48:08', '', 2, 5, '2019-04-13 21:16:53', '0', 'https://friendfeed.com/aliquet/at/feugiat/non/pretium/quis.jsp'),
(10, 'Hitchcock''s Mock Orange', 'Praesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio.', 'Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est.', 1, 2, '2019-03-10 18:37:28', '2', '2019-05-13 15:20:35', 'In hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus.', 2, 1, '2019-05-14 12:19:52', '0', 'hhhh'),
(11, 'Northern Catalpa', 'Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst.', 'Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat.', 2, 1, '2018-05-18 02:28:28', '1', '2019-05-13 15:20:35', 'Nullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum. Integer a nibh.', 2, NULL, NULL, '0', NULL),
(12, 'Harvey''s Hawthorn', 'Phasellus in felis. Donec semper sapien a libero. Nam dui.', 'Praesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio.', 4, 2, '2018-12-08 12:17:53', '0', NULL, NULL, NULL, NULL, NULL, '1', NULL),
(13, 'Uinta Mountain Beardtongue', 'Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est.', 'Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui.', 2, 1, '2018-11-11 21:06:01', '-1', '2019-05-13 15:20:35', '', 2, NULL, NULL, '1', NULL),
(14, 'Alabama Azalea', 'Etiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem.', 'Praesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede.', 5, 2, '2018-12-30 10:27:08', '0', NULL, NULL, NULL, NULL, NULL, '0', NULL),
(15, 'Polytrichum Moss', 'In hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo.', 'Sed ante. Vivamus tortor. Duis mattis egestas metus.', 1, 2, '2018-12-26 13:12:01', '1', '2019-05-13 15:20:35', 'Praesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio.', 2, NULL, NULL, '1', NULL),
(16, 'Roundleaf Candyleaf', 'Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque.', 'Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est.', 4, 2, '2018-10-24 07:28:45', '0', NULL, NULL, NULL, NULL, NULL, '0', NULL),
(17, 'Velvetpod Mimosa', 'Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui.', 'Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum.', 3, 2, '2018-09-14 21:23:51', '0', NULL, NULL, NULL, NULL, NULL, '0', NULL),
(18, 'Forest Snakevine', 'Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.', 'Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat.', 2, 1, '2018-09-16 01:57:07', '-1', '2019-05-13 15:20:35', 'Nullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum. Integer a nibh.', 2, NULL, NULL, '0', NULL),
(19, 'Roundleaf Thoroughwort', 'Nullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris.', 'Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum.', 1, 2, '2018-05-24 09:28:31', '1', '2019-05-13 15:20:35', '', 2, NULL, NULL, '1', NULL),
(20, 'Rimmed Navel Lichen', 'Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti.', 'Phasellus in felis. Donec semper sapien a libero. Nam dui.', 1, 1, '2018-12-14 09:02:23', '2', '2019-01-17 17:59:32', '', 2, 5, '2019-02-23 07:54:35', '1', 'http://java.com/nulla/facilisi/cras/non/velit/nec.aspx'),
(21, 'Obscure Shield Lichen', 'Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.', 'Vestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat.', 5, 1, '2018-08-23 14:28:23', '1', '2019-05-13 15:20:35', '', 2, NULL, NULL, '0', NULL),
(22, 'Widow''s-thrill', 'Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti.', 'Fusce consequat. Nulla nisl. Nunc nisl.', 3, 1, '2018-09-23 23:06:14', '-1', '2019-05-13 15:20:35', 'Proin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem.', 2, NULL, NULL, '1', NULL),
(23, 'Akolea', 'Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est.', 'Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit.', 5, 1, '2019-02-05 16:15:02', '1', '2019-05-13 15:20:35', '', 2, NULL, NULL, '1', NULL),
(24, 'Cracked Lichen', 'In hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus.', 'In hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo.', 3, 1, '2018-06-08 16:34:33', '0', NULL, NULL, NULL, NULL, NULL, '1', NULL),
(25, 'Whitewhorl Lupine', 'Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti.', 'Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst.', 2, 2, '2018-11-01 09:13:59', '-1', '2019-05-13 15:20:35', 'Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst.', 2, NULL, NULL, '0', NULL),
(26, 'Wright''s Cudweed', 'Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus.', 'In congue. Etiam justo. Etiam pretium iaculis justo.', 2, 2, '2018-11-17 22:10:23', '1', '2019-05-13 15:20:35', '', 2, NULL, NULL, '0', NULL),
(27, 'Texas Xanthopsorella Lichen', 'Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin risus. Praesent lectus.', 'In congue. Etiam justo. Etiam pretium iaculis justo.', 5, 2, '2018-06-28 02:13:41', '-1', '2019-05-13 15:20:35', 'Curabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem.', 2, NULL, NULL, '0', NULL),
(28, 'Stebbins'' Lewisia', 'Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus.', 'Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti.', 2, 2, '2018-07-16 16:53:57', '-1', '2019-05-13 15:20:35', 'Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit.', 2, NULL, NULL, '0', NULL),
(29, 'Clamshell Orchid', 'Aenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh.', 'Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est.', 1, 2, '2019-01-29 10:43:20', '1', '2019-05-13 15:20:35', 'In quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet.', 2, NULL, NULL, '1', NULL),
(30, 'Blue-fly Honeysuckle', 'Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.', 'Proin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem.', 5, 2, '2019-01-05 09:27:17', '0', NULL, NULL, NULL, NULL, NULL, '0', NULL),
(31, 'Shortstalk Bristle Fern', 'In congue. Etiam justo. Etiam pretium iaculis justo.', 'Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est.', 3, 2, '2019-04-04 08:10:11', '1', '2019-05-13 15:20:35', '', 2, NULL, NULL, '1', NULL),
(32, 'Narrowleaf Dock', 'Phasellus in felis. Donec semper sapien a libero. Nam dui.', 'In quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet.', 4, 1, '2018-12-15 07:48:49', '0', NULL, NULL, NULL, NULL, NULL, '0', NULL),
(33, 'Clinton''s Bulrush', 'Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin risus. Praesent lectus.', 'Nullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum. Integer a nibh.', 1, 2, '2018-05-28 04:20:36', '2', '2018-11-20 15:52:39', 'Phasellus in felis. Donec semper sapien a libero. Nam dui.', 2, 5, '2018-05-30 08:15:42', '1', 'https://ovh.net/ut/rhoncus/aliquet.aspx'),
(34, 'Soldierwood', 'Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem.', 'Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus.', 1, 2, '2018-11-06 16:50:41', '1', '2019-05-13 15:20:35', 'Fusce consequat. Nulla nisl. Nunc nisl.', 2, NULL, NULL, '0', NULL),
(35, 'Horsehair Lichen', 'Proin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem.', 'Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti.', 3, 2, '2018-09-08 13:11:38', '0', NULL, NULL, NULL, NULL, NULL, '0', NULL),
(36, 'Ehrenberg''s Vervain', 'Phasellus in felis. Donec semper sapien a libero. Nam dui.', 'Pellentesque at nulla. Suspendisse potenti. Cras in purus eu magna vulputate luctus.', 1, 1, '2018-05-04 01:50:41', '2', '2019-02-25 08:34:46', '', 2, 5, '2018-11-26 22:38:20', '0', 'http://vk.com/egestas/metus.html'),
(37, 'Rimmed Lichen', 'Praesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede.', 'Vestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat.', 1, 1, '2018-12-01 01:00:59', '1', '2019-05-13 15:20:35', 'Proin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem.', 2, NULL, NULL, '1', NULL),
(38, 'High Mountain Penstemon', 'Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum.', 'Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus.', 3, 1, '2018-09-29 01:38:17', '2', '2019-03-12 06:08:36', '', 2, 5, '2019-02-13 12:47:30', '0', 'https://ted.com/eget/orci.png'),
(39, 'Rosette Lichen', 'Pellentesque at nulla. Suspendisse potenti. Cras in purus eu magna vulputate luctus.', 'Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst.', 2, 2, '2019-01-29 02:01:02', '2', '2019-02-07 01:47:43', 'Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque.', 2, 5, '2018-05-13 01:12:06', '0', 'http://facebook.com/sapien/urna/pretium/nisl.html'),
(40, 'Mecca Woodyaster', 'Nullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum. Integer a nibh.', 'Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum.', 1, 1, '2018-08-06 18:13:47', '1', '2019-05-13 15:20:35', '', 2, NULL, NULL, '0', NULL),
(41, 'California Biddy-biddy', 'Vestibulum quam sapien, varius ut, blandit non, interdum in, ante. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis faucibus accumsan odio. Curabitur convallis.', 'Duis consequat dui nec nisi volutpat eleifend. Donec ut dolor. Morbi vel lectus in quam fringilla rhoncus.', 1, 2, '2018-05-29 05:09:10', '1', '2019-05-13 15:20:35', 'Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis.', 2, NULL, NULL, '0', NULL),
(42, 'Black Crowberry', 'Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem.', 'Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus.', 3, 2, '2019-04-14 16:24:35', '1', '2019-05-13 15:20:35', 'Nullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris.', 2, NULL, NULL, '0', NULL),
(43, 'Hooker''s Scratchdaisy', 'Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat.', 'Sed ante. Vivamus tortor. Duis mattis egestas metus.', 3, 2, '2018-10-19 22:18:49', '2', '2019-01-09 14:44:18', '', 2, 5, '2019-02-18 13:28:26', '0', 'https://disqus.com/odio.jpg'),
(44, 'Shortspur Seablush', 'Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis.', 'Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat.', 3, 2, '2018-11-11 08:02:22', '1', '2019-05-13 15:20:35', 'Vestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat.', 2, NULL, NULL, '1', NULL),
(45, 'Calthaleaf Phacelia', 'Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est.', 'Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque.', 5, 1, '2018-10-25 10:27:15', '2', '2019-01-03 18:32:31', 'Fusce consequat. Nulla nisl. Nunc nisl.', 2, 5, '2018-10-17 10:17:43', '0', 'https://goo.ne.jp/ut/ultrices.jsp'),
(46, 'Florida Keys Indian Mallow', 'In hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus.', 'Aenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh.', 1, 1, '2018-06-18 09:53:01', '2', '2018-07-08 18:19:39', 'Proin interdum mauris non ligula pellentesque ultrices. Phasellus id sapien in sapien iaculis congue. Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl.', 2, 5, '2018-05-17 02:40:33', '0', 'https://google.ru/molestie/hendrerit/at/vulputate/vitae/nisl/aenean.jpg'),
(47, 'Hairy Cupgrass', 'Vestibulum quam sapien, varius ut, blandit non, interdum in, ante. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis faucibus accumsan odio. Curabitur convallis.', 'Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum.', 1, 1, '2019-03-25 19:21:59', '1', '2019-05-13 15:20:35', '', 2, NULL, NULL, '1', NULL),
(48, 'Dracontomelon', 'Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis.', 'In quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet.', 3, 1, '2019-02-01 10:56:28', '1', '2019-05-13 15:20:35', '', 2, NULL, NULL, '0', NULL),
(49, 'Marsh Mermaidweed', 'Curabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem.', 'Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui.', 4, 1, '2018-05-22 19:26:38', '0', NULL, NULL, NULL, NULL, NULL, '0', NULL),
(50, 'Pergularia', 'Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti.', 'Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat.', 2, 1, '2018-10-18 20:48:03', '-1', '2019-05-13 15:20:35', 'Integer ac leo. Pellentesque ultrices mattis odio. Donec vitae nisi.', 2, NULL, NULL, '1', NULL),
(51, 'Schistophragma', 'Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus.', 'Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit.', 3, 2, '2018-04-24 22:50:01', '2', '2018-08-18 02:32:15', '', 2, 5, '2018-08-14 13:21:08', '1', 'https://icq.com/vestibulum/sit/amet/cursus.png'),
(52, 'Oldpasture Bluegrass', 'Pellentesque at nulla. Suspendisse potenti. Cras in purus eu magna vulputate luctus.', 'Fusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem.', 1, 1, '2018-07-21 18:42:13', '1', '2019-05-13 15:20:35', '', 2, NULL, NULL, '0', NULL),
(53, 'Colorado Xanthoparmelia Lichen', 'Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit.', 'Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti.', 1, 2, '2019-02-15 06:35:07', '-1', '2019-05-13 15:20:35', '', 2, NULL, NULL, '0', NULL),
(54, 'Geyer''s Oniongrass', 'Sed ante. Vivamus tortor. Duis mattis egestas metus.', 'Vestibulum quam sapien, varius ut, blandit non, interdum in, ante. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis faucibus accumsan odio. Curabitur convallis.', 1, 1, '2019-03-29 12:38:27', '2', '2019-02-28 14:48:29', 'Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis.', 2, 5, '2018-07-06 04:10:48', '0', 'http://globo.com/proin/eu/mi.html'),
(55, 'Stebbins'' Desertdandelion', 'Nullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum. Integer a nibh.', 'Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst.', 5, 1, '2018-07-14 01:51:20', '0', NULL, NULL, NULL, NULL, NULL, '0', NULL),
(56, 'Pondweed', 'Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.', 'Integer ac leo. Pellentesque ultrices mattis odio. Donec vitae nisi.', 2, 1, '2018-04-26 02:11:53', '-1', '2019-05-13 15:20:35', '', 2, NULL, NULL, '1', NULL),
(57, 'Rock Indian Breadroot', 'Nullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris.', 'Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis. Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero.', 2, 2, '2018-12-02 02:57:20', '1', '2019-05-13 15:20:35', 'Proin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem.', 2, NULL, NULL, '0', NULL),
(58, 'Yellow Loosestrife', 'Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti.', 'Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem.', 2, 1, '2019-04-14 06:00:13', '0', NULL, NULL, NULL, NULL, NULL, '0', NULL),
(59, 'Red Baneberry', 'Vestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat.', 'Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis. Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero.', 1, 1, '2018-07-21 05:19:47', '2', '2018-05-02 12:44:59', 'Proin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem.', 2, 5, '2018-06-08 05:44:57', '0', 'http://bing.com/fusce/lacus/purus/aliquet/at/feugiat/non.aspx'),
(60, 'Pinewoods Drymary', 'Proin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem.', 'Phasellus in felis. Donec semper sapien a libero. Nam dui.', 5, 1, '2018-05-09 04:38:10', '-1', '2019-05-13 15:20:35', '', 2, NULL, NULL, '1', NULL),
(61, 'Hedge False Bindweed', 'Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est.', 'Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat.', 5, 1, '2018-05-09 09:20:48', '2', '2018-08-16 01:10:08', '', 2, 5, '2018-09-10 12:36:07', '0', 'http://ocn.ne.jp/morbi/vel/lectus/in.html'),
(62, 'Northwestern Twayblade', 'Vestibulum quam sapien, varius ut, blandit non, interdum in, ante. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis faucibus accumsan odio. Curabitur convallis.', 'Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus.', 2, 1, '2019-01-05 03:39:07', '-1', '2019-05-13 15:20:35', 'Proin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem.', 2, NULL, NULL, '1', NULL),
(63, 'Paperflower', 'Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus.', 'Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque.', 5, 1, '2018-12-08 18:04:23', '1', '2019-05-13 15:20:35', 'Praesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio.', 2, NULL, NULL, '0', NULL),
(64, 'Sweetpotato', 'Fusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem.', 'Curabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem.', 1, 1, '2018-10-12 09:20:36', '-1', '2019-05-13 15:20:35', '', 2, NULL, NULL, '1', NULL),
(65, 'Chiricahua Mountain Dock', 'Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla. Sed vel enim sit amet nunc viverra dapibus. Nulla suscipit ligula in lacus.', 'Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla. Sed vel enim sit amet nunc viverra dapibus. Nulla suscipit ligula in lacus.', 2, 2, '2018-09-15 00:05:44', '0', NULL, NULL, NULL, NULL, NULL, '0', NULL),
(66, 'Chrysothemis', 'In quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet.', 'Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.', 2, 1, '2018-07-11 15:04:44', '2', '2018-06-11 00:05:20', 'Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius.', 2, 5, '2018-09-13 17:36:12', '1', 'https://prlog.org/tortor/id.jpg'),
(67, 'Blair''s Wirelettuce', 'Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat.', 'Phasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum.', 5, 1, '2018-07-27 11:42:31', '2', '2019-04-15 03:01:56', '', 2, 5, '2018-07-12 10:02:09', '1', 'http://mozilla.org/morbi/vel/lectus/in/quam/fringilla.json'),
(68, 'Manchurian Honeysuckle', 'Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin risus. Praesent lectus.', 'Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit.', 4, 1, '2018-10-21 19:51:35', '-1', '2019-05-13 15:20:35', '', 2, NULL, NULL, '0', NULL),
(69, 'Fierce Spaniard', 'Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.', 'Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin risus. Praesent lectus.', 5, 1, '2018-08-08 13:37:42', '1', '2019-05-13 15:20:35', 'Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst.', 2, NULL, NULL, '1', NULL),
(70, 'Britton''s Shadow Witch', 'Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum.', 'Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis.', 4, 1, '2019-03-07 13:14:16', '-1', '2019-05-13 15:20:35', 'Fusce consequat. Nulla nisl. Nunc nisl.', 2, NULL, NULL, '1', NULL),
(71, 'Yellow Willowherb', 'Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui.', 'Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla. Sed vel enim sit amet nunc viverra dapibus. Nulla suscipit ligula in lacus.', 4, 2, '2019-04-06 10:16:24', '-1', '2019-05-13 15:20:35', 'Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius.', 2, NULL, NULL, '1', NULL),
(72, 'Florida Star Orchid', 'Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est.', 'Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem.', 1, 2, '2018-11-11 03:25:48', '2', '2018-07-02 11:15:10', 'Curabitur at ipsum ac tellus semper interdum. Mauris ullamcorper purus sit amet nulla. Quisque arcu libero, rutrum ac, lobortis vel, dapibus at, diam.', 2, 5, '2019-02-23 13:11:15', '0', 'https://diigo.com/in/tempus/sit.js'),
(73, 'Graceful Fern', 'Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit.', 'Vestibulum quam sapien, varius ut, blandit non, interdum in, ante. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis faucibus accumsan odio. Curabitur convallis.', 4, 1, '2019-01-19 00:47:06', '1', '2019-05-13 15:20:35', 'Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui.', 2, NULL, NULL, '0', NULL),
(74, 'California Polypody', 'In hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus.', 'Praesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio.', 3, 1, '2018-04-29 20:27:28', '1', '2019-05-13 15:20:35', 'Phasellus in felis. Donec semper sapien a libero. Nam dui.', 2, NULL, NULL, '1', NULL),
(75, 'Belembe Silvestre', 'Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis.', 'In hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo.', 4, 1, '2018-06-07 00:03:16', '0', NULL, NULL, NULL, NULL, NULL, '0', NULL),
(76, 'Tuberous Springbeauty', 'Vestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat.', 'Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.', 4, 2, '2019-02-12 13:39:46', '-1', '2019-05-13 15:20:35', '', 2, NULL, NULL, '1', NULL),
(77, 'California Eryngo', 'In hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo.', 'Etiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem.', 4, 2, '2019-01-28 13:51:17', '0', NULL, NULL, NULL, NULL, NULL, '1', NULL),
(78, 'Lophospermum', 'Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit.', 'Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem.', 2, 2, '2019-02-11 07:54:15', '-1', '2019-05-13 15:20:35', '', 2, NULL, NULL, '0', NULL),
(79, 'Fivelobe St. Johnswort', 'Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst.', 'Etiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem.', 5, 2, '2018-12-25 06:46:37', '1', '2019-05-13 15:20:35', 'Fusce consequat. Nulla nisl. Nunc nisl.', 2, NULL, NULL, '1', NULL),
(80, 'Tulare Cryptantha', 'Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst.', 'Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst.', 1, 1, '2018-11-26 21:10:22', '1', '2019-05-13 15:20:35', '', 2, NULL, NULL, '1', NULL),
(81, 'Littleleaf Pixiemoss', 'Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst.', 'In hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus.', 1, 2, '2019-03-10 12:16:29', '2', '2019-03-19 10:06:35', 'Phasellus in felis. Donec semper sapien a libero. Nam dui.', 2, 5, '2018-08-10 14:48:58', '0', 'http://geocities.com/cubilia/curae/duis/faucibus/accumsan/odio/curabitur.png'),
(82, 'Montagne''s Cartilage Lichen', 'Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti.', 'Phasellus in felis. Donec semper sapien a libero. Nam dui.', 2, 1, '2018-05-24 18:15:58', '1', '2019-05-13 15:20:35', '', 2, NULL, NULL, '1', NULL),
(83, 'Pear-leaf Nightshade', 'Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque.', 'In hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus.', 5, 1, '2018-05-08 21:37:21', '1', '2019-05-13 15:20:35', 'Vestibulum quam sapien, varius ut, blandit non, interdum in, ante. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis faucibus accumsan odio. Curabitur convallis.', 2, NULL, NULL, '0', NULL),
(84, 'Yellow And Purple Monkeyflower', 'Vestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat.', 'Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.', 1, 2, '2018-11-02 11:22:31', '0', NULL, NULL, NULL, NULL, NULL, '1', NULL),
(85, 'Emory''s Barrel Cactus', 'In hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus.', 'In hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus.', 5, 2, '2019-03-02 22:18:38', '1', '2019-05-13 15:20:35', 'Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui.', 2, NULL, NULL, '0', NULL),
(86, 'Wiegand''s Wildrye', 'Vestibulum quam sapien, varius ut, blandit non, interdum in, ante. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis faucibus accumsan odio. Curabitur convallis.', 'Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.', 1, 1, '2018-10-29 10:38:12', '0', NULL, NULL, NULL, NULL, NULL, '0', NULL),
(87, 'Bailey''s Sedge', 'Aenean lectus. Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum.', 'Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst.', 3, 1, '2018-06-06 13:21:55', '1', '2019-05-13 15:20:35', 'Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus.', 2, NULL, NULL, '1', NULL),
(88, 'Needle Lichen', 'Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est.', 'Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est.', 5, 1, '2018-07-17 19:31:52', '-1', '2019-05-13 15:20:35', '', 2, NULL, NULL, '0', NULL),
(89, 'Juan Tomas', 'Etiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem.', 'Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem.', 3, 1, '2019-02-22 23:30:08', '-1', '2019-05-13 15:20:35', 'Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit.', 2, NULL, NULL, '0', NULL),
(90, 'Redroot Amaranth', 'Proin interdum mauris non ligula pellentesque ultrices. Phasellus id sapien in sapien iaculis congue. Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl.', 'Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit.', 4, 2, '2018-08-06 19:05:15', '-1', '2019-05-13 15:20:35', 'Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis.', 2, NULL, NULL, '1', NULL),
(91, 'Stahl''s Valamuerto', 'Integer ac leo. Pellentesque ultrices mattis odio. Donec vitae nisi.', 'Fusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem.', 3, 2, '2018-12-08 23:22:20', '1', '2019-05-13 15:20:35', 'Nulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi.', 2, NULL, NULL, '0', NULL),
(92, 'Gaspè Peninsula Bluegrass', 'Vestibulum quam sapien, varius ut, blandit non, interdum in, ante. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis faucibus accumsan odio. Curabitur convallis.', 'Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis.', 5, 1, '2018-06-24 15:14:55', '-1', '2019-05-13 18:41:10', '', 2, NULL, NULL, '0', NULL),
(93, 'California Jointfir', 'Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin risus. Praesent lectus.', 'Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est.', 1, 1, '2018-11-15 01:38:04', '1', '2019-05-13 15:20:35', 'Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit.', 2, NULL, NULL, '0', NULL),
(94, 'Elmer''s Erigeron', 'Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis. Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero.', 'Phasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum.', 3, 2, '2018-05-06 20:51:32', '2', '2018-11-16 06:07:42', '', 2, 5, '2019-01-10 12:16:29', '0', 'https://answers.com/at/ipsum/ac/tellus/semper/interdum.aspx'),
(95, 'Poeltinula Lichen', 'Vestibulum quam sapien, varius ut, blandit non, interdum in, ante. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis faucibus accumsan odio. Curabitur convallis.', 'Praesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede.', 1, 1, '2018-10-13 05:38:41', '0', NULL, NULL, NULL, NULL, NULL, '1', NULL),
(96, 'Northpark Phacelia', 'Integer ac leo. Pellentesque ultrices mattis odio. Donec vitae nisi.', 'Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.', 3, 1, '2018-07-12 03:59:31', '1', '2019-05-13 15:20:35', '', 2, NULL, NULL, '0', NULL),
(97, 'Feltleaf Willow', 'Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.', 'Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti.', 3, 1, '2018-05-24 14:32:12', '0', NULL, NULL, NULL, NULL, NULL, '0', NULL),
(98, 'Hairy Gumweed', 'Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin risus. Praesent lectus.', 'Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat.', 4, 1, '2018-06-16 14:35:34', '0', NULL, NULL, NULL, NULL, NULL, '1', NULL),
(99, 'Rim Lichen', 'Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.', 'Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus.', 4, 2, '2019-01-16 20:01:27', '-1', '2019-05-13 15:20:35', '', 2, NULL, NULL, '0', NULL),
(100, 'Oahu Stenogyne', 'Fusce consequat. Nulla nisl. Nunc nisl.', 'Proin interdum mauris non ligula pellentesque ultrices. Phasellus id sapien in sapien iaculis congue. Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl.', 4, 1, '2018-11-28 02:47:22', '-1', '2019-05-13 15:20:35', '', 2, NULL, NULL, '1', NULL);

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

--
-- Dumping data for table `requests_clients`
--

INSERT INTO `requests_clients` (`request_id`, `client_user_id`, `install_timestamp`, `install_status`, `comment`) VALUES
(2, 3, '2019-05-08 14:11:04', '1', 'Test Feedback'),
(36, 3, '2019-05-13 04:18:20', '-1', NULL),
(43, 3, '2018-07-02 09:51:06', '1', 'Duis consequat dui nec nisi volutpat eleifend. Donec ut dolor. Morbi vel lectus in quam fringilla rhoncus.'),
(45, 3, NULL, '0', NULL),
(59, 3, '2018-12-18 06:44:00', '1', 'Aenean lectus. Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum.'),
(72, 3, NULL, '0', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `requests_commits`
--

CREATE TABLE IF NOT EXISTS `requests_commits` (
  `request_id` mediumint(10) unsigned NOT NULL,
  `commit_id` mediumint(10) unsigned NOT NULL,
  PRIMARY KEY (`request_id`,`commit_id`),
  KEY `request_id` (`request_id`),
  KEY `commit_id` (`commit_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `requests_commits`
--

INSERT INTO `requests_commits` (`request_id`, `commit_id`) VALUES
(70, 2),
(96, 2),
(5, 3),
(28, 3),
(70, 3),
(5, 4),
(41, 4),
(70, 4),
(84, 4),
(58, 6),
(97, 7),
(60, 8),
(29, 9),
(64, 9),
(75, 9),
(79, 9),
(10, 10),
(42, 11),
(58, 11),
(72, 11),
(81, 11),
(33, 13),
(6, 14),
(9, 14),
(32, 14),
(41, 14),
(57, 14),
(99, 14),
(70, 17),
(76, 17),
(11, 18),
(85, 18),
(27, 19),
(73, 19),
(83, 19),
(92, 19),
(78, 20),
(100, 20),
(16, 21),
(44, 21),
(65, 22),
(50, 23),
(73, 23),
(95, 23),
(98, 23),
(51, 24),
(89, 24),
(48, 25),
(81, 25),
(100, 26),
(81, 27),
(23, 28),
(69, 28),
(19, 29),
(3, 30),
(53, 30),
(69, 30),
(46, 31),
(18, 32),
(39, 32),
(9, 33),
(13, 33),
(4, 34),
(5, 34),
(23, 34),
(76, 34),
(8, 36),
(55, 36),
(29, 37),
(34, 37),
(47, 39),
(49, 39),
(88, 39),
(12, 40),
(1, 41),
(25, 41),
(66, 41),
(31, 43),
(7, 45),
(81, 45),
(87, 45),
(93, 45),
(6, 46),
(82, 46),
(83, 46),
(5, 47),
(88, 47),
(8, 48),
(18, 48),
(40, 49),
(73, 49),
(14, 50),
(20, 50),
(40, 50),
(25, 51),
(52, 51),
(24, 52),
(27, 52),
(59, 52),
(72, 52),
(21, 53),
(25, 53),
(87, 53),
(81, 55),
(66, 56),
(25, 57),
(94, 57),
(87, 58),
(48, 60),
(52, 60),
(96, 60),
(71, 61),
(73, 61),
(15, 62),
(57, 62),
(73, 62),
(49, 63),
(73, 63),
(80, 63),
(57, 64),
(99, 64),
(22, 65),
(23, 65),
(25, 65),
(63, 65),
(43, 66),
(7, 67),
(8, 67),
(1, 68),
(16, 68),
(1, 69),
(17, 69),
(33, 69),
(42, 69),
(1, 71),
(9, 71),
(84, 71),
(82, 72),
(44, 73),
(54, 74),
(70, 74),
(85, 74),
(50, 75),
(85, 75),
(26, 76),
(71, 76),
(100, 76),
(82, 77),
(87, 77),
(47, 78),
(37, 79),
(72, 79),
(13, 80),
(82, 80),
(83, 81),
(91, 81),
(73, 82),
(92, 82),
(92, 83),
(7, 84),
(54, 86),
(13, 87),
(17, 87),
(21, 87),
(35, 88),
(38, 88),
(76, 89),
(78, 89),
(11, 90),
(29, 90),
(35, 90),
(54, 91),
(88, 91),
(11, 92),
(77, 92),
(3, 93),
(38, 93),
(55, 94),
(62, 94),
(64, 95),
(6, 96),
(19, 96),
(28, 96),
(79, 96),
(29, 97),
(44, 97),
(55, 98),
(72, 98),
(58, 99),
(83, 99),
(8, 100),
(12, 100),
(16, 100);

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
) ENGINE=InnoDB  DEFAULT CHARSET=utf8mb4 AUTO_INCREMENT=7 ;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`user_id`, `username`, `hash_pass`, `email`, `name`, `area_id`) VALUES
(1, 'admin', '$2y$10$autYx1CjNHiMTaMst4d/3u801S17cocdlVRle217eNjJh2b7Mff.K', 'admin@aum.com', 'Test Admin', 1),
(2, 'dev.test', '$2y$10$Gg0OqF4eAldpoVWXXUmYhOIKLrTPb16Fi6ep/abA1WRDyTFIG5XO6', 'dev@aum.com', 'Test Developer', 2),
(3, 'client.test', '$2y$10$dsomsW5qwK/zouHftaRCw.JsdQZbPDhikljNc/TYPjF7TXjXY2BP2', 'client@aum.com', 'Test Client User', NULL),
(4, 'repTech.test', '$2y$10$RjgQcskq7ud8/VRQCb5Ecu7Wc.gBIBYqPNaXpKFWDTep72R8wVJdy', 'repTech@aum.com', 'Test Tech Area User', 1),
(5, 'rev.test', '$2y$10$OUHuTMosbb0ICAPoy9xcfeznZ2Wdnt7cPg53Z6kDvxtuec.t8WVrG', 'revOffice@aum.com', 'Revision Office Test', 1);

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
(2, 1),
(1, 2),
(4, 2),
(1, 3),
(5, 3),
(1, 4),
(3, 4),
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
-- Dumping data for table `users_tokens`
--

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
