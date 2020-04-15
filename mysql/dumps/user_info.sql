-- MariaDB dump 10.17  Distrib 10.4.10-MariaDB, for Linux (x86_64)
--
-- Host: localhost    Database: imdb
-- ------------------------------------------------------
-- Server version	10.4.10-MariaDB

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `user_info`
--

DROP TABLE IF EXISTS `user_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_info` (
  `username` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `password` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `user_id` int(11) NOT NULL AUTO_INCREMENT,
  `fav_genre` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `recent_fav` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_info`
--

LOCK TABLES `user_info` WRITE;
/*!40000 ALTER TABLE `user_info` DISABLE KEYS */;
INSERT INTO `user_info` VALUES ('prithu','sha256$brDWyaok$11ca65c9023e450113223e4b5a53d3063bafbb205d58dc51787a31a7d2f29cea',1,'Drama','Up (2009)'),('debian','sha256$oAEotYlT$5f59e9b701c37f6571763a6b084931e1e19cf0f665f03c887162279f7b2e8c58',2,'Adventure','Whiplash (2014)'),('hello','sha256$Bvqvy5bz$ce769bc586dae53cf756975c3bc931acf7f87e1a92b3447fb174f2f56301d4e6',3,'Crime','NCIS (2003)'),('newuser','sha256$nQOsv4Fc$292144db6227233a5c0364c602d305fab2a75cfb38e3893a3e84e7234c4d74a9',4,NULL,'Another (2012)'),('yet','sha256$sRSlPrjK$7a7d40041d4f037388177a5f9b1d4187276fa1998bba24ca79a743c81de13813',5,NULL,NULL),('newdamn','sha256$E46jWfEo$9cc4efcf73b64b2212b5107da74f53944904ec6cc3d334b6b2828d191ae6a3f8',6,NULL,NULL),('lucy','sha256$7RyeibwV$d2909e0e176f050355c5434c89f1eaf68e9a31d3a4e18bdab8a502fa123c6e58',7,'Crime','Breaking Bad (2008)'),('newuser2','sha256$XP9zqfIM$19c5c22ac37262f05e549a85f00b6fb8edf7139b40f6e61113343f3a9a152e07',8,NULL,NULL),('zomato','sha256$lnMiMpku$ef44a51ba1e5148c58d6476a6475e9dedb753170988124c60e7ef0e3062e92f5',9,'Action','Batman (1989)'),('rahul','sha256$qtHHetb4$5b831d8c06060066eb7c2f3cc1cc2671b99d83394d1730e28543edd759eb7a48',17,'Action','Toy Story 3 (2010)'),('Pacific','sha256$VjTDkNUo$e739e62552bc912352921d1dac75e89c55572016999af811576f3ab7152b11fd',18,'Drama','The Social Network (2010)'),('Prashant','sha256$2VCBhNJ1$1a2f9591b69e07e963f3826ebb191e4a2f771d089e97d2a6d6de8a55b614f566',19,NULL,NULL);
/*!40000 ALTER TABLE `user_info` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2019-12-13  8:15:00
