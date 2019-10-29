-- phpMyAdmin SQL Dump
-- version 4.6.5.2
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: 29-Out-2019 às 18:30
-- Versão do servidor: 10.1.21-MariaDB
-- PHP Version: 5.6.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `olist_dw`
--

-- --------------------------------------------------------

--
-- Estrutura da tabela `dim_geolocation`
--

CREATE TABLE `dim_geolocation` (
  `geolocation_zip_code_prefix` int(11) NOT NULL,
  `geolocation_lat` double NOT NULL,
  `geolocation_lng` double NOT NULL,
  `geolocation_city` varchar(100) NOT NULL,
  `geolocation_state` varchar(2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabela que contém os dados de geolocalização para todos os endereços cadastrados no sistema.';

-- --------------------------------------------------------

--
-- Estrutura da tabela `dim_order_review`
--

CREATE TABLE `dim_order_review` (
  `order_review_id` varchar(100) NOT NULL,
  `order_id` varchar(100) NOT NULL,
  `review_score` int(11) DEFAULT NULL,
  `review_comment_title` varchar(100) DEFAULT NULL,
  `review_comment_message` varchar(400) DEFAULT NULL,
  `review_comment_date` date DEFAULT NULL,
  `review_answer_timestamp` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabela que contém as observações informadas pelos clientes em suas compras.';

-- --------------------------------------------------------

--
-- Estrutura da tabela `dim_person`
--

CREATE TABLE `dim_person` (
  `person_id` varchar(100) NOT NULL,
  `person_unique_id` varchar(100) DEFAULT NULL,
  `person_type` varchar(2) DEFAULT NULL COMMENT 'C - Customer\nS - Seller',
  `person_zip_code_prefix` int(11) DEFAULT NULL,
  `person_city` varchar(100) DEFAULT NULL,
  `person_state` varchar(2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Dimensão que contém todas as pessoas do sistema';

-- --------------------------------------------------------

--
-- Estrutura da tabela `dim_products`
--

CREATE TABLE `dim_products` (
  `product_id` varchar(100) NOT NULL,
  `product_category_name` varchar(100) DEFAULT NULL,
  `product_name_lenght` int(11) DEFAULT NULL,
  `product_description_lenght` int(11) DEFAULT NULL,
  `product_photos_qty` int(11) DEFAULT NULL,
  `product_weight_g` int(11) DEFAULT NULL,
  `product_length_cm` int(11) DEFAULT NULL,
  `product_height_cm` int(11) DEFAULT NULL,
  `product_width_cm` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabela que contém os produtos cadastrados.';

-- --------------------------------------------------------

--
-- Estrutura da tabela `fact_orders`
--

CREATE TABLE `fact_orders` (
  `order_id` varchar(100) NOT NULL,
  `customer_id` varchar(100) NOT NULL,
  `seller_id` varchar(100) NOT NULL,
  `status_order` varchar(20) DEFAULT NULL,
  `order_purchase_timestamp` datetime DEFAULT NULL,
  `order_approved_at` datetime DEFAULT NULL,
  `order_delivered_carrier_date` datetime DEFAULT NULL,
  `order_delivered_customer_date` datetime DEFAULT NULL,
  `order_estimated_delivery_date` datetime DEFAULT NULL,
  `order_item_id` varchar(100) NOT NULL,
  `product_id` varchar(100) NOT NULL,
  `shipping_limit_date` datetime DEFAULT NULL,
  `price_item` decimal(10,0) DEFAULT NULL,
  `freight_value` decimal(10,0) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabela fato que armazena dados das vendas realizadas.';

-- --------------------------------------------------------

--
-- Estrutura da tabela `fact_payments`
--

CREATE TABLE `fact_payments` (
  `order_id` varchar(100) NOT NULL,
  `payment_sequential` int(11) NOT NULL,
  `payment_type` varchar(100) NOT NULL,
  `payment_installments` int(11) DEFAULT NULL,
  `payment_value` decimal(10,0) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabela fato quem contém os pagamentos realizados nas vendas.';

--
-- Indexes for dumped tables
--

--
-- Indexes for table `dim_order_review`
--
ALTER TABLE `dim_order_review`
  ADD PRIMARY KEY (`order_review_id`,`order_id`);

--
-- Indexes for table `dim_person`
--
ALTER TABLE `dim_person`
  ADD PRIMARY KEY (`person_id`);

--
-- Indexes for table `dim_products`
--
ALTER TABLE `dim_products`
  ADD KEY `dw_products_idx` (`product_id`);

--
-- Indexes for table `fact_orders`
--
ALTER TABLE `fact_orders`
  ADD KEY `fact_orders_idx` (`order_id`),
  ADD KEY `fact_orders_idx_customer_seller` (`order_id`,`customer_id`,`seller_id`),
  ADD KEY `dw_products_fact_orders_fk` (`product_id`),
  ADD KEY `dim_person_fact_orders_fk` (`customer_id`),
  ADD KEY `dim_person_fact_orders_fk1` (`seller_id`),
  ADD KEY `idx_fact_orders_order_id_customer_id_seller_id` (`order_id`,`customer_id`,`seller_id`);

--
-- Constraints for dumped tables
--

--
-- Limitadores para a tabela `fact_orders`
--
ALTER TABLE `fact_orders`
  ADD CONSTRAINT `dim_person_fact_orders_fk` FOREIGN KEY (`customer_id`) REFERENCES `dim_person` (`person_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `dim_person_fact_orders_fk1` FOREIGN KEY (`seller_id`) REFERENCES `dim_person` (`person_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `dw_products_fact_orders_fk` FOREIGN KEY (`product_id`) REFERENCES `dim_products` (`product_id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
