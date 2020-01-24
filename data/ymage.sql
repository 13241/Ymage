-- phpMyAdmin SQL Dump
-- version 4.8.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jan 24, 2020 at 05:45 PM
-- Server version: 10.1.33-MariaDB
-- PHP Version: 7.2.6

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `ymage`
--
CREATE DATABASE IF NOT EXISTS `ymage` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;
USE `ymage`;

-- --------------------------------------------------------

--
-- Table structure for table `attempts`
--

CREATE TABLE `attempts` (
  `attemptedPwrEffect` decimal(6,3) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `currentPwrItem` decimal(6,3) NOT NULL,
  `currentReliquat` decimal(6,3) NOT NULL,
  `id` int(11) NOT NULL,
  `idEffect` int(11) NOT NULL,
  `idItem` int(11) NOT NULL,
  `result` enum('ns','ce','cs') NOT NULL,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `changesonattempt`
--

CREATE TABLE `changesonattempt` (
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `idAttempt` int(11) NOT NULL,
  `idEffect` int(11) NOT NULL,
  `pwrAfter` decimal(6,3) NOT NULL,
  `pwrBefore` decimal(6,3) NOT NULL,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `effects`
--

CREATE TABLE `effects` (
  `basic` int(6) NOT NULL DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `effect` varchar(50) NOT NULL,
  `id` int(11) NOT NULL,
  `pa` int(6) NOT NULL DEFAULT '0',
  `pwrPerUnit` decimal(6,3) NOT NULL DEFAULT '0.000',
  `ra` int(6) NOT NULL DEFAULT '0',
  `rune` varchar(50) NOT NULL,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `effects`
--

INSERT INTO `effects` (`basic`, `created_at`, `effect`, `id`, `pa`, `pwrPerUnit`, `ra`, `rune`, `updated_at`) VALUES
(1, '2020-01-24 16:37:33', 'Agilité', 2, 3, '1.000', 10, 'Age', '2020-01-24 16:37:33'),
(1, '2020-01-24 16:37:33', 'Chance', 3, 3, '1.000', 10, 'Cha', '2020-01-24 16:37:33'),
(1, '2020-01-24 16:37:33', 'Force', 4, 3, '1.000', 10, 'Fo', '2020-01-24 16:37:33'),
(1, '2020-01-24 16:37:33', 'Intelligence', 5, 3, '1.000', 10, 'Ine', '2020-01-24 16:37:33'),
(10, '2020-01-24 16:37:33', 'Initiative', 6, 30, '0.100', 100, 'Ini', '2020-01-24 16:37:33'),
(10, '2020-01-24 16:37:33', 'Pods', 7, 30, '0.250', 100, 'Pod', '2020-01-24 16:37:33'),
(5, '2020-01-24 16:37:33', 'Vitalité', 8, 15, '0.200', 50, 'Vi', '2020-01-24 16:37:33'),
(0, '2020-01-24 16:37:33', 'Arme de chasse', 9, 0, '5.000', 0, 'de chasse', '2020-01-24 16:37:33'),
(1, '2020-01-24 16:37:33', 'Puissance (pièges)', 10, 3, '2.000', 10, 'Pi Per', '2020-01-24 16:37:33'),
(1, '2020-01-24 16:37:33', 'Prospection', 11, 3, '3.000', 0, 'Prospe', '2020-01-24 16:37:33'),
(1, '2020-01-24 16:37:33', 'Puissance', 12, 3, '2.000', 10, 'Pui', '2020-01-24 16:37:33'),
(1, '2020-01-24 16:37:33', 'Sagesse', 13, 3, '3.000', 10, 'Sa', '2020-01-24 16:37:33'),
(1, '2020-01-24 16:37:33', 'Résistance Air', 14, 3, '2.000', 0, 'Ré Air', '2020-01-24 16:37:33'),
(1, '2020-01-24 16:37:33', 'Résistance Critiques', 15, 3, '2.000', 0, 'Ré Cri', '2020-01-24 16:37:33'),
(1, '2020-01-24 16:37:33', 'Résistance Eau', 16, 3, '2.000', 0, 'Ré Eau', '2020-01-24 16:37:33'),
(1, '2020-01-24 16:37:33', 'Résistance Feu', 17, 3, '2.000', 0, 'Ré Feu', '2020-01-24 16:37:33'),
(1, '2020-01-24 16:37:33', 'Résistance Neutre', 18, 3, '2.000', 0, 'Ré Neutre', '2020-01-24 16:37:33'),
(1, '2020-01-24 16:37:33', 'Résistance Poussée', 19, 3, '2.000', 0, 'Ré Pou', '2020-01-24 16:37:33'),
(1, '2020-01-24 16:37:33', 'Résistance Terre', 20, 3, '2.000', 0, 'Ré Terre', '2020-01-24 16:37:33'),
(1, '2020-01-24 16:37:33', 'Dommages Air', 21, 3, '5.000', 0, 'Do Air', '2020-01-24 16:37:33'),
(1, '2020-01-24 16:37:33', 'Dommages Critiques', 22, 3, '5.000', 0, 'Do Cri', '2020-01-24 16:37:33'),
(1, '2020-01-24 16:37:33', 'Dommages Eau', 23, 3, '5.000', 0, 'Do Eau', '2020-01-24 16:37:33'),
(1, '2020-01-24 16:37:33', 'Dommages Feu', 24, 3, '5.000', 0, 'Do Feu', '2020-01-24 16:37:33'),
(1, '2020-01-24 16:37:33', 'Dommages Neutre', 25, 3, '5.000', 0, 'Do Neutre', '2020-01-24 16:37:33'),
(1, '2020-01-24 16:37:33', 'Dommages Poussée', 26, 3, '5.000', 0, 'Do Pou', '2020-01-24 16:37:33'),
(1, '2020-01-24 16:37:33', 'Renvoie ! dommages', 27, 0, '10.000', 0, 'Do Ren', '2020-01-24 16:37:33'),
(1, '2020-01-24 16:37:33', 'Dommages Terre', 28, 3, '5.000', 0, 'Do Terre', '2020-01-24 16:37:33'),
(1, '2020-01-24 16:37:33', 'Dommages Pièges', 29, 3, '5.000', 0, 'Pi', '2020-01-24 16:37:33'),
(1, '2020-01-24 16:37:33', 'Dommages', 30, 0, '20.000', 0, 'Do', '2020-01-24 16:37:33'),
(1, '2020-01-24 16:37:34', '% Dommages d\'armes', 31, 0, '15.000', 0, 'Do Per Ar', '2020-01-24 16:37:34'),
(1, '2020-01-24 16:37:34', '% Dommages distance', 32, 0, '15.000', 0, 'Do Per Di', '2020-01-24 16:37:34'),
(1, '2020-01-24 16:37:34', '% Dommages mêlée', 33, 0, '15.000', 0, 'Do Per Mé', '2020-01-24 16:37:34'),
(1, '2020-01-24 16:37:34', '% Dommages aux sorts', 34, 0, '15.000', 0, 'Do Per So', '2020-01-24 16:37:34'),
(1, '2020-01-24 16:37:34', '% Résistance distance', 35, 0, '15.000', 0, 'Ré Per Di', '2020-01-24 16:37:34'),
(1, '2020-01-24 16:37:34', '% Résistance mêlée', 36, 0, '15.000', 0, 'Ré Per Mé', '2020-01-24 16:37:34'),
(1, '2020-01-24 16:37:34', 'Fuite', 37, 3, '4.000', 0, 'Fui', '2020-01-24 16:37:34'),
(1, '2020-01-24 16:37:34', 'Tacle', 38, 3, '4.000', 0, 'Tac', '2020-01-24 16:37:34'),
(1, '2020-01-24 16:37:34', 'Retrait PA', 39, 3, '7.000', 0, 'Ret Pa', '2020-01-24 16:37:34'),
(1, '2020-01-24 16:37:34', 'Retrait PM', 40, 3, '7.000', 0, 'Ret Pme', '2020-01-24 16:37:34'),
(1, '2020-01-24 16:37:34', 'Esquive PA', 41, 3, '7.000', 0, 'Ré Pa', '2020-01-24 16:37:34'),
(1, '2020-01-24 16:37:34', 'Esquive PM', 42, 3, '7.000', 0, 'Ré Pme', '2020-01-24 16:37:34'),
(1, '2020-01-24 16:37:34', '% Résistance Air', 43, 0, '6.000', 0, 'Ré Per Air', '2020-01-24 16:37:34'),
(1, '2020-01-24 16:37:34', '% Résistance Eau', 44, 0, '6.000', 0, 'Ré Per Eau', '2020-01-24 16:37:34'),
(1, '2020-01-24 16:37:34', '% Résistance Feu', 45, 0, '6.000', 0, 'Ré Per Feu', '2020-01-24 16:37:34'),
(1, '2020-01-24 16:37:34', '% Résistance Neutre', 46, 0, '6.000', 0, 'Ré Per Neutre', '2020-01-24 16:37:34'),
(1, '2020-01-24 16:37:34', '% Résistance Terre', 47, 0, '6.000', 0, 'Ré Per Terre', '2020-01-24 16:37:34'),
(1, '2020-01-24 16:37:34', '% Critique', 48, 0, '10.000', 0, 'Cri', '2020-01-24 16:37:34'),
(1, '2020-01-24 16:37:34', 'Soins', 49, 0, '10.000', 0, 'So', '2020-01-24 16:37:34'),
(1, '2020-01-24 16:37:34', 'Invocations', 50, 0, '30.000', 0, 'Invo', '2020-01-24 16:37:34'),
(1, '2020-01-24 16:37:34', 'Portée', 51, 0, '51.000', 0, 'Po', '2020-01-24 16:37:34'),
(1, '2020-01-24 16:37:34', 'PM', 52, 0, '90.000', 0, 'Ga Pme', '2020-01-24 16:37:34'),
(1, '2020-01-24 16:37:34', 'PA', 53, 0, '100.000', 0, 'Ga Pa', '2020-01-24 16:37:34'),
(0, '2020-01-24 16:37:34', '(dommages Neutre)', 54, 0, '0.000', 0, '', '2020-01-24 16:37:34'),
(0, '2020-01-24 16:37:34', '(dommages Terre)', 55, 0, '0.000', 0, '', '2020-01-24 16:37:34'),
(0, '2020-01-24 16:37:34', '(dommages Feu)', 56, 0, '0.000', 0, '', '2020-01-24 16:37:34'),
(0, '2020-01-24 16:37:34', '(dommages Eau)', 57, 0, '0.000', 0, '', '2020-01-24 16:37:34'),
(0, '2020-01-24 16:37:34', '(dommages Air)', 58, 0, '0.000', 0, '', '2020-01-24 16:37:34'),
(0, '2020-01-24 16:37:34', '(vol Neutre)', 59, 0, '0.000', 0, '', '2020-01-24 16:37:34'),
(0, '2020-01-24 16:37:34', '(vol Terre)', 60, 0, '0.000', 0, '', '2020-01-24 16:37:34'),
(0, '2020-01-24 16:37:34', '(vol Feu)', 61, 0, '0.000', 0, '', '2020-01-24 16:37:34'),
(0, '2020-01-24 16:37:34', '(vol Eau)', 62, 0, '0.000', 0, '', '2020-01-24 16:37:34'),
(0, '2020-01-24 16:37:34', '(vol Air)', 63, 0, '0.000', 0, '', '2020-01-24 16:37:34'),
(0, '2020-01-24 16:37:34', '(PV rendus)', 64, 0, '0.000', 0, '', '2020-01-24 16:37:34');

-- --------------------------------------------------------

--
-- Table structure for table `items`
--

CREATE TABLE `items` (
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `id` int(11) NOT NULL,
  `level` int(6) NOT NULL,
  `maxPwr` decimal(6,3) NOT NULL,
  `name` varchar(50) NOT NULL,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `itemseffects`
--

CREATE TABLE `itemseffects` (
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `idEffect` int(11) NOT NULL,
  `idItem` int(11) NOT NULL,
  `maxPwr` decimal(6,3) NOT NULL,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `attempts`
--
ALTER TABLE `attempts`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `changesonattempt`
--
ALTER TABLE `changesonattempt`
  ADD PRIMARY KEY (`idAttempt`,`idEffect`);

--
-- Indexes for table `effects`
--
ALTER TABLE `effects`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `items`
--
ALTER TABLE `items`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `itemseffects`
--
ALTER TABLE `itemseffects`
  ADD PRIMARY KEY (`idEffect`,`idItem`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `attempts`
--
ALTER TABLE `attempts`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `effects`
--
ALTER TABLE `effects`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=65;

--
-- AUTO_INCREMENT for table `items`
--
ALTER TABLE `items`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
