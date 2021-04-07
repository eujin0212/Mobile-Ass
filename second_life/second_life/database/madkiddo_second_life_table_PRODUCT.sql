
-- --------------------------------------------------------

--
-- Table structure for table `PRODUCT`
--

CREATE TABLE `PRODUCT` (
  `NAME` varchar(30) NOT NULL,
  `PRODID` varchar(30) NOT NULL,
  `PRICE` varchar(10) NOT NULL,
  `QUANTITY` varchar(10) NOT NULL,
  `SOLD` varchar(20) NOT NULL,
  `WEIGHT` varchar(10) NOT NULL,
  `TYPE` varchar(30) NOT NULL,
  `DESCRIPTION` varchar(500) NOT NULL,
  `LOCATION` varchar(30) NOT NULL,
  `EMAIL` varchar(50) NOT NULL,
  `DATE` timestamp(6) NOT NULL DEFAULT current_timestamp(6)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `PRODUCT`
--

INSERT INTO `PRODUCT` (`NAME`, `PRODID`, `PRICE`, `QUANTITY`, `SOLD`, `WEIGHT`, `TYPE`, `DESCRIPTION`, `LOCATION`, `EMAIL`, `DATE`) VALUES
('Cap', '13072020064548', '12.60', '6', '0', '130.00', 'Appearance', 'it a dark cap which can easily match all cloth', 'Pahang', 'eric@gmail.com', '2020-07-13 12:16:57.381775'),
('Rubic Cube ', '13072020516247', '13.56', '8', '2', '85.00', 'Entertainment', '3x3x3 cube time to test your brain capabilities', 'Kelantan', 'eric@gmail.com', '2020-07-13 11:09:13.206039'),
('Powerbank', '0000004', '38.55', '48', '0', '330', 'Electronic', 'Used for fews time only but found out the battery capacity is too small which is only 5000mAh', 'Kedah', 'ali@gmail.com', '2020-06-22 04:41:40.000000'),
('Hand Sanitizer', '0000005', '12.20', '24', '1', '180.00', 'Household', 'Brand new hand sanitizer, alcohol contain around 70% can use for prevent covid-19. It Dettol brand.', 'Pahang', 'eric@gmail.com', '2020-06-23 14:20:44.000000'),
('Calculator', '0000006', '43.50', '2', '0', '230.00', 'Electronic', '', '', 'ali@gmail.com', '2020-06-23 14:20:44.000000'),
('Note Book', '0000007', '1.20', '45', '0', '80', 'Education', 'Note book use too write down your notes and everything. It is 80 pages included covers.', 'Sarawak', 'ali@gmail.com', '2020-06-23 14:24:25.000000'),
('Stapler', '0000008', '1.50', '20', '0', '140.00', 'Education', 'It Casio brand stapler', 'Sabah', 'ali@gmail.com', '2020-06-23 14:24:25.000000'),
('Dog Decorations', '08072020772773', '35.00', '1', '0', '200.00', 'Household', 'It is a cute dog Decorations for your hom', 'Penang', 'ali@gmail.com', '2020-07-08 09:15:35.933370'),
('Slipper', '12072020405037', '12.00', '2', '0', '100.00', 'Household', 'pink colour slipperï¼Œlook fashionable and very ease to wear', 'Pahang', 'eric@gmail.com', '2020-07-12 12:06:31.494621'),
('Airdots', '10072020157222', '61.00', '9', '0', '208.00', 'Electronic', 'Redmi true wireless earbuds, sound quality I would rate 8/10. Easy to set up', 'Pahang', 'eric@gmail.com', '2020-07-10 08:38:32.642420'),
('Bluetooth Mouse', '13072020617388', '32.50', '4', '1', '120.00', 'Entertainment', 'INPHC brand mouse, Bluetooth 5.0', 'Terengganu', 'eric@gmail.com', '2020-07-13 11:13:40.344597'),
('Fishing Tools', '13072020301601', '88.80', '1', '2', '350.00', 'Entertainment', 'only used for few times and still very nee', 'Terengganu', 'eric@gmail.com', '2020-07-13 12:20:25.694503'),
('Remote', '13072020027802', '32.60', '5', '0', '250.00', 'Electronic', 'astro remote, black in colour which look very fashion', 'Negeri Sembilan', 'ali@gmail.com', '2020-07-13 12:24:17.745951'),
('Table', '16072020428183', '33.50', '2', '0', '1000.00', 'Household', 'It a cute little table for your sofa companion', 'Pahang', 'tej9812@gmail.com', '2020-07-16 08:30:25.897785');
