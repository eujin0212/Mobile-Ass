
-- --------------------------------------------------------

--
-- Table structure for table `PAYMENT`
--

CREATE TABLE `PAYMENT` (
  `ORDERID` varchar(100) NOT NULL,
  `BILLID` varchar(10) NOT NULL,
  `ADDRESS` varchar(200) NOT NULL,
  `TOTAL` varchar(10) NOT NULL,
  `EMAIL` varchar(50) NOT NULL,
  `DATE` timestamp(6) NOT NULL DEFAULT current_timestamp(6)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `PAYMENT`
--

INSERT INTO `PAYMENT` (`ORDERID`, `BILLID`, `ADDRESS`, `TOTAL`, `EMAIL`, `DATE`) VALUES
('16072020211256', '97ikpclq', '20, Jalan Sultan Ahmad, Kampung Ketapang Tengah, 26600 Pekan, Pahang, Malaysia', '194.20', 'tej9812@gmail.com', '2020-07-16 08:28:31.312454'),
('23072020485008', 'nviaoyf3', '114, Jalan Harmoni, 26600 Pekan, Pahang, Malaysia', '61.07', 'ali@gmail.com', '2020-07-23 08:40:03.013827');
