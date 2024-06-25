DROP DATABASE IF EXISTS `jiticket_test`;

CREATE DATABASE  IF NOT EXISTS `jiticket_test` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `jiticket_test`;
-- MySQL dump 10.13  Distrib 8.0.34, for Win64 (x86_64)
--
-- Host: 43.142.102.35    Database: jiticket_test
-- ------------------------------------------------------
-- Server version	8.0.24

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `activity`
--

DROP TABLE IF EXISTS `activity`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `activity` (
  `act_id` int NOT NULL AUTO_INCREMENT COMMENT '活动id',
  `act_name` varchar(80) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '管理员可修改，管理员备注内容融合在这里*',
  `act_intro` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '活动简介',
  `act_location` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '活动地点',
  `ticket_price` decimal(10,2) NOT NULL COMMENT '活动报名费',
  `upload_time` datetime(6) NOT NULL ON UPDATE CURRENT_TIMESTAMP(6) COMMENT '活动发布时间',
  `reg_start_time` datetime(6) NOT NULL COMMENT '活动开始报名时间',
  `reg_end_time` datetime(6) DEFAULT NULL COMMENT '活动截止报名时间',
  `act_time` datetime(6) NOT NULL COMMENT '活动时间',
  `act_capacity` int NOT NULL COMMENT '活动总容量',
  `act_left` int NOT NULL COMMENT '活动剩余名额',
  `act_rating` decimal(5,1) NOT NULL COMMENT '活动评分',
  `rating_num` int NOT NULL COMMENT '评分人数',
  `soc_id` int NOT NULL COMMENT '活动发布社团id，FK，引用自society表',
  PRIMARY KEY (`act_id`) USING BTREE,
  KEY `act_soc_id_fk` (`soc_id`) USING BTREE,
  CONSTRAINT `act_soc_id_fk` FOREIGN KEY (`soc_id`) REFERENCES `society` (`soc_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `activity`
--

LOCK TABLES `activity` WRITE;
/*!40000 ALTER TABLE `activity` DISABLE KEYS */;
INSERT INTO `activity` VALUES (1,'比亚迪冬季长跑','byd跑是吧','嘉定校区',150.00,'2024-05-29 18:32:51.000000','2023-11-25 10:00:00.000000','2023-11-25 19:00:00.000000','2023-11-30 14:30:00.000000',3500,3499,3.5,1,5),(2,'2151294','123','123',100.00,'2024-06-24 14:58:25.520572','2024-06-18 11:31:00.000000','2024-06-18 11:32:00.000000','2024-07-01 14:30:00.000000',100,600,5.0,1,5),(3,'阿迪达斯校园跑','跑动同济','嘉定校区',30.00,'2024-06-22 15:35:12.000000','2024-07-01 08:00:00.000000','2024-07-03 12:30:00.000000','2024-07-15 14:30:00.000000',4200,4200,1.5,1,5);
/*!40000 ALTER TABLE `activity` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `activity_image`
--

DROP TABLE IF EXISTS `activity_image`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `activity_image` (
  `act_id` int NOT NULL COMMENT '活动id，PK,FK,外键依赖activity的act_ID',
  `act_image` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '活动图片，PK，以相对路径方式存储',
  PRIMARY KEY (`act_id`,`act_image`) USING BTREE,
  CONSTRAINT `act_img_id_fk` FOREIGN KEY (`act_id`) REFERENCES `activity` (`act_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `activity_image`
--

LOCK TABLES `activity_image` WRITE;
/*!40000 ALTER TABLE `activity_image` DISABLE KEYS */;
/*!40000 ALTER TABLE `activity_image` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `activity_keyword`
--

DROP TABLE IF EXISTS `activity_keyword`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `activity_keyword` (
  `act_id` int NOT NULL COMMENT '活动id，PK，FK,引用自activity表',
  `keyword` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '活动关键词，FK，引用自keywords表',
  PRIMARY KEY (`act_id`,`keyword`) USING BTREE,
  KEY `act_kw_kw_fk` (`keyword`) USING BTREE,
  CONSTRAINT `act_kw_id_fk` FOREIGN KEY (`act_id`) REFERENCES `activity` (`act_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `act_kw_kw_fk` FOREIGN KEY (`keyword`) REFERENCES `keywords` (`keyword`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `activity_keyword`
--

LOCK TABLES `activity_keyword` WRITE;
/*!40000 ALTER TABLE `activity_keyword` DISABLE KEYS */;
INSERT INTO `activity_keyword` VALUES (2,'中医'),(2,'体育'),(3,'体育'),(1,'媒体'),(3,'媒体'),(1,'学习'),(1,'研究');
/*!40000 ALTER TABLE `activity_keyword` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `appeal`
--

DROP TABLE IF EXISTS `appeal`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `appeal` (
  `app_id` int NOT NULL AUTO_INCREMENT COMMENT '申诉id',
  `app_time` timestamp(6) NOT NULL COMMENT '申诉时间',
  `app_matters` int NOT NULL COMMENT '申诉事项类型',
  `app_content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '申诉描述',
  `user_id` int DEFAULT NULL COMMENT '被申诉用户id',
  `act_id` int DEFAULT NULL COMMENT '被申诉活动id',
  `cmt_id` int DEFAULT NULL COMMENT '被申诉评论id',
  `complainant_id` int NOT NULL COMMENT '申诉者id',
  PRIMARY KEY (`app_id`) USING BTREE,
  KEY `app_user_id_fk` (`user_id`) USING BTREE,
  KEY `app_cmt_id_fk` (`cmt_id`) USING BTREE,
  KEY `app_act_id_fk` (`act_id`) USING BTREE,
  KEY `app_comp_id_fk` (`complainant_id`) USING BTREE,
  CONSTRAINT `app_act_id_fk` FOREIGN KEY (`act_id`) REFERENCES `activity` (`act_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `app_cmt_id_fk` FOREIGN KEY (`cmt_id`) REFERENCES `comment` (`cmt_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `app_comp_id_fk` FOREIGN KEY (`complainant_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `app_user_id_fk` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `appeal`
--

LOCK TABLES `appeal` WRITE;
/*!40000 ALTER TABLE `appeal` DISABLE KEYS */;
INSERT INTO `appeal` VALUES (1,'2023-12-01 05:05:32.000000',1,'言语有讽刺意味，感觉被冒犯到',NULL,NULL,6,1),(2,'2023-12-01 06:32:10.000000',1,'骂人，影响很不好',NULL,NULL,6,2),(3,'2023-12-09 13:50:12.000000',1,'水帖',NULL,NULL,8,3),(4,'2023-05-01 05:26:39.000000',4,'这人人品不会有问题吧',4,NULL,NULL,1),(5,'2023-12-30 03:36:29.000000',1,'太张狂了，欠揍',NULL,NULL,6,3);
/*!40000 ALTER TABLE `appeal` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `appeal_image`
--

DROP TABLE IF EXISTS `appeal_image`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `appeal_image` (
  `app_id` int NOT NULL COMMENT '申诉id',
  `app_image` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '截图图像，以相对路径存储',
  PRIMARY KEY (`app_id`,`app_image`) USING BTREE,
  CONSTRAINT `app_img_id_fk` FOREIGN KEY (`app_id`) REFERENCES `appeal` (`app_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `appeal_image`
--

LOCK TABLES `appeal_image` WRITE;
/*!40000 ALTER TABLE `appeal_image` DISABLE KEYS */;
/*!40000 ALTER TABLE `appeal_image` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `browse`
--

DROP TABLE IF EXISTS `browse`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `browse` (
  `bro_time_start` timestamp(3) NOT NULL COMMENT '浏览起始时间',
  `act_id` int NOT NULL COMMENT '活动id',
  `browser_id` int NOT NULL COMMENT '浏览者id',
  `whether_buy` tinyint(1) NOT NULL COMMENT '购买情况，0:未购买/1:购买',
  PRIMARY KEY (`bro_time_start`,`act_id`,`browser_id`) USING BTREE,
  KEY `bro_act_id_fk` (`act_id`) USING BTREE,
  KEY `bro_stu_id_fk` (`browser_id`) USING BTREE,
  CONSTRAINT `bro_act_id_fk` FOREIGN KEY (`act_id`) REFERENCES `activity` (`act_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `bro_stu_id_fk` FOREIGN KEY (`browser_id`) REFERENCES `student` (`stu_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `browse`
--

LOCK TABLES `browse` WRITE;
/*!40000 ALTER TABLE `browse` DISABLE KEYS */;
INSERT INTO `browse` VALUES ('2023-12-22 04:55:58.000',1,1,0),('2023-12-23 11:48:20.000',1,1,0),('2024-06-15 07:17:23.000',1,1,1);
/*!40000 ALTER TABLE `browse` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `chat`
--

DROP TABLE IF EXISTS `chat`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `chat` (
  `chat_time` timestamp(3) NOT NULL COMMENT '聊天时间(精确到毫秒）',
  `stu_id` int NOT NULL COMMENT '普通用户ID',
  `soc_id` int NOT NULL COMMENT '社团ID',
  `chat_content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '聊天内容',
  `chat_sender` int NOT NULL COMMENT '发出者,0：普通用户/1：社团',
  PRIMARY KEY (`chat_time`,`stu_id`,`soc_id`) USING BTREE,
  KEY `chat_stu_id_fk` (`stu_id`) USING BTREE,
  KEY `chat_soc_id_fk` (`soc_id`) USING BTREE,
  CONSTRAINT `chat_soc_id_fk` FOREIGN KEY (`soc_id`) REFERENCES `society` (`soc_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `chat_stu_id_fk` FOREIGN KEY (`stu_id`) REFERENCES `student` (`stu_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `chat`
--

LOCK TABLES `chat` WRITE;
/*!40000 ALTER TABLE `chat` DISABLE KEYS */;
/*!40000 ALTER TABLE `chat` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `comment`
--

DROP TABLE IF EXISTS `comment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `comment` (
  `cmt_id` int NOT NULL AUTO_INCREMENT COMMENT '评论id',
  `cmt_father` int NOT NULL COMMENT '父评论，0：无父评论/非零：父评论ID*',
  `cmt_content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '评论内容',
  `cmt_time` datetime(6) NOT NULL ON UPDATE CURRENT_TIMESTAMP(6) COMMENT '评论时间',
  `act_id` int NOT NULL COMMENT '商品id',
  `user_id` int NOT NULL COMMENT '评论用户id',
  PRIMARY KEY (`cmt_id`) USING BTREE,
  KEY `cmt_act_id_fk` (`act_id`) USING BTREE,
  KEY `cmt_user_id_fk` (`user_id`) USING BTREE,
  CONSTRAINT `cmt_act_id_fk` FOREIGN KEY (`act_id`) REFERENCES `activity` (`act_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `cmt_user_id_fk` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=36 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `comment`
--

LOCK TABLES `comment` WRITE;
/*!40000 ALTER TABLE `comment` DISABLE KEYS */;
INSERT INTO `comment` VALUES (1,0,'有人知道在哪领装备吗','2023-11-30 10:30:24.000000',1,1),(2,1,'昨天好像就领了吧','2023-11-30 10:37:48.000000',1,2),(3,1,'昨天在篮球场那里用身份证领啊','2023-11-30 10:37:06.000000',1,3),(4,2,'阿哲，我好像没领啊','2023-11-30 10:45:47.000000',1,1),(5,2,'那还能参加吗','2023-11-30 10:45:59.000000',1,1),(6,0,'嘻嘻，参加不了咯','2023-11-30 11:10:08.000000',1,4),(7,0,'那天真的冷的不行啊555','2023-12-04 22:42:13.000000',1,4),(8,0,'666很棒的活动，期待下次！','2024-06-03 13:43:56.021633',2,2),(9,8,'确实！','2024-06-03 13:43:56.031654',2,1);
/*!40000 ALTER TABLE `comment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `favour`
--

DROP TABLE IF EXISTS `favour`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `favour` (
  `act_id` int NOT NULL COMMENT '活动id',
  `stu_id` int NOT NULL COMMENT '收藏者id',
  PRIMARY KEY (`act_id`,`stu_id`) USING BTREE,
  KEY `fav_stu_id_fk` (`stu_id`) USING BTREE,
  CONSTRAINT `fav_act_id_fk` FOREIGN KEY (`act_id`) REFERENCES `activity` (`act_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fav_stu_id_fk` FOREIGN KEY (`stu_id`) REFERENCES `student` (`stu_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `favour`
--

LOCK TABLES `favour` WRITE;
/*!40000 ALTER TABLE `favour` DISABLE KEYS */;
INSERT INTO `favour` VALUES (1,1),(2,1),(1,2),(1,3),(2,3);
/*!40000 ALTER TABLE `favour` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `indent`
--

DROP TABLE IF EXISTS `indent`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `indent` (
  `ind_id` int NOT NULL AUTO_INCREMENT COMMENT '订单id，PK',
  `ind_price` decimal(10,2) NOT NULL COMMENT '支付金额',
  `ind_create_time` datetime(6) NOT NULL ON UPDATE CURRENT_TIMESTAMP(6) COMMENT '创建时间',
  `ind_verify_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '活动参与核销码',
  `ind_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '参与者姓名',
  `ind_stu_no` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '报名者学号',
  `ind_notes` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci COMMENT '可选：用户备注',
  `ind_status` int NOT NULL COMMENT '订单状态，0：待核销/1：已完成/2：已退款',
  `ind_rating` decimal(5,1) DEFAULT NULL COMMENT '评分',
  `act_id` int NOT NULL COMMENT '活动ID',
  `stu_id` int NOT NULL COMMENT '学生账号ID',
  `ind_rtime` datetime(6) DEFAULT NULL COMMENT '可选：退款时间',
  `ind_rnotes` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci COMMENT '可选：退款备注',
  `ind_rmoney` decimal(10,2) DEFAULT NULL COMMENT '可选：退款金额',
  PRIMARY KEY (`ind_id`) USING BTREE,
  KEY `ind_stu_id_fk` (`stu_id`) USING BTREE,
  CONSTRAINT `ind_stu_id_fk` FOREIGN KEY (`stu_id`) REFERENCES `student` (`stu_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `indent`
--

LOCK TABLES `indent` WRITE;
/*!40000 ALTER TABLE `indent` DISABLE KEYS */;
INSERT INTO `indent` VALUES (1,150.00,'2023-12-24 21:37:02.612104','abcdefg','马威','2151294','给好点的衣服，求了',2,NULL,1,1,'2023-11-30 20:08:08.000000','太冷了，睡觉',150.00),(2,150.00,'2023-12-24 21:55:53.527901','abcdefg','杨滕超','2151299','我爱杨老师',1,3.5,1,2,NULL,NULL,NULL),(3,120.50,'2024-06-22 17:33:15.603741','123456','马威','2151294','应该不冷吧哈哈哈，喜欢跑步！',0,NULL,2,1,NULL,NULL,NULL);
/*!40000 ALTER TABLE `indent` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `keywords`
--

DROP TABLE IF EXISTS `keywords`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `keywords` (
  `keyword` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '活动类型关键词',
  PRIMARY KEY (`keyword`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `keywords`
--

LOCK TABLES `keywords` WRITE;
/*!40000 ALTER TABLE `keywords` DISABLE KEYS */;
INSERT INTO `keywords` VALUES ('中医'),('体育'),('健康'),('公益'),('国际交流'),('天文'),('媒体'),('学习'),('建筑'),('开源'),('心理'),('技术'),('数据分析'),('文化传承'),('模型'),('汽车'),('研究'),('艺术'),('语言');
/*!40000 ALTER TABLE `keywords` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notice`
--

DROP TABLE IF EXISTS `notice`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `notice` (
  `ntc_id` int NOT NULL AUTO_INCREMENT COMMENT '公告id',
  `ntc_time` datetime(6) NOT NULL ON UPDATE CURRENT_TIMESTAMP(6) COMMENT '公告发布时间',
  `ntc_content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '公告内容',
  `ntc_status` int NOT NULL COMMENT '显示状态，0：未显示/1：已显示',
  `soc_id` int NOT NULL COMMENT '社团id',
  PRIMARY KEY (`ntc_id`) USING BTREE,
  KEY `ntc_soc_id_fk` (`soc_id`) USING BTREE,
  CONSTRAINT `ntc_soc_id_fk` FOREIGN KEY (`soc_id`) REFERENCES `society` (`soc_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notice`
--

LOCK TABLES `notice` WRITE;
/*!40000 ALTER TABLE `notice` DISABLE KEYS */;
/*!40000 ALTER TABLE `notice` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `society`
--

DROP TABLE IF EXISTS `society`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `society` (
  `soc_id` int NOT NULL COMMENT '社团账号id，PK，FK，与对应的user相同',
  `soc_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '社团名称',
  `soc_intro` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '社团介绍',
  `soc_type` enum('体育类社团','艺术类社团','科技类社团') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '社团类别',
  `soc_logo` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '社团头像图片：表中存储图片相对路径*',
  PRIMARY KEY (`soc_id`) USING BTREE,
  CONSTRAINT `soc_id_fk` FOREIGN KEY (`soc_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `society`
--

LOCK TABLES `society` WRITE;
/*!40000 ALTER TABLE `society` DISABLE KEYS */;
INSERT INTO `society` VALUES (5,'跑步协会','跑你妈','体育类社团','NULL'),(18,'龙狮协会','舞动青春','体育类社团','NULL'),(19,'篮球协会','鸡你太美','体育类社团','NULL');
/*!40000 ALTER TABLE `society` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `society_admin`
--

DROP TABLE IF EXISTS `society_admin`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `society_admin` (
  `soc_id` int NOT NULL COMMENT '账号ID，PK，FK，与对应的user相同',
  `soc_admin_no` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '负责人学号，PK',
  `soc_admin_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '负责人姓名',
  `soc_admin_phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '负责人电话号码',
  `soc_admin_email` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '负责人邮箱',
  PRIMARY KEY (`soc_id`,`soc_admin_no`) USING BTREE,
  CONSTRAINT `soc_admin_id_fk` FOREIGN KEY (`soc_id`) REFERENCES `society` (`soc_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `society_admin`
--

LOCK TABLES `society_admin` WRITE;
/*!40000 ALTER TABLE `society_admin` DISABLE KEYS */;
/*!40000 ALTER TABLE `society_admin` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `society_image`
--

DROP TABLE IF EXISTS `society_image`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `society_image` (
  `soc_id` int NOT NULL COMMENT '社团账号id，PK',
  `soc_image` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '社团图片，PK，以相对路径的方式存储',
  PRIMARY KEY (`soc_id`,`soc_image`) USING BTREE,
  CONSTRAINT `soc_img_id_fk` FOREIGN KEY (`soc_id`) REFERENCES `society` (`soc_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `society_image`
--

LOCK TABLES `society_image` WRITE;
/*!40000 ALTER TABLE `society_image` DISABLE KEYS */;
/*!40000 ALTER TABLE `society_image` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `society_keyword`
--

DROP TABLE IF EXISTS `society_keyword`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `society_keyword` (
  `soc_id` int NOT NULL COMMENT '社团账号ID',
  `keyword` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '社团活动关键词',
  PRIMARY KEY (`soc_id`,`keyword`) USING BTREE,
  KEY `soc_kw_kw_fk` (`keyword`) USING BTREE,
  CONSTRAINT `soc_kw_id_fk` FOREIGN KEY (`soc_id`) REFERENCES `society` (`soc_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `soc_kw_kw_fk` FOREIGN KEY (`keyword`) REFERENCES `keywords` (`keyword`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `society_keyword`
--

LOCK TABLES `society_keyword` WRITE;
/*!40000 ALTER TABLE `society_keyword` DISABLE KEYS */;
/*!40000 ALTER TABLE `society_keyword` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `student`
--

DROP TABLE IF EXISTS `student`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `student` (
  `stu_id` int NOT NULL COMMENT '学生账号ID，PK，FK，与对应的user相同',
  `stu_name` varchar(64) NOT NULL,
  `stu_year` enum('2020本','2021本','2022本','2023本','硕士研究生','博士研究生') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '学生所在年级',
  `stu_school` enum('新生院','软件学院','艺术与传媒学院','外国语学院','人文学院','法学院','政治与国际关系学院','经济与管理学院','建筑与城市规划学院','设计创意学院','土木工程学院','环境科学与工程学院','机械与能源工程学院','交通运输工程学院','汽车学院','铁道与城市轨道交通研究院','材料科学与工程学院','航空航天与力学学院','测绘与地理信息学院','电子与信息工程学院','物理科学与工程学院','海洋与地球科学学院','数学科学学院','化学科学与工程学院','生命科学与技术学院','口腔医学院','医学院','中德工程学院','马克思主义学院','国际足球学院','其它学院') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '学生所在学院',
  `stu_major` varchar(80) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '学生所在专业',
  `stu_notes` varchar(128) NOT NULL,
  PRIMARY KEY (`stu_id`) USING BTREE,
  CONSTRAINT `stu_id_fk` FOREIGN KEY (`stu_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `student`
--

LOCK TABLES `student` WRITE;
/*!40000 ALTER TABLE `student` DISABLE KEYS */;
INSERT INTO `student` VALUES (1,'马威','2021本','软件学院','软件工程','臭蝈蝻'),(2,'杨滕超','2021本','软件学院','软件工程','一人之下，万人之上'),(3,'苏家铭','2021本','软件学院','软件工程','爱情事业，双双有成'),(4,'王蔚达','2021本','软件学院','软件工程','果酱拿到手软'),(16,'test','2023本','经济与管理学院','会计学','这就是coding&testing'),(17,'马威','2021本','软件学院','软件工程','');
/*!40000 ALTER TABLE `student` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `student_keyword`
--

DROP TABLE IF EXISTS `student_keyword`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `student_keyword` (
  `stu_id` int NOT NULL COMMENT 'PK，FK，与student中的id相同',
  `keyword` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'PK,FK,与keywords表中的keyword相同',
  `prefer_weight` decimal(10,5) DEFAULT NULL COMMENT '喜好标签权重，推荐算法确定',
  PRIMARY KEY (`stu_id`,`keyword`) USING BTREE,
  KEY `stu_kw_kw_fk` (`keyword`) USING BTREE,
  CONSTRAINT `stu_kw_id_fk` FOREIGN KEY (`stu_id`) REFERENCES `student` (`stu_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `stu_kw_kw_fk` FOREIGN KEY (`keyword`) REFERENCES `keywords` (`keyword`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `student_keyword`
--

LOCK TABLES `student_keyword` WRITE;
/*!40000 ALTER TABLE `student_keyword` DISABLE KEYS */;
INSERT INTO `student_keyword` VALUES (16,'技术',0.00000),(16,'数据分析',0.00000),(16,'模型',0.00000),(16,'研究',0.00000),(17,'健康',0.00000),(17,'天文',0.00000);
/*!40000 ALTER TABLE `student_keyword` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '用户唯一标识ID，主键，递增',
  `username` varchar(16) NOT NULL,
  `password` varchar(256) NOT NULL,
  `email` varchar(64) NOT NULL,
  `phone` varchar(11) NOT NULL,
  `campus` enum('四平路校区','嘉定校区','沪西校区','沪北校区','其他校区') DEFAULT NULL,
  `login_status` int NOT NULL COMMENT '登录状态，0：未登录/1：登录',
  `account_status` int NOT NULL COMMENT '账号状态，0：封禁/1：正常/2：待审核',
  `balance` decimal(15,2) NOT NULL COMMENT '账户余额',
  `pay_password` varchar(256) NOT NULL,
  `reg_time` datetime(6) NOT NULL ON UPDATE CURRENT_TIMESTAMP(6) COMMENT '注册时间',
  `role` int NOT NULL COMMENT '用户类型，0：普通用户/1：社团管理员/2：系统管理员',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `username` (`username`) USING BTREE COMMENT 'username应当唯一'
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES (1,'2151294','1oxGgI6v3cL5Fm9hCn4L/A==','2151294@tongji.edu.cn','18177163281','四平路校区',0,1,100.00,'9YHErutaK6zQs8Q5Zb+pgw==','2024-06-23 22:43:26.378168',0),(2,'2151298','KPXoa0dpKnl2eCmT1b38Hw==','2151298@tongji.edu.cn','18299887766','嘉定校区',0,1,200.00,'9YHErutaK6zQs8Q5Zb+pgw==','2024-06-19 22:40:10.470093',0),(3,'2151299','KPXoa0dpKnl2eCmT1b38Hw==','2151299@tongji.edu.cn','18399887766','嘉定校区',0,0,300.00,'9YHErutaK6zQs8Q5Zb+pgw==','2024-06-19 22:40:10.492678',0),(4,'2151300','KPXoa0dpKnl2eCmT1b38Hw==','2151300@tongji.edu.cn','18499887766','嘉定校区',0,0,400.00,'2Y1xR4IhWWHz9JRpg7IK5g==','2024-06-19 22:40:10.516179',0),(5,'跑步协会','1oxGgI6v3cL5Fm9hCn4L/A==','9980666@tongji.edu.cn','00000000000','嘉定校区',0,1,1000.00,'2Y1xR4IhWWHz9JRpg7IK5g==','2024-06-23 21:32:43.454145',1),(6,'admin','1oxGgI6v3cL5Fm9hCn4L/A==','2300000@tongji.edu.cn','18277118094','嘉定校区',0,1,0.00,'9YHErutaK6zQs8Q5Zb+pgw==','2024-05-27 13:52:57.958981',2),(16,'2345678','KPXoa0dpKnl2eCmT1b38Hw==','2345678@tongji.edu.cn','18365478945','四平路校区',0,1,0.00,'9YHErutaK6zQs8Q5Zb+pgw==','2024-01-12 12:16:20.054179',0),(17,'2151295','1oxGgI6v3cL5Fm9hCn4L/A==','2151294@tongji.edu.cn','18277118094','四平路校区',0,2,0.00,'2Y1xR4IhWWHz9JRpg7IK5g==','2024-06-19 22:40:10.541836',0),(18,'龙狮协会','1oxGgI6v3cL5Fm9hCn4L/A==','7711345@tongji.edu.cn','00000000000','四平路校区',0,0,3000.00,'2Y1xR4IhWWHz9JRpg7IK5g==','2024-06-23 21:32:38.990041',1),(19,'篮球协会','KPXoa0dpKnl2eCmT1b38Hw==','6688449@tongji.edu.cn','11111111111','四平路校区',0,1,2500.00,'2Y1xR4IhWWHz9JRpg7IK5g==','2024-06-22 15:48:12.000000',1);
/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping events for database 'jiticket_test'
--

--
-- Dumping routines for database 'jiticket_test'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-06-24 15:03:45
