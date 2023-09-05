-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Sep 05, 2023 at 09:25 AM
-- Server version: 10.4.25-MariaDB
-- PHP Version: 8.1.10

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `rental_room`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `room_rental_report` ()   BEGIN
    SELECT * FROM rent_detail;
    SELECT room_popularity() AS room_status;
END$$

--
-- Functions
--
CREATE DEFINER=`root`@`localhost` FUNCTION `room_status` (`rented_count` INT) RETURNS VARCHAR(15) CHARSET utf8mb4  BEGIN
    IF rented_count >= 2 THEN
        RETURN 'PALING LAKU';
    ELSE
        RETURN 'KURANG LAKU';
    END IF;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `customer`
--

CREATE TABLE `customer` (
  `id` int(11) NOT NULL,
  `name` varchar(150) NOT NULL,
  `Alamat` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `customer`
--

INSERT INTO `customer` (`id`, `name`, `Alamat`) VALUES
(1, 'Muhammad Iqbal Gobel', 'Cipinang, Pulogadung, Jakarta Timur, DKI Jakarta'),
(2, 'Amadeo Arlen M', 'Bekasi, Jawa Barat'),
(3, 'Kevin Febri Dwi', 'Cimanggis, Depok, Jawa Barat'),
(4, 'Muhamad Ridwan', 'Bekasi, Jawa Barat'),
(5, 'Muhammad Aljabbaar Baiqunni', 'Bojong Gede, Kab. Bogor, Bogor, Jawa Barat'),
(6, 'Rofyan Luthfi Mafaza', 'Kelapa Dua, Depok, Jawa Barat');

-- --------------------------------------------------------

--
-- Table structure for table `rent`
--

CREATE TABLE `rent` (
  `id` int(11) NOT NULL,
  `room_id` int(11) NOT NULL,
  `customer_id` int(11) NOT NULL,
  `start_date` date NOT NULL,
  `end_date` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `rent`
--

INSERT INTO `rent` (`id`, `room_id`, `customer_id`, `start_date`, `end_date`) VALUES
(59230001, 1, 1, '2023-09-05', '2023-09-06'),
(59230002, 6, 6, '2023-09-05', '2023-09-06'),
(59230003, 5, 3, '2023-09-05', '2023-09-06'),
(59230004, 1, 5, '2023-09-05', '2023-09-06');

--
-- Triggers `rent`
--
DELIMITER $$
CREATE TRIGGER `room_count_update` AFTER INSERT ON `rent` FOR EACH ROW BEGIN
    UPDATE room
    SET rented_count = rented_count + 1
    WHERE id = NEW.room_id;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Stand-in structure for view `rent_detail`
-- (See below for the actual view)
--
CREATE TABLE `rent_detail` (
`id` int(11)
,`customer` varchar(150)
,`room` varchar(255)
,`duration` bigint(21)
);

-- --------------------------------------------------------

--
-- Table structure for table `room`
--

CREATE TABLE `room` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `rented_count` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `room`
--

INSERT INTO `room` (`id`, `name`, `rented_count`) VALUES
(1, 'Room by kelly, Lagoon Avenue Bekasi', 2),
(2, 'Room by Kenzie Group, Margonda Residence 2', 0),
(3, 'John Roomstay by John, Kalibata City', 0),
(4, 'Roomstay by Ellie, Green Pramuka City', 0),
(5, 'Ibis Hotel Senen Jakpus', 1),
(6, 'Aston Hotel Pluit Jakarta Utara', 1);

-- --------------------------------------------------------

--
-- Structure for view `rent_detail`
--
DROP TABLE IF EXISTS `rent_detail`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `rent_detail`  AS SELECT `rent`.`id` AS `id`, `customer`.`name` AS `customer`, `room`.`name` AS `room`, timestampdiff(DAY,`rent`.`start_date`,`rent`.`end_date`) AS `duration` FROM ((`rent` join `customer` on(`rent`.`customer_id` = `customer`.`id`)) join `room` on(`rent`.`room_id` = `room`.`id`))  ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `customer`
--
ALTER TABLE `customer`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `rent`
--
ALTER TABLE `rent`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `room`
--
ALTER TABLE `room`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `customer`
--
ALTER TABLE `customer`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `rent`
--
ALTER TABLE `rent`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=59230005;

--
-- AUTO_INCREMENT for table `room`
--
ALTER TABLE `room`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
