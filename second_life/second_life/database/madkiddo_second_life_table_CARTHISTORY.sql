
-- --------------------------------------------------------

--
-- Table structure for table `CARTHISTORY`
--

CREATE TABLE `CARTHISTORY` (
  `EMAIL` varchar(50) NOT NULL,
  `ORDERID` varchar(50) NOT NULL,
  `BILLID` varchar(50) NOT NULL,
  `PRODID` varchar(20) NOT NULL,
  `CQUANTITY` varchar(20) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `CARTHISTORY`
--

INSERT INTO `CARTHISTORY` (`EMAIL`, `ORDERID`, `BILLID`, `PRODID`, `CQUANTITY`) VALUES
('tej9812@gmail.com', '16072020211256', '97ikpclq', '13072020301601', '2'),
('tej9812@gmail.com', '16072020211256', '97ikpclq', '0000005', '1'),
('ali@gmail.com', '23072020485008', 'nviaoyf3', '13072020516247', '2'),
('ali@gmail.com', '23072020485008', 'nviaoyf3', '13072020617388', '1');
