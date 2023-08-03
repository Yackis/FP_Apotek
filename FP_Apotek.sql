-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Aug 03, 2023 at 11:41 AM
-- Server version: 10.4.27-MariaDB
-- PHP Version: 8.2.0

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `test`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_show_obat_status` ()   BEGIN
DECLARE done INT DEFAULT FALSE;
DECLARE obat_id INT;
DECLARE obat_nama VARCHAR(255);
DECLARE obat_kategori VARCHAR(255);
DECLARE obat_harga INT;
DECLARE obat_stok INT;
DECLARE obat_status VARCHAR(10);
-- Declare a cursor to fetch data from the obat table
DECLARE obat_cursor CURSOR FOR
SELECT id_obat, nama_obat, kategori, harga, stok
FROM obat;
-- Declare handler for the cursor
DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
-- Create a temporary table to store the results
CREATE TEMPORARY TABLE IF NOT EXISTS temp_obat_status (
id_obat INT,
nama_obat VARCHAR(255),
kategori VARCHAR(255),
harga INT,
stok INT,
status VARCHAR(10)
);
OPEN obat_cursor;
-- Loop through the cursor and process each row
cursor_loop: LOOP
FETCH obat_cursor INTO obat_id, obat_nama, obat_kategori, obat_harga, obat_stok;
IF done THEN
LEAVE cursor_loop;
END IF;
-- Check if stok is 0 or not and set the status accordingly
IF obat_stok = 0 THEN
SET obat_status = 'Habis';
ELSE
SET obat_status = 'Tersedia';
END IF;
-- Insert the row with status into the temporary table
INSERT INTO temp_obat_status (id_obat, nama_obat, kategori, harga, stok, status)
VALUES (obat_id, obat_nama, obat_kategori, obat_harga, obat_stok, obat_status);
END LOOP;
CLOSE obat_cursor;
-- Select data from the temporary table
SELECT * FROM temp_obat_status;
-- Drop the temporary table
DROP TEMPORARY TABLE IF EXISTS temp_obat_status;
END$$

--
-- Functions
--
CREATE DEFINER=`root`@`localhost` FUNCTION `tambahsupplier` (`paramid_supplier` VARCHAR(255), `paramid_obat` INT(100), `paramtelepon` VARCHAR(255), `paramnama_supplier` VARCHAR(255)) RETURNS INT(11)  BEGIN 
DECLARE new_id INT; 
INSERT INTO supplier_obat (id_supplier, id_obat,
telepon, nama_supplier) 
SELECT paramid_supplier, paramid_obat,
paramtelepon, paramnama_supplier; 
SET new_id =
LAST_INSERT_ID(); 
RETURN new_id; 
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `detail_transaksi`
--

CREATE TABLE `detail_transaksi` (
  `id_detail` int(100) NOT NULL,
  `id_transaksi` int(100) NOT NULL,
  `id_obat` int(100) NOT NULL,
  `id_pelanggan` int(100) NOT NULL,
  `tanggal` date NOT NULL,
  `jumlah` int(100) NOT NULL,
  `total_harga` int(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `detail_transaksi`
--

INSERT INTO `detail_transaksi` (`id_detail`, `id_transaksi`, `id_obat`, `id_pelanggan`, `tanggal`, `jumlah`, `total_harga`) VALUES
(10, 100, 1, 50, '2022-12-12', 1, 18400),
(11, 101, 2, 51, '2023-11-10', 2, 10000),
(12, 102, 5, 52, '2023-01-02', 3, 9000),
(13, 103, 6, 53, '2023-02-12', 2, 4000),
(14, 104, 9, 54, '2023-03-03', 1, 12000);

-- --------------------------------------------------------

--
-- Table structure for table `obat`
--

CREATE TABLE `obat` (
  `id_obat` int(100) NOT NULL,
  `nama_obat` varchar(255) NOT NULL,
  `kategori` varchar(255) NOT NULL,
  `harga` int(255) NOT NULL,
  `stok` int(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `obat`
--

INSERT INTO `obat` (`id_obat`, `nama_obat`, `kategori`, `harga`, `stok`) VALUES
(1, 'paracetamol', 'demam', 18400, 100),
(2, 'amoxicillin', 'antibiotik', 5000, 50),
(3, 'obh', 'batuk', 14000, 35),
(4, 'ultraflu', 'flu', 3000, 75),
(5, 'kuldon', 'sariawan', 3000, 75),
(6, 'paramex', 'sakit kepala', 2000, 75),
(7, 'vegeta', 'diare', 3000, 50),
(8, 'ibuprofen', 'sakit gigi', 7000, 35),
(9, 'laserin', 'batuk', 12000, 35);

-- --------------------------------------------------------

--
-- Table structure for table `pelanggan`
--

CREATE TABLE `pelanggan` (
  `id_pelanggan` int(100) NOT NULL,
  `nama_pelanggan` varchar(255) NOT NULL,
  `alamat` varchar(255) NOT NULL,
  `telepon` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `pelanggan`
--

INSERT INTO `pelanggan` (`id_pelanggan`, `nama_pelanggan`, `alamat`, `telepon`) VALUES
(50, 'rizki', 'sleman', '8132455646'),
(51, 'linda', 'depok', '83177879868'),
(52, 'nisa', 'concat', '8960102808'),
(53, 'bagas', 'kaliurang', '8514747220'),
(54, 'zidan', 'seturan', '8578242517');

-- --------------------------------------------------------

--
-- Table structure for table `resep`
--

CREATE TABLE `resep` (
  `no_resep` int(100) NOT NULL,
  `id_obat` int(100) DEFAULT NULL,
  `nama_obat` varchar(255) DEFAULT NULL,
  `dosis` varchar(255) DEFAULT NULL,
  `content` text DEFAULT NULL,
  `star` int(100) DEFAULT NULL,
  `id_pelanggan` int(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `supplier_obat`
--

CREATE TABLE `supplier_obat` (
  `id_supplier` int(100) NOT NULL,
  `id_obat` int(100) DEFAULT NULL,
  `telepon` varchar(255) DEFAULT NULL,
  `nama_supplier` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `supplier_obat`
--

INSERT INTO `supplier_obat` (`id_supplier`, `id_obat`, `telepon`, `nama_supplier`) VALUES
(1, 1, '081233423456', 'adit'),
(2, 2, '085731231387', 'putri'),
(3, 3, '083175846946', 'putra'),
(4, 4, '082163456383', 'riska'),
(5, 5, '089623874342', 'icha'),
(6, 6, '082347356835', 'tias'),
(7, 7, '089623784121', 'rizal'),
(8, 8, '085236724248', 'ufi'),
(9, 9, '089126324724', 'helma'),
(11, 9, '088756392735', 'anggi');

-- --------------------------------------------------------

--
-- Table structure for table `transaksi`
--

CREATE TABLE `transaksi` (
  `id_transaksi` int(100) NOT NULL,
  `id_pelanggan` int(100) NOT NULL,
  `tanggal` date NOT NULL,
  `total_harga` int(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `transaksi`
--

INSERT INTO `transaksi` (`id_transaksi`, `id_pelanggan`, `tanggal`, `total_harga`) VALUES
(100, 50, '2022-12-12', 18400),
(101, 51, '2023-11-10', 10000),
(102, 52, '2023-01-02', 9000),
(103, 53, '2023-02-12', 4000),
(104, 54, '2023-03-03', 12000);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `detail_transaksi`
--
ALTER TABLE `detail_transaksi`
  ADD PRIMARY KEY (`id_detail`),
  ADD KEY `fk_transaksi` (`id_transaksi`),
  ADD KEY `fk_obat` (`id_obat`);

--
-- Indexes for table `obat`
--
ALTER TABLE `obat`
  ADD PRIMARY KEY (`id_obat`);

--
-- Indexes for table `pelanggan`
--
ALTER TABLE `pelanggan`
  ADD PRIMARY KEY (`id_pelanggan`);

--
-- Indexes for table `resep`
--
ALTER TABLE `resep`
  ADD PRIMARY KEY (`no_resep`),
  ADD KEY `id_obat` (`id_obat`);

--
-- Indexes for table `supplier_obat`
--
ALTER TABLE `supplier_obat`
  ADD PRIMARY KEY (`id_supplier`),
  ADD KEY `id_obat` (`id_obat`);

--
-- Indexes for table `transaksi`
--
ALTER TABLE `transaksi`
  ADD PRIMARY KEY (`id_transaksi`),
  ADD KEY `id_pelanggan` (`id_pelanggan`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `detail_transaksi`
--
ALTER TABLE `detail_transaksi`
  MODIFY `id_detail` int(100) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT for table `obat`
--
ALTER TABLE `obat`
  MODIFY `id_obat` int(100) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `pelanggan`
--
ALTER TABLE `pelanggan`
  MODIFY `id_pelanggan` int(100) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=55;

--
-- AUTO_INCREMENT for table `supplier_obat`
--
ALTER TABLE `supplier_obat`
  MODIFY `id_supplier` int(100) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `transaksi`
--
ALTER TABLE `transaksi`
  MODIFY `id_transaksi` int(100) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=105;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `detail_transaksi`
--
ALTER TABLE `detail_transaksi`
  ADD CONSTRAINT `fk_obat` FOREIGN KEY (`id_obat`) REFERENCES `obat` (`id_obat`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_transaksi` FOREIGN KEY (`id_transaksi`) REFERENCES `transaksi` (`id_transaksi`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `supplier_obat`
--
ALTER TABLE `supplier_obat`
  ADD CONSTRAINT `supplier_obat_ibfk_1` FOREIGN KEY (`id_obat`) REFERENCES `obat` (`id_obat`);

--
-- Constraints for table `transaksi`
--
ALTER TABLE `transaksi`
  ADD CONSTRAINT `transaksi_ibfk_1` FOREIGN KEY (`id_pelanggan`) REFERENCES `pelanggan` (`id_pelanggan`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
