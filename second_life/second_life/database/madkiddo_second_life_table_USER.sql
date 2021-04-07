
-- --------------------------------------------------------

--
-- Table structure for table `USER`
--

CREATE TABLE `USER` (
  `NAME` varchar(50) NOT NULL,
  `EMAIL` varchar(50) NOT NULL,
  `PASSWORD` varchar(60) NOT NULL,
  `PHONE` varchar(12) NOT NULL,
  `VERIFY` int(1) NOT NULL DEFAULT 0,
  `DATEREG` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `USER`
--

INSERT INTO `USER` (`NAME`, `EMAIL`, `PASSWORD`, `PHONE`, `VERIFY`, `DATEREG`) VALUES
('unregistered', 'unregistered@grocery.com', 'f7c3bc1d808e04732adf679965ccc34ca7ae3441', 'unregistered', 0, '2020-06-19 16:00:00'),
('Ali', 'ali@gmail.com', '4be30d9814c6d4e9800e0d2ea9ec9fb00efa887b', '01112345678', 0, '2020-06-22 04:35:28'),
('Eric Lee', 'eric@gmail.com', '4be30d9814c6d4e9800e0d2ea9ec9fb00efa887b', '01293213321', 0, '2020-07-16 08:19:08'),
('Tan Eu Jin', 'tej9812@gmail.com', '4be30d9814c6d4e9800e0d2ea9ec9fb00efa887b', '0169500480', 1, '2020-07-16 08:25:08');
