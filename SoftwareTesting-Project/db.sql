/*
 Navicat Premium Data Transfer

 Source Server         : root
 Source Server Type    : MySQL
 Source Server Version : 80035
 Source Host           : localhost:3306
 Source Schema         : test_db1

 Target Server Type    : MySQL
 Target Server Version : 80035
 File Encoding         : 65001
 
 Cretor: Han Jiarui
 Date: 09/12/2023 23:20:33
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for activity
-- ----------------------------
DROP TABLE IF EXISTS `activity`;
CREATE TABLE `activity`  (
  `act_id` int NOT NULL AUTO_INCREMENT COMMENT '活动id',
  `act_name` varchar(80) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '管理员可修改，管理员备注内容融合在这里*',
  `act_intro` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '活动简介',
  `act_location` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '活动地点',
  `ticket_price` decimal(10, 2) NOT NULL COMMENT '活动报名费',
  `upload_time` datetime(6) NOT NULL ON UPDATE CURRENT_TIMESTAMP(6) COMMENT '活动发布时间',
  `reg_start_time` datetime(6) NOT NULL COMMENT '活动开始报名时间',
  `reg_end_time` datetime(6) NULL DEFAULT NULL COMMENT '活动截止报名时间',
  `act_time` datetime(6) NOT NULL COMMENT '活动时间',
  `act_capacity` int NOT NULL COMMENT '活动总容量',
  `act_left` int NOT NULL COMMENT '活动剩余名额',
  `act_rating` decimal(5, 1) NOT NULL COMMENT '活动评分',
  `rating_num` int NOT NULL COMMENT '评分人数',
  `soc_id` int NOT NULL COMMENT '活动发布社团id，FK，引用自society表',
  PRIMARY KEY (`act_id`) USING BTREE,
  INDEX `act_soc_id_fk`(`soc_id` ASC) USING BTREE,
  CONSTRAINT `act_soc_id_fk` FOREIGN KEY (`soc_id`) REFERENCES `society` (`soc_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for activity_image
-- ----------------------------
DROP TABLE IF EXISTS `activity_image`;
CREATE TABLE `activity_image`  (
  `act_id` int NOT NULL COMMENT '活动id，PK,FK,外键依赖activity的act_ID',
  `act_image` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '活动图片，PK，以相对路径方式存储',
  PRIMARY KEY (`act_id`, `act_image`) USING BTREE,
  CONSTRAINT `act_img_id_fk` FOREIGN KEY (`act_id`) REFERENCES `activity` (`act_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for activity_keyword
-- ----------------------------
DROP TABLE IF EXISTS `activity_keyword`;
CREATE TABLE `activity_keyword`  (
  `act_id` int NOT NULL COMMENT '活动id，PK，FK,引用自activity表',
  `keyword` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '活动关键词，FK，引用自keywords表',
  PRIMARY KEY (`act_id`, `keyword`) USING BTREE,
  INDEX `act_kw_kw_fk`(`keyword` ASC) USING BTREE,
  CONSTRAINT `act_kw_id_fk` FOREIGN KEY (`act_id`) REFERENCES `activity` (`act_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `act_kw_kw_fk` FOREIGN KEY (`keyword`) REFERENCES `keywords` (`keyword`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for appeal
-- ----------------------------
DROP TABLE IF EXISTS `appeal`;
CREATE TABLE `appeal`  (
  `app_id` int NOT NULL AUTO_INCREMENT COMMENT '申诉id',
  `app_time` timestamp(6) NOT NULL COMMENT '申诉时间',
  `app_matters` int NOT NULL COMMENT '申诉事项类型',
  `app_content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '申诉描述',
  `user_id` int NULL DEFAULT NULL COMMENT '被申诉用户id',
  `act_id` int NULL DEFAULT NULL COMMENT '被申诉活动id',
  `cmt_id` int NULL DEFAULT NULL COMMENT '被申诉评论id',
  `complainant_id` int NOT NULL COMMENT '申诉者id',
  PRIMARY KEY (`app_id`) USING BTREE,
  INDEX `app_user_id_fk`(`user_id` ASC) USING BTREE,
  INDEX `app_cmt_id_fk`(`cmt_id` ASC) USING BTREE,
  INDEX `app_act_id_fk`(`act_id` ASC) USING BTREE,
  INDEX `app_comp_id_fk`(`complainant_id` ASC) USING BTREE,
  CONSTRAINT `app_act_id_fk` FOREIGN KEY (`act_id`) REFERENCES `activity` (`act_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `app_cmt_id_fk` FOREIGN KEY (`cmt_id`) REFERENCES `comment` (`cmt_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `app_comp_id_fk` FOREIGN KEY (`complainant_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `app_user_id_fk` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for appeal_image
-- ----------------------------
DROP TABLE IF EXISTS `appeal_image`;
CREATE TABLE `appeal_image`  (
  `app_id` int NOT NULL COMMENT '申诉id',
  `app_image` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '截图图像，以相对路径存储',
  PRIMARY KEY (`app_id`, `app_image`) USING BTREE,
  CONSTRAINT `app_img_id_fk` FOREIGN KEY (`app_id`) REFERENCES `appeal` (`app_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for browse
-- ----------------------------
DROP TABLE IF EXISTS `browse`;
CREATE TABLE `browse`  (
  `bro_time_start` timestamp(3) NOT NULL COMMENT '浏览起始时间',
  `act_id` int NOT NULL COMMENT '活动id',
  `browser_id` int NOT NULL COMMENT '浏览者id',
  `whether_buy` int NOT NULL COMMENT '购买情况，0:未购买/1:购买',
  PRIMARY KEY (`bro_time_start`, `act_id`, `browser_id`) USING BTREE,
  INDEX `bro_act_id_fk`(`act_id` ASC) USING BTREE,
  INDEX `bro_stu_id_fk`(`browser_id` ASC) USING BTREE,
  CONSTRAINT `bro_act_id_fk` FOREIGN KEY (`act_id`) REFERENCES `activity` (`act_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `bro_stu_id_fk` FOREIGN KEY (`browser_id`) REFERENCES `student` (`stu_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for chat
-- ----------------------------
DROP TABLE IF EXISTS `chat`;
CREATE TABLE `chat`  (
  `chat_time` timestamp(3) NOT NULL COMMENT '聊天时间(精确到毫秒）',
  `stu_id` int NOT NULL COMMENT '个人用户ID',
  `soc_id` int NOT NULL COMMENT '社团ID',
  `chat_content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '聊天内容',
  `chat_sender` int NOT NULL COMMENT '发出者,0：个人用户/1：社团',
  PRIMARY KEY (`chat_time`, `stu_id`, `soc_id`) USING BTREE,
  INDEX `chat_stu_id_fk`(`stu_id` ASC) USING BTREE,
  INDEX `chat_soc_id_fk`(`soc_id` ASC) USING BTREE,
  CONSTRAINT `chat_soc_id_fk` FOREIGN KEY (`soc_id`) REFERENCES `society` (`soc_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `chat_stu_id_fk` FOREIGN KEY (`stu_id`) REFERENCES `student` (`stu_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for comment
-- ----------------------------
DROP TABLE IF EXISTS `comment`;
CREATE TABLE `comment`  (
  `cmt_id` int NOT NULL AUTO_INCREMENT COMMENT '评论id',
  `cmt_father` int NOT NULL COMMENT '父评论，0：无父评论/非零：父评论ID*',
  `cmt_content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '评论内容',
  `cmt_time` datetime(6) NOT NULL ON UPDATE CURRENT_TIMESTAMP(6) COMMENT '评论时间',
  `act_id` int NOT NULL COMMENT '商品id',
  `user_id` int NOT NULL COMMENT '评论用户id',
  PRIMARY KEY (`cmt_id`) USING BTREE,
  INDEX `cmt_act_id_fk`(`act_id` ASC) USING BTREE,
  INDEX `cmt_user_id_fk`(`user_id` ASC) USING BTREE,
  CONSTRAINT `cmt_act_id_fk` FOREIGN KEY (`act_id`) REFERENCES `activity` (`act_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `cmt_user_id_fk` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for favour
-- ----------------------------
DROP TABLE IF EXISTS `favour`;
CREATE TABLE `favour`  (
  `act_id` int NOT NULL COMMENT '活动id',
  `stu_id` int NOT NULL COMMENT '收藏者id',
  PRIMARY KEY (`act_id`, `stu_id`) USING BTREE,
  INDEX `fav_stu_id_fk`(`stu_id` ASC) USING BTREE,
  CONSTRAINT `fav_act_id_fk` FOREIGN KEY (`act_id`) REFERENCES `activity` (`act_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fav_stu_id_fk` FOREIGN KEY (`stu_id`) REFERENCES `student` (`stu_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for indent
-- ----------------------------
DROP TABLE IF EXISTS `indent`;
CREATE TABLE `indent`  (
  `ind_id` int NOT NULL AUTO_INCREMENT COMMENT '订单id，PK',
  `ind_price` decimal(10, 2) NOT NULL COMMENT '支付金额',
  `ind_create_time` datetime(6) NOT NULL ON UPDATE CURRENT_TIMESTAMP(6) COMMENT '创建时间',
  `ind_verify_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '活动参与核销码',
  `ind_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '参与者姓名',
  `ind_stu_no` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '报名者学号',
  `ind_notes` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '可选：用户备注',
  `ind_status` int NOT NULL COMMENT '订单状态，0：待核销/1：已完成/2：已退款',
  `ind_rating` decimal(5, 1) NULL DEFAULT NULL COMMENT '评分',
  `act_id` int NOT NULL COMMENT '活动ID',
  `stu_id` int NOT NULL COMMENT '学生账号ID',
  `soc_id` int NOT NULL COMMENT '社团账号ID',
  `ind_rtime` datetime(6) NULL DEFAULT NULL COMMENT '可选：退款时间',
  `ind_rnotes` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '可选：退款备注',
  `ind_rmoney` decimal(10, 2) NULL DEFAULT NULL COMMENT '可选：退款金额',
  PRIMARY KEY (`ind_id`) USING BTREE,
  INDEX `ind_stu_id_fk`(`stu_id` ASC) USING BTREE,
  INDEX `ind_soc_id_fk`(`soc_id` ASC) USING BTREE,
  CONSTRAINT `ind_soc_id_fk` FOREIGN KEY (`soc_id`) REFERENCES `society` (`soc_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `ind_stu_id_fk` FOREIGN KEY (`stu_id`) REFERENCES `student` (`stu_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for keywords
-- ----------------------------
DROP TABLE IF EXISTS `keywords`;
CREATE TABLE `keywords`  (
  `keyword` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '活动类型关键词',
  PRIMARY KEY (`keyword`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for notice
-- ----------------------------
DROP TABLE IF EXISTS `notice`;
CREATE TABLE `notice`  (
  `ntc_id` int NOT NULL AUTO_INCREMENT COMMENT '公告id',
  `ntc_time` datetime(6) NOT NULL ON UPDATE CURRENT_TIMESTAMP(6) COMMENT '公告发布时间',
  `ntc_content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '公告内容',
  `ntc_status` int NOT NULL COMMENT '显示状态，0：未显示/1：已显示',
  `soc_id` int NOT NULL COMMENT '社团id',
  PRIMARY KEY (`ntc_id`) USING BTREE,
  INDEX `ntc_soc_id_fk`(`soc_id` ASC) USING BTREE,
  CONSTRAINT `ntc_soc_id_fk` FOREIGN KEY (`soc_id`) REFERENCES `society` (`soc_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for society
-- ----------------------------
DROP TABLE IF EXISTS `society`;
CREATE TABLE `society`  (
  `soc_id` int NOT NULL COMMENT '社团账号id，PK，FK，与对应的user相同',
  `soc_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '社团名称',
  `soc_intro` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '社团介绍',
  `soc_type` enum('体育类社团','艺术类社团','科技类社团') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '社团类别',
  `soc_logo` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '社团头像图片：表中存储图片相对路径*',
  PRIMARY KEY (`soc_id`) USING BTREE,
  CONSTRAINT `soc_id_fk` FOREIGN KEY (`soc_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for society_admin
-- ----------------------------
DROP TABLE IF EXISTS `society_admin`;
CREATE TABLE `society_admin`  (
  `soc_id` int NOT NULL COMMENT '账号ID，PK，FK，与对应的user相同',
  `soc_admin_no` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '负责人学号，PK',
  `soc_admin_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '负责人姓名',
  `soc_admin_phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '负责人电话号码',
  `soc_admin_email` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '负责人邮箱',
  PRIMARY KEY (`soc_id`, `soc_admin_no`) USING BTREE,
  CONSTRAINT `soc_admin_id_fk` FOREIGN KEY (`soc_id`) REFERENCES `society` (`soc_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for society_image
-- ----------------------------
DROP TABLE IF EXISTS `society_image`;
CREATE TABLE `society_image`  (
  `soc_id` int NOT NULL COMMENT '社团账号id，PK',
  `soc_image` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '社团图片，PK，以相对路径的方式存储',
  PRIMARY KEY (`soc_id`, `soc_image`) USING BTREE,
  CONSTRAINT `soc_img_id_fk` FOREIGN KEY (`soc_id`) REFERENCES `society` (`soc_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for society_keyword
-- ----------------------------
DROP TABLE IF EXISTS `society_keyword`;
CREATE TABLE `society_keyword`  (
  `soc_id` int NOT NULL COMMENT '社团账号ID',
  `keyword` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '社团活动关键词',
  PRIMARY KEY (`soc_id`, `keyword`) USING BTREE,
  INDEX `soc_kw_kw_fk`(`keyword` ASC) USING BTREE,
  CONSTRAINT `soc_kw_id_fk` FOREIGN KEY (`soc_id`) REFERENCES `society` (`soc_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `soc_kw_kw_fk` FOREIGN KEY (`keyword`) REFERENCES `keywords` (`keyword`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for student
-- ----------------------------
DROP TABLE IF EXISTS `student`;
CREATE TABLE `student`  (
  `stu_id` int NOT NULL COMMENT '学生账号ID，PK，FK，与对应的user相同',
  `stu_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '必选信息：学生姓名',
  `stu_year` enum('2020本','2021本','2022本','2023本','硕士研究生','博士研究生') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '学生所在年级',
  `stu_school` enum('新生院','软件学院','艺术与传媒学院','外国语学院','人文学院','法学院','政治与国际关系学院','经济与管理学院','建筑与城市规划学院','设计创意学院','土木工程学院','环境科学与工程学院','机械与能源工程学院','交通运输工程学院','汽车学院','铁道与城市轨道交通研究院','材料科学与工程学院','航空航天与力学学院','测绘与地理信息学院','电子与信息工程学院','物理科学与工程学院','海洋与地球科学学院','数学科学学院','化学科学与工程学院','生命科学与技术学院','口腔医学院','医学院','中德工程学院','马克思主义学院','国际足球学院','其它学院') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '学生所在学院',
  `stu_major` varchar(80) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '学生所在专业',
  `stu_notes` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '个人备注',
  PRIMARY KEY (`stu_id`) USING BTREE,
  CONSTRAINT `stu_id_fk` FOREIGN KEY (`stu_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for student_keyword
-- ----------------------------
DROP TABLE IF EXISTS `student_keyword`;
CREATE TABLE `student_keyword`  (
  `stu_id` int NOT NULL COMMENT 'PK，FK，与student中的id相同',
  `keyword` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'PK,FK,与keywords表中的keyword相同',
  `prefer_weight` decimal(10, 5) NULL DEFAULT NULL COMMENT '喜好标签权重，推荐算法确定',
  PRIMARY KEY (`stu_id`, `keyword`) USING BTREE,
  INDEX `stu_kw_kw_fk`(`keyword` ASC) USING BTREE,
  CONSTRAINT `stu_kw_id_fk` FOREIGN KEY (`stu_id`) REFERENCES `student` (`stu_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `stu_kw_kw_fk` FOREIGN KEY (`keyword`) REFERENCES `keywords` (`keyword`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for user
-- ----------------------------
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '用户唯一标识ID，主键，递增',
  `username` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '社团管理员为社团编号；个人用户为学号；系统管理员为\"admin\"',
  `password` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '用户密码，默认为\"123456\"',
  `email` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '可选信息：邮箱',
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '必选信息：手机号',
  `campus` enum('四平路校区','嘉定校区','沪西校区','沪北校区','其它校区') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '必选信息：校区，四平路校区/嘉定校区/沪西校区/沪北校区',
  `login_status` int NOT NULL COMMENT '登录状态，0：未登录/1：登录',
  `account_status` int NOT NULL COMMENT '账号状态，0：封禁/1：正常/2：待审核',
  `balance` decimal(15, 2) NOT NULL COMMENT '账户余额',
  `pay_password` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '支付提现密码',
  `reg_time` datetime(6) NOT NULL ON UPDATE CURRENT_TIMESTAMP(6) COMMENT '注册时间',
  `role` int NOT NULL COMMENT '用户类型，0：个人用户/1：社团管理员/2：系统管理员',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `username`(`username` ASC) USING BTREE COMMENT 'username应当唯一'
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

SET FOREIGN_KEY_CHECKS = 1;
