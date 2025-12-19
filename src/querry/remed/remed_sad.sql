-- Active: 1747977627544@@127.0.0.1@3306@cleaning_system
-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Generation Time: Dec 19, 2025 at 03:07 AM
-- Server version: 10.4.21-MariaDB
-- PHP Version: 8.1.6

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `remed_sad`
--

-- --------------------------------------------------------

--
-- Table structure for table `comment`
--

CREATE TABLE `comment` (
  `id` int(11) NOT NULL,
  `id_user` int(11) NOT NULL,
  `id_gambar` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `gambar`
--

CREATE TABLE `gambar` (
  `id` int(11) NOT NULL,
  `judul` varchar(50) NOT NULL,
  `caption` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `like`
--

CREATE TABLE `like` (
  `id` int(11) NOT NULL,
  `id_user` int(11) NOT NULL,
  `id_gambar` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `pengguna`
--

CREATE TABLE `pengguna` (
  `id` int(11) NOT NULL,
  `nama` varchar(20) NOT NULL,
  `username` varchar(20) NOT NULL,
  `password` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `post`
--

CREATE TABLE `post` (
  `id` int(11) NOT NULL,
  `id_user` int(11) NOT NULL,
  `id_gambar` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `comment`
--
ALTER TABLE `comment`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_user_like` (`id_user`),
  ADD KEY `fk_content_like` (`id_gambar`);

--
-- Indexes for table `gambar`
--
ALTER TABLE `gambar`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `like`
--
ALTER TABLE `like`
  ADD KEY `fk_user_like` (`id_user`),
  ADD KEY `fk_content_like` (`id_gambar`);

--
-- Indexes for table `pengguna`
--
ALTER TABLE `pengguna`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `post`
--
ALTER TABLE `post`
  ADD KEY `fk_user_like` (`id_user`),
  ADD KEY `fk_content_like` (`id_gambar`);

--
-- Constraints for dumped tables
--

--
-- Constraints for table `comment`
--
ALTER TABLE `comment`
  ADD CONSTRAINT `fk_gambar_comment` FOREIGN KEY (`id_gambar`) REFERENCES `gambar` (`id`),
  ADD CONSTRAINT `fk_user_comment` FOREIGN KEY (`id_user`) REFERENCES `pengguna` (`id`);

--
-- Constraints for table `like`
--
ALTER TABLE `like`
  ADD CONSTRAINT `fk_content_like` FOREIGN KEY (`id_gambar`) REFERENCES `gambar` (`id`) ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_user_like` FOREIGN KEY (`id_user`) REFERENCES `pengguna` (`id`) ON UPDATE NO ACTION;

--
-- Constraints for table `post`
--
ALTER TABLE `post`
  ADD CONSTRAINT `fk_gambar_post` FOREIGN KEY (`id_gambar`) REFERENCES `gambar` (`id`),
  ADD CONSTRAINT `fk_user_post` FOREIGN KEY (`id_user`) REFERENCES `pengguna` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
