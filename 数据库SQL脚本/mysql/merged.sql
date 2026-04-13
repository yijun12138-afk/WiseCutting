-- =====================================================
-- 服装裁剪管理系统 - 完整数据库脚本（合并版）
-- 数据库: smart_admin_v3
-- 说明: 包含系统表 + 业务表，执行前会删除旧库重建
-- =====================================================

DROP DATABASE IF EXISTS `smart_admin_v3`;
CREATE DATABASE IF NOT EXISTS `smart_admin_v3` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `smart_admin_v3`;

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for t_change_log
-- ----------------------------
DROP TABLE IF EXISTS `t_change_log`;
CREATE TABLE `t_change_log`  (
  `change_log_id` bigint(0) NOT NULL AUTO_INCREMENT COMMENT '更新日志id',
  `update_version` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '版本',
  `type` int(0) NOT NULL COMMENT '更新类型:[1:特大版本功能更新;2:功能更新;3:bug修复]',
  `publish_author` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '发布人',
  `public_date` date NOT NULL COMMENT '发布日期',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '更新内容',
  `link` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '跳转链接',
  `create_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '更新时间',
  PRIMARY KEY (`change_log_id`) USING BTREE,
  UNIQUE INDEX `version_unique`(`update_version`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 19 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '系统更新日志' ROW_FORMAT = Dynamic;

INSERT INTO `t_change_log` VALUES (2, 'v1.1.0', 2, '卓大', '2020-05-09', 'SmartAdmin v1.1.0 更新', NULL, '2022-10-04 21:33:50', '2022-10-04 21:33:50');
INSERT INTO `t_change_log` VALUES (8, 'v1.0.0', 1, '卓大', '2019-11-01', 'SmartAdmin v1.0.0 首发', NULL, '2022-10-04 21:33:50', '2022-10-04 21:33:50');
INSERT INTO `t_change_log` VALUES (18, 'v3.0.0', 1, '卓大', '2024-01-01', 'SmartAdmin v3.0.0 升级 Sa-Token、AntDesignVue 4.x', NULL, '2022-10-04 21:33:50', '2022-10-04 21:33:50');

-- ----------------------------
-- Table structure for t_code_generator_config
-- ----------------------------
DROP TABLE IF EXISTS `t_code_generator_config`;
CREATE TABLE `t_code_generator_config`  (
  `table_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '表名',
  `basic` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '基础命名信息',
  `fields` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '字段列表',
  `insert_and_update` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '新建、修改',
  `delete_info` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '删除',
  `query_fields` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '查询',
  `table_fields` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '列表',
  `detail` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '详情',
  `create_time` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '更新时间',
  PRIMARY KEY (`table_name`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '代码生成器的每个表的配置' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for t_config
-- ----------------------------
DROP TABLE IF EXISTS `t_config`;
CREATE TABLE `t_config`  (
  `config_id` bigint(0) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `config_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '参数名字',
  `config_key` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '参数key',
  `config_value` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `update_time` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '上次修改时间',
  `create_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`config_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 10 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '系统配置' ROW_FORMAT = Dynamic;

INSERT INTO `t_config` VALUES (1, '万能密码', 'super_password', '1024ok', NULL, '2024-09-03 21:27:03', '2021-12-16 23:32:46');
INSERT INTO `t_config` VALUES (2, '三级等保', 'level3_protect_config', '{\n\t"fileDetectFlag":true,\n\t"loginActiveTimeoutMinutes":30,\n\t"loginFailLockMinutes":30,\n\t"loginFailMaxTimes":3,\n\t"maxUploadFileSizeMb":30,\n\t"passwordComplexityEnabled":true,\n\t"regularChangePasswordMonths":3,\n\t"regularChangePasswordNotAllowRepeatTimes":3,\n\t"twoFactorLoginEnabled":false\n}', NULL, '2024-09-03 21:49:23', '2024-08-13 11:44:49');

-- ----------------------------
-- Table structure for t_data_tracer
-- ----------------------------
DROP TABLE IF EXISTS `t_data_tracer`;
CREATE TABLE `t_data_tracer`  (
  `data_tracer_id` bigint(0) NOT NULL AUTO_INCREMENT,
  `data_id` bigint(0) NOT NULL COMMENT '各种单据的id',
  `type` int(0) NOT NULL COMMENT '单据类型',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '操作内容',
  `diff_old` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '差异：旧的数据',
  `diff_new` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '差异：新的数据',
  `extra_data` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '额外信息',
  `user_id` bigint(0) NOT NULL COMMENT '用户id',
  `user_type` int(0) NOT NULL COMMENT '用户类型：1 后管用户 ',
  `user_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '用户名称',
  `ip` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'ip',
  `ip_region` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'ip地区',
  `user_agent` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '用户ua',
  `update_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '更新时间',
  `create_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`data_tracer_id`) USING BTREE,
  INDEX `order_id_order_type`(`data_id`, `type`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 100 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '各种单据操作记录' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for t_department
-- ----------------------------
DROP TABLE IF EXISTS `t_department`;
CREATE TABLE `t_department`  (
  `department_id` bigint(0) NOT NULL AUTO_INCREMENT COMMENT '部门主键id',
  `department_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '部门名称',
  `manager_id` bigint(0) NULL DEFAULT NULL COMMENT '部门负责人id',
  `parent_id` bigint(0) NOT NULL DEFAULT 0 COMMENT '部门的父级id',
  `sort` int(0) NOT NULL COMMENT '部门排序',
  `update_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '更新时间',
  `create_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`department_id`) USING BTREE,
  INDEX `parent_id`(`parent_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 9 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '部门' ROW_FORMAT = Dynamic;

INSERT INTO `t_department` VALUES (1, '乐博实验室', 1, 0, 1, '2022-10-19 20:17:09', '2022-10-19 20:17:09');
INSERT INTO `t_department` VALUES (2, '开发部', 44, 1, 1000, '2022-10-19 20:22:23', '2022-10-19 20:22:23');
INSERT INTO `t_department` VALUES (3, '产品部', 2, 1, 99, '2022-10-21 10:25:30', '2022-10-21 10:25:30');
INSERT INTO `t_department` VALUES (4, '销售部', 64, 1, 9, '2022-10-21 10:25:47', '2022-10-21 10:25:47');
INSERT INTO `t_department` VALUES (5, '测试部', 48, 1, 0, '2022-11-05 10:54:18', '2022-11-05 10:54:18');
INSERT INTO `t_department` VALUES (7, '直播组', 44, 1, 1111, '2024-07-02 19:38:15', '2024-07-02 19:38:15');
INSERT INTO `t_department` VALUES (8, '抖音组', 47, 7, 0, '2024-07-02 19:39:11', '2024-07-02 19:39:11');

-- ----------------------------
-- Table structure for t_dict
-- ----------------------------
DROP TABLE IF EXISTS `t_dict`;
CREATE TABLE `t_dict` (
  `dict_id` bigint NOT NULL AUTO_INCREMENT COMMENT '字典id',
  `dict_name` varchar(500) NOT NULL COMMENT '字典名字',
  `dict_code` varchar(500) NOT NULL COMMENT '字典编码',
  `remark` varchar(1000) DEFAULT NULL COMMENT '字典备注',
  `disabled_flag` tinyint NOT NULL DEFAULT '0' COMMENT '禁用状态',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`dict_id`),
  UNIQUE KEY `unique_code` (`dict_code`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='字典表';

INSERT INTO `t_dict`(`dict_id`, `dict_name`, `dict_code`, `remark`, `disabled_flag`, `create_time`, `update_time`) VALUES (1, '商品地区', 'GOODS_PLACE', NULL, 0, '2025-03-27 14:42:26', '2025-03-31 11:23:03');

-- ----------------------------
-- Table structure for t_dict_data
-- ----------------------------
DROP TABLE IF EXISTS `t_dict_data`;
CREATE TABLE `t_dict_data` (
  `dict_data_id` bigint NOT NULL AUTO_INCREMENT COMMENT '字典数据id',
  `dict_id` bigint NOT NULL COMMENT '字典id',
  `data_value` varchar(500) NOT NULL COMMENT '字典项值',
  `data_label` varchar(500) NOT NULL COMMENT '字典项显示名称',
  `data_style` varchar(500) NULL COMMENT '字典项样式',
  `remark` varchar(1000) DEFAULT NULL COMMENT '备注',
  `sort_order` int NOT NULL COMMENT '排序（越大越靠前）',
  `disabled_flag` tinyint NOT NULL DEFAULT '0' COMMENT '禁用状态',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`dict_data_id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='字典数据表';

INSERT INTO `t_dict_data` VALUES (2, 1, 'LUO_YANG', '洛阳', '', NULL, 2, 0, '2025-03-27 15:52:39', '2025-03-27 20:53:21');
INSERT INTO `t_dict_data` VALUES (3, 1, 'ZHENG_ZHOU', '郑州', '', NULL, 0, 0, '2025-03-27 18:58:16', '2025-03-27 20:53:32');
INSERT INTO `t_dict_data` VALUES (7, 1, 'BEI_JING', '北京', '', NULL, 0, 0, '2025-03-27 20:53:45', '2025-03-27 20:53:45');
INSERT INTO `t_dict_data` VALUES (8, 1, 'SHANG_HAI', '上海', '', NULL, 0, 0, '2025-03-27 20:53:45', '2025-03-27 20:53:45');

-- ----------------------------
-- Table structure for t_employee
-- ----------------------------
DROP TABLE IF EXISTS `t_employee`;
CREATE TABLE `t_employee`  (
  `employee_id` bigint(0) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `employee_uid` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '员工uuid',
  `login_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '登录帐号',
  `login_pwd` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '登录密码',
  `actual_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '员工名称',
  `avatar` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `gender` tinyint(1) NOT NULL DEFAULT 0 COMMENT '性别',
  `phone` varchar(15) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '手机号码',
  `department_id` bigint(0) NOT NULL COMMENT '部门id',
  `position_id` bigint(0) NULL DEFAULT NULL COMMENT '职务ID',
  `email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '邮箱',
  `disabled_flag` tinyint unsigned NOT NULL COMMENT '是否被禁用 0否1是',
  `deleted_flag` tinyint unsigned NOT NULL COMMENT '是否删除0否 1是',
  `administrator_flag` tinyint(0) NOT NULL DEFAULT 0 COMMENT '是否为超级管理员: 0 不是，1是',
  `remark` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  `update_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '更新时间',
  `create_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`employee_id`) USING BTREE,
  UNIQUE INDEX `employee_uid_index`(`employee_uid`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 75 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '员工表' ROW_FORMAT = Dynamic;

INSERT INTO `t_employee`(`employee_id`, `employee_uid`, `login_name`, `login_pwd`, `actual_name`, `avatar`, `gender`, `phone`, `department_id`, `position_id`, `email`, `disabled_flag`, `deleted_flag`, `administrator_flag`, `remark`, `update_time`, `create_time`) VALUES (1, 'cf1e361fd46741f5b2a09335cef50db8', 'admin', '$argon2id$v=19$m=16384,t=2,p=1$d9yQEAhck+haKxP2ZtXocg$NEnw3D2Ly8UbYpy2odATLA4ZflZ1FKJjWCuOGrVE4PM', '管理员', NULL, 0, '13500000000', 1, 3, NULL, 0, 0, 1, NULL, '2025-07-15 10:19:23', '2022-10-04 21:33:50');
INSERT INTO `t_employee`(`employee_id`, `employee_uid`, `login_name`, `login_pwd`, `actual_name`, `avatar`, `gender`, `phone`, `department_id`, `position_id`, `email`, `disabled_flag`, `deleted_flag`, `administrator_flag`, `remark`, `update_time`, `create_time`) VALUES (2, '3c253628b4cb4302a7bb83008a82a415', 'huke', '$argon2id$v=19$m=16384,t=2,p=1$3N9HxhPdydtmqXmTmBUxcw$Yh2jMqQ5qmCC1cgezKtFd5vuH8WirHZh6FPnFS0clEY', '胡克', NULL, 0, '13123123121', 1, 4, NULL, 0, 0, 0, NULL, '2025-07-15 10:19:23', '2022-10-04 21:33:50');
INSERT INTO `t_employee`(`employee_id`, `employee_uid`, `login_name`, `login_pwd`, `actual_name`, `avatar`, `gender`, `phone`, `department_id`, `position_id`, `email`, `disabled_flag`, `deleted_flag`, `administrator_flag`, `remark`, `update_time`, `create_time`) VALUES (44, '5e2a57cd8eff4346be03dc2acfed0d7c', 'zhuoda', '$argon2id$v=19$m=16384,t=2,p=1$Mt02VdlsDNrteY/sBOs2uw$0gI5gfb/D4iLGi6RRlEq/4Qo71cseuz5YZrwiCj3VQI', '卓大', NULL, 1, '18637925892', 1, 6, NULL, 0, 0, 0, NULL, '2025-07-15 10:19:23', '2022-10-04 21:33:50');
INSERT INTO `t_employee`(`employee_id`, `employee_uid`, `login_name`, `login_pwd`, `actual_name`, `avatar`, `gender`, `phone`, `department_id`, `position_id`, `email`, `disabled_flag`, `deleted_flag`, `administrator_flag`, `remark`, `update_time`, `create_time`) VALUES (47, 'b031a061076a4732aa0d63989adb1fbc', 'shanyi', '$argon2id$v=19$m=16384,t=2,p=1$lsqZF68KCPkPaF2ShNhtNQ$Zpsv0GLBeau3x0hL0JzpWtnIlNf0hh3+P6Zu5fM6gJw', '善逸', NULL, 1, '17630506613', 2, 5, NULL, 0, 0, 0, NULL, '2025-07-15 10:19:23', '2022-10-04 21:33:50');
INSERT INTO `t_employee`(`employee_id`, `employee_uid`, `login_name`, `login_pwd`, `actual_name`, `avatar`, `gender`, `phone`, `department_id`, `position_id`, `email`, `disabled_flag`, `deleted_flag`, `administrator_flag`, `remark`, `update_time`, `create_time`) VALUES (48, 'e29327485b784211aa9677a9436d2e00', 'qinjiu', '$argon2id$v=19$m=16384,t=2,p=1$ga8Ww+zlLShAzC8o54qftg$3Ete1M8/zzepZqiEV1yNu/U7svMI0EuDWVKZ9X5M1uQ', '琴酒', NULL, 2, '14112343212', 2, 6, NULL, 0, 0, 0, NULL, '2025-07-15 10:19:23', '2022-10-04 21:33:50');
INSERT INTO `t_employee`(`employee_id`, `employee_uid`, `login_name`, `login_pwd`, `actual_name`, `avatar`, `gender`, `phone`, `department_id`, `position_id`, `email`, `disabled_flag`, `deleted_flag`, `administrator_flag`, `remark`, `update_time`, `create_time`) VALUES (63, 'cab6922aeeb949a997c93c043b909b05', 'kaiyun', '$argon2id$v=19$m=16384,t=2,p=1$5TZB3BWsbv0FXrgA60+7ag$pnDVVvjE/J0kOet3xLq19fyv1+a/KGqN6B+xsvDluYc', '开云', NULL, 0, '13112312346', 2, 5, 'ss@qq.com', 0, 0, 0, NULL, '2025-07-15 10:19:23', '2022-10-04 21:33:50');
INSERT INTO `t_employee`(`employee_id`, `employee_uid`, `login_name`, `login_pwd`, `actual_name`, `avatar`, `gender`, `phone`, `department_id`, `position_id`, `email`, `disabled_flag`, `deleted_flag`, `administrator_flag`, `remark`, `update_time`, `create_time`) VALUES (64, '02ce19c1c707448a81159834a60bbd94', 'qingye', '$argon2id$v=19$m=16384,t=2,p=1$X+M3CF1557PGfLavpWXCPQ$2LsEiOgLFP+VbGA/7TPAbLnkyiLollova6iETB9S/ds', '清野', NULL, 1, '13123123111', 2, 4, NULL, 0, 0, 0, NULL, '2025-07-15 10:19:23', '2022-10-04 21:33:50');
INSERT INTO `t_employee`(`employee_id`, `employee_uid`, `login_name`, `login_pwd`, `actual_name`, `avatar`, `gender`, `phone`, `department_id`, `position_id`, `email`, `disabled_flag`, `deleted_flag`, `administrator_flag`, `remark`, `update_time`, `create_time`) VALUES (68, '2aaf8c8c393c46b080aca86179388d7e', 'xuanpeng', '$argon2id$v=19$m=16384,t=2,p=1$ldHEjEwCWur/RnSy0JmFJQ$nlhVYiFMELToZ9nXI5QxG4maTV/L7pyPU0GRv3+s+tg', '玄朋', NULL, 1, '13123123124', 1, 3, NULL, 0, 0, 0, NULL, '2025-07-15 10:19:23', '2022-10-04 21:33:50');

-- ----------------------------
-- Table structure for t_feedback
-- ----------------------------
DROP TABLE IF EXISTS `t_feedback`;
CREATE TABLE `t_feedback`  (
  `feedback_id` bigint(0) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `feedback_content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '反馈内容',
  `feedback_attachment` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '反馈图片',
  `user_id` bigint(0) NOT NULL COMMENT '创建人id',
  `user_type` int(0) NOT NULL COMMENT '创建人用户类型',
  `user_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '创建人姓名',
  `create_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '更新时间',
  PRIMARY KEY (`feedback_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 14 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '意见反馈' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for t_file
-- ----------------------------
DROP TABLE IF EXISTS `t_file`;
CREATE TABLE `t_file`  (
  `file_id` bigint(0) NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `folder_type` tinyint unsigned NOT NULL COMMENT '文件夹类型',
  `file_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '文件名称',
  `file_size` int(0) NULL DEFAULT NULL COMMENT '文件大小',
  `file_key` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '文件key，用于文件下载',
  `file_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '文件类型',
  `creator_id` bigint(0) NULL DEFAULT NULL COMMENT '创建人，即上传人',
  `creator_user_type` int(0) NULL DEFAULT NULL COMMENT '创建人用户类型',
  `creator_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '创建人姓名',
  `update_time` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP COMMENT '上次更新时间',
  `create_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`file_id`) USING BTREE,
  UNIQUE INDEX `uk_file_key`(`file_key`) USING BTREE,
  INDEX `module_id_module_type`(`folder_type`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 108 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '文件' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for t_heart_beat_record
-- ----------------------------
DROP TABLE IF EXISTS `t_heart_beat_record`;
CREATE TABLE `t_heart_beat_record`  (
  `heart_beat_record_id` int(0) NOT NULL AUTO_INCREMENT COMMENT '自增id',
  `project_path` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '项目名称',
  `server_ip` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '服务器ip',
  `process_no` int(0) NOT NULL COMMENT '进程号',
  `process_start_time` datetime(0) NOT NULL COMMENT '进程开启时间',
  `heart_beat_time` datetime(0) NOT NULL COMMENT '心跳时间',
  PRIMARY KEY (`heart_beat_record_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 188 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '公用服务 - 服务心跳' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for t_help_doc
-- ----------------------------
DROP TABLE IF EXISTS `t_help_doc`;
CREATE TABLE `t_help_doc`  (
  `help_doc_id` bigint(0) NOT NULL AUTO_INCREMENT,
  `help_doc_catalog_id` bigint(0) NOT NULL COMMENT '类型1公告 2动态',
  `title` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '标题',
  `content_text` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '文本内容',
  `content_html` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'html内容',
  `attachment` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '附件',
  `sort` int(0) NOT NULL DEFAULT 0 COMMENT '排序',
  `page_view_count` int(0) NOT NULL DEFAULT 0 COMMENT '页面浏览量',
  `user_view_count` int(0) NOT NULL DEFAULT 0 COMMENT '用户浏览量',
  `author` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '作者',
  `update_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0),
  `create_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`help_doc_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 35 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '帮助文档' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for t_help_doc_catalog
-- ----------------------------
DROP TABLE IF EXISTS `t_help_doc_catalog`;
CREATE TABLE `t_help_doc_catalog`  (
  `help_doc_catalog_id` bigint(0) NOT NULL AUTO_INCREMENT COMMENT '帮助文档目录',
  `name` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '名称',
  `sort` int(0) NOT NULL DEFAULT 0 COMMENT '排序字段',
  `parent_id` bigint(0) NOT NULL COMMENT '父级id',
  `create_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0),
  PRIMARY KEY (`help_doc_catalog_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 12 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '帮助文档-目录' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for t_help_doc_relation
-- ----------------------------
DROP TABLE IF EXISTS `t_help_doc_relation`;
CREATE TABLE `t_help_doc_relation`  (
  `relation_id` bigint(0) NOT NULL COMMENT '关联id',
  `relation_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '关联名称',
  `help_doc_id` bigint(0) NOT NULL COMMENT '文档id',
  `create_time` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0),
  PRIMARY KEY (`relation_id`, `help_doc_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '帮助文档-关联表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for t_help_doc_view_record
-- ----------------------------
DROP TABLE IF EXISTS `t_help_doc_view_record`;
CREATE TABLE `t_help_doc_view_record`  (
  `help_doc_id` bigint(0) NOT NULL COMMENT '通知公告id',
  `user_id` bigint(0) NOT NULL COMMENT '用户id',
  `user_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '用户名称',
  `page_view_count` int(0) NULL DEFAULT 0 COMMENT '查看次数',
  `first_ip` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '首次ip',
  `first_user_agent` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '首次用户设备等标识',
  `last_ip` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '最后一次ip',
  `last_user_agent` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '最后一次用户设备等标识',
  `create_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0),
  PRIMARY KEY (`help_doc_id`, `user_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '帮助文档-查看记录' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for t_login_fail
-- ----------------------------
DROP TABLE IF EXISTS `t_login_fail`;
CREATE TABLE `t_login_fail`  (
  `login_fail_id` bigint(0) NOT NULL AUTO_INCREMENT COMMENT '自增id',
  `user_id` bigint(0) NOT NULL COMMENT '用户id',
  `user_type` int(0) NOT NULL COMMENT '用户类型',
  `login_name` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '登录名',
  `login_fail_count` int(0) NULL DEFAULT NULL COMMENT '连续登录失败次数',
  `lock_flag` tinyint(0) NULL DEFAULT 0 COMMENT '锁定状态:1锁定，0未锁定',
  `login_lock_begin_time` datetime(0) NULL DEFAULT NULL COMMENT '连续登录失败锁定开始时间',
  `create_time` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '更新时间',
  PRIMARY KEY (`login_fail_id`) USING BTREE,
  UNIQUE INDEX `uid_and_utype`(`user_id`, `user_type`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 85 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '登录失败次数记录表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for t_login_log
-- ----------------------------
DROP TABLE IF EXISTS `t_login_log`;
CREATE TABLE `t_login_log` (
  `login_log_id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `user_id` int NOT NULL COMMENT '用户id',
  `user_type` int NOT NULL COMMENT '用户类型',
  `user_name` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '用户名',
  `login_ip` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '用户ip',
  `login_ip_region` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '用户ip地区',
  `user_agent` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT 'user-agent信息',
  `login_device` varchar(1000) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '登录设备',
  `login_result` int NOT NULL COMMENT '登录结果：0成功 1失败 2 退出',
  `remark` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '备注',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`login_log_id`) USING BTREE,
  KEY `customer_id` (`user_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1905 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='用户登录日志';

-- ----------------------------
-- Table structure for t_mail_template
-- ----------------------------
DROP TABLE IF EXISTS `t_mail_template`;
CREATE TABLE `t_mail_template`  (
  `template_code` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `template_subject` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '模板名称',
  `template_content` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '模板内容',
  `template_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '解析类型 string，freemarker',
  `disable_flag` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否禁用',
  `update_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  `create_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`template_code`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for t_menu
-- ----------------------------
DROP TABLE IF EXISTS `t_menu`;
CREATE TABLE `t_menu`  (
  `menu_id` bigint(0) NOT NULL AUTO_INCREMENT COMMENT '菜单ID',
  `menu_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '菜单名称',
  `menu_type` int(0) NOT NULL COMMENT '类型',
  `parent_id` bigint(0) NOT NULL COMMENT '父菜单ID',
  `sort` int(0) NULL DEFAULT NULL COMMENT '显示顺序',
  `path` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '路由地址',
  `component` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '组件路径',
  `perms_type` int(0) NULL DEFAULT NULL COMMENT '权限类型',
  `api_perms` varchar(5000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '后端权限字符串',
  `web_perms` varchar(5000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '前端权限字符串',
  `icon` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '菜单图标',
  `context_menu_id` bigint(0) NULL DEFAULT NULL COMMENT '功能点关联菜单ID',
  `frame_flag` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否为外链',
  `frame_url` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '外链地址',
  `cache_flag` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否缓存',
  `visible_flag` tinyint(1) NOT NULL DEFAULT 1 COMMENT '显示状态',
  `disabled_flag` tinyint(1) NOT NULL DEFAULT 0 COMMENT '禁用状态',
  `deleted_flag` tinyint(1) NOT NULL DEFAULT 0 COMMENT '删除状态',
  `create_user_id` bigint(0) NOT NULL COMMENT '创建人',
  `create_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_user_id` bigint(0) NULL DEFAULT NULL COMMENT '更新人',
  `update_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '更新时间',
  PRIMARY KEY (`menu_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 268 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '菜单表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for t_message
-- ----------------------------
DROP TABLE IF EXISTS `t_message`;
CREATE TABLE `t_message`  (
  `message_id` bigint(0) NOT NULL AUTO_INCREMENT COMMENT '消息id',
  `message_type` smallint(0) NOT NULL COMMENT '消息类型',
  `receiver_user_type` int(0) NOT NULL COMMENT '接收者用户类型',
  `receiver_user_id` bigint(0) NOT NULL COMMENT '接收者用户id',
  `data_id` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '相关数据id',
  `title` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '标题',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '内容',
  `read_flag` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否已读',
  `read_time` datetime(0) NULL DEFAULT NULL COMMENT '已读时间',
  `create_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '更新时间',
  PRIMARY KEY (`message_id`) USING BTREE,
  INDEX `idx_msg`(`message_type`, `receiver_user_type`, `receiver_user_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '通知消息' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for t_notice
-- ----------------------------
DROP TABLE IF EXISTS `t_notice`;
CREATE TABLE `t_notice`  (
  `notice_id` bigint(0) NOT NULL AUTO_INCREMENT,
  `notice_type_id` bigint(0) NOT NULL COMMENT '类型1公告 2动态',
  `title` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '标题',
  `all_visible_flag` tinyint(1) NOT NULL COMMENT '是否全部可见',
  `scheduled_publish_flag` tinyint(1) NOT NULL COMMENT '是否定时发布',
  `publish_time` datetime(0) NOT NULL COMMENT '发布时间',
  `content_text` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '文本内容',
  `content_html` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'html内容',
  `attachment` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '附件',
  `page_view_count` int(0) NOT NULL DEFAULT 0 COMMENT '页面浏览量',
  `user_view_count` int(0) NOT NULL DEFAULT 0 COMMENT '用户浏览量',
  `source` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '来源',
  `author` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '作者',
  `document_number` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '文号',
  `deleted_flag` tinyint(1) NOT NULL DEFAULT 0,
  `create_user_id` bigint(0) NULL DEFAULT NULL COMMENT '创建人',
  `update_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0),
  `create_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`notice_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 65 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '通知' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for t_notice_type
-- ----------------------------
DROP TABLE IF EXISTS `t_notice_type`;
CREATE TABLE `t_notice_type`  (
  `notice_type_id` bigint(0) NOT NULL AUTO_INCREMENT COMMENT '通知类型',
  `notice_type_name` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '类型名称',
  `create_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0),
  PRIMARY KEY (`notice_type_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '通知类型' ROW_FORMAT = Dynamic;

INSERT INTO `t_notice_type` VALUES (1, '新闻', '2022-08-16 20:29:15', '2024-09-03 21:44:42');
INSERT INTO `t_notice_type` VALUES (2, '通知', '2022-08-16 20:29:20', '2022-08-16 20:29:20');

-- ----------------------------
-- Table structure for t_notice_view_record
-- ----------------------------
DROP TABLE IF EXISTS `t_notice_view_record`;
CREATE TABLE `t_notice_view_record`  (
  `notice_id` bigint(0) NOT NULL COMMENT '通知公告id',
  `employee_id` bigint(0) NOT NULL COMMENT '员工id',
  `page_view_count` int(0) NULL DEFAULT 0 COMMENT '查看次数',
  `first_ip` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `first_user_agent` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `last_ip` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `last_user_agent` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `create_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0),
  PRIMARY KEY (`notice_id`, `employee_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '通知查看记录' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for t_notice_visible_range
-- ----------------------------
DROP TABLE IF EXISTS `t_notice_visible_range`;
CREATE TABLE `t_notice_visible_range`  (
  `notice_id` bigint(0) NOT NULL COMMENT '资讯id',
  `data_type` tinyint(0) NOT NULL COMMENT '数据类型1员工 2部门',
  `data_id` bigint(0) NOT NULL COMMENT '员工or部门id',
  `create_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  UNIQUE INDEX `uk_notice_data`(`notice_id`, `data_type`, `data_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '通知可见范围' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for t_oa_bank
-- ----------------------------
DROP TABLE IF EXISTS `t_oa_bank`;
CREATE TABLE `t_oa_bank`  (
  `bank_id` bigint(0) NOT NULL AUTO_INCREMENT COMMENT '银行信息ID',
  `bank_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '开户银行',
  `account_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '账户名称',
  `account_number` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '账号',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  `business_flag` tinyint(1) NOT NULL COMMENT '是否对公',
  `enterprise_id` bigint(0) NOT NULL COMMENT '企业ID',
  `disabled_flag` tinyint(1) NOT NULL DEFAULT 0 COMMENT '禁用状态',
  `deleted_flag` tinyint(1) NOT NULL DEFAULT 0 COMMENT '删除状态',
  `create_user_id` bigint(0) NOT NULL COMMENT '创建人ID',
  `create_user_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '创建人',
  `create_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '更新时间',
  PRIMARY KEY (`bank_id`) USING BTREE,
  INDEX `idx_enterprise_id`(`enterprise_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 29 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = 'OA银行信息' ROW_FORMAT = Dynamic;

INSERT INTO `t_oa_bank` VALUES (26, '工商银行', '1024创新实验室', '1024', '基本户', 1, 2, 0, 0, 1, '管理员', '2022-10-22 17:58:43', '2022-10-22 17:58:43');
INSERT INTO `t_oa_bank` VALUES (27, '建设银行', '1024创新实验室', '10241', '其他户', 0, 2, 0, 0, 1, '管理员', '2022-10-22 17:59:19', '2022-10-22 17:59:19');

-- ----------------------------
-- Table structure for t_oa_enterprise
-- ----------------------------
DROP TABLE IF EXISTS `t_oa_enterprise`;
CREATE TABLE `t_oa_enterprise`  (
  `enterprise_id` bigint(0) NOT NULL AUTO_INCREMENT COMMENT '企业ID',
  `enterprise_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '企业名称',
  `enterprise_logo` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '企业logo',
  `type` int(0) NOT NULL DEFAULT 1 COMMENT '类型（1:有限公司;2:合伙公司）',
  `unified_social_credit_code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '统一社会信用代码',
  `contact` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '联系人',
  `contact_phone` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '联系人电话',
  `email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '邮箱',
  `province` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '省份',
  `province_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '省份名称',
  `city` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '市',
  `city_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '城市名称',
  `district` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '区县',
  `district_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '区县名称',
  `address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '详细地址',
  `business_license` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '营业执照',
  `disabled_flag` tinyint(1) NOT NULL DEFAULT 0 COMMENT '禁用状态',
  `deleted_flag` tinyint(1) NOT NULL DEFAULT 0 COMMENT '删除状态',
  `create_user_id` bigint(0) NOT NULL COMMENT '创建人ID',
  `create_user_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '创建人',
  `create_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '更新时间',
  PRIMARY KEY (`enterprise_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 127 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = 'OA企业模块' ROW_FORMAT = Dynamic;

INSERT INTO `t_oa_enterprise` VALUES (2, '1024创新实验室', '', 2, '1024lab', '卓大', '18637925892', 'lab1024@163.com', '410000', '河南省', '410300', '洛阳市', '410311', '洛龙区', '1024大楼', NULL, 0, 0, 44, '卓大', '2022-10-22 14:57:36', '2022-10-22 17:03:57');

-- ----------------------------
-- Table structure for t_oa_enterprise_employee
-- ----------------------------
DROP TABLE IF EXISTS `t_oa_enterprise_employee`;
CREATE TABLE `t_oa_enterprise_employee`  (
  `enterprise_employee_id` bigint(0) NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `enterprise_id` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '企业ID',
  `employee_id` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '员工ID',
  `update_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '更新时间',
  `create_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`enterprise_employee_id`) USING BTREE,
  UNIQUE INDEX `uk_enterprise_employee`(`enterprise_id`, `employee_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 159 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '企业关联的员工' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for t_oa_invoice
-- ----------------------------
DROP TABLE IF EXISTS `t_oa_invoice`;
CREATE TABLE `t_oa_invoice`  (
  `invoice_id` bigint(0) NOT NULL AUTO_INCREMENT COMMENT '发票信息ID',
  `invoice_heads` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '开票抬头',
  `taxpayer_identification_number` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '纳税人识别号',
  `account_number` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '银行账户',
  `bank_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '开户行',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  `enterprise_id` bigint(0) NOT NULL COMMENT '企业ID',
  `disabled_flag` tinyint(1) NOT NULL DEFAULT 0 COMMENT '禁用状态',
  `deleted_flag` tinyint(1) NOT NULL DEFAULT 0 COMMENT '删除状态',
  `create_user_id` bigint(0) NOT NULL COMMENT '创建人ID',
  `create_user_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '创建人',
  `create_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '更新时间',
  PRIMARY KEY (`invoice_id`) USING BTREE,
  INDEX `idx_enterprise_id`(`enterprise_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 17 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = 'OA发票信息' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for t_operate_log
-- ----------------------------
DROP TABLE IF EXISTS `t_operate_log`;
CREATE TABLE `t_operate_log` (
  `operate_log_id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `operate_user_id` bigint NOT NULL COMMENT '用户id',
  `operate_user_type` int NOT NULL COMMENT '用户类型',
  `operate_user_name` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '用户名称',
  `module` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '操作模块',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '操作内容',
  `url` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '请求路径',
  `method` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '请求方法',
  `param` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '请求参数',
  `response` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '返回值',
  `ip` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '请求ip',
  `ip_region` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '请求ip地区',
  `user_agent` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '请求user-agent',
  `success_flag` tinyint DEFAULT NULL COMMENT '请求结果 0失败 1成功',
  `fail_reason` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '失败原因',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`operate_log_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=4499 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='操作记录';

-- ----------------------------
-- Table structure for t_password_log
-- ----------------------------
DROP TABLE IF EXISTS `t_password_log`;
CREATE TABLE `t_password_log`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `user_id` bigint(0) NOT NULL COMMENT '用户id',
  `user_type` tinyint(0) NOT NULL COMMENT '用户类型',
  `old_password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '旧密码',
  `new_password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '新密码',
  `update_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  `create_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `user_and_type_index`(`user_id`, `user_type`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 12 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '密码修改记录' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for t_position
-- ----------------------------
DROP TABLE IF EXISTS `t_position`;
CREATE TABLE `t_position` (
  `position_id` bigint NOT NULL AUTO_INCREMENT COMMENT '职务ID',
  `position_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '职务名称',
  `position_level` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '职级',
  `sort` int DEFAULT '0' COMMENT '排序',
  `remark` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '备注',
  `deleted_flag` tinyint(1) DEFAULT '0',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`position_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC COMMENT='职务表';

INSERT INTO `t_position`(`position_id`, `position_name`, `position_level`, `sort`, `remark`, `deleted_flag`, `create_time`, `update_time`) VALUES (3, '技术P7', 'L1', 3, '', 0, '2024-06-29 15:57:07', '2024-07-15 23:34:35');
INSERT INTO `t_position`(`position_id`, `position_name`, `position_level`, `sort`, `remark`, `deleted_flag`, `create_time`, `update_time`) VALUES (4, '技术P8', 'L2', 1, NULL, 0, '2024-07-15 23:34:14', '2024-07-15 23:34:23');
INSERT INTO `t_position`(`position_id`, `position_name`, `position_level`, `sort`, `remark`, `deleted_flag`, `create_time`, `update_time`) VALUES (5, '管理M5', 'L1', 4, NULL, 0, '2024-07-15 23:34:48', '2024-07-15 23:34:48');
INSERT INTO `t_position`(`position_id`, `position_name`, `position_level`, `sort`, `remark`, `deleted_flag`, `create_time`, `update_time`) VALUES (6, '管理M6', 'L2', 5, NULL, 0, '2024-07-15 23:35:00', '2024-07-15 23:35:00');

-- ----------------------------
-- Table structure for t_reload_item
-- ----------------------------
DROP TABLE IF EXISTS `t_reload_item`;
CREATE TABLE `t_reload_item`  (
  `tag` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '项名称',
  `args` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '参数 可选',
  `identification` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '运行标识',
  `update_time` datetime(0) NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP(0),
  `create_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`tag`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = 'reload项目' ROW_FORMAT = Dynamic;

INSERT INTO `t_reload_item` VALUES ('system_config', '4', '234', '2024-08-13 14:14:30', '2019-04-18 11:48:27');

-- ----------------------------
-- Table structure for t_reload_result
-- ----------------------------
DROP TABLE IF EXISTS `t_reload_result`;
CREATE TABLE `t_reload_result`  (
  `tag` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `identification` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '运行标识',
  `args` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `result` tinyint unsigned NOT NULL COMMENT '是否成功 ',
  `exception` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL,
  `create_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = 'reload结果' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for t_role
-- ----------------------------
DROP TABLE IF EXISTS `t_role`;
CREATE TABLE `t_role`  (
  `role_id` bigint(0) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `role_name` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '角色名称',
  `role_code` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '角色编码',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '角色描述',
  `update_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  `create_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`role_id`) USING BTREE,
  UNIQUE INDEX `role_code_uni`(`role_code`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 59 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '角色表' ROW_FORMAT = Dynamic;

INSERT INTO `t_role` VALUES (1, '超级管理员', NULL, '拥有所有权限', '2022-10-19 20:24:09', '2019-06-21 12:09:34');
INSERT INTO `t_role` VALUES (34, '销售总监', 'cto', '', '2023-09-06 19:10:34', '2019-08-30 09:30:50');
INSERT INTO `t_role` VALUES (35, '总经理', NULL, '', '2019-08-30 09:31:05', '2019-08-30 09:31:05');

-- ----------------------------
-- Table structure for t_role_data_scope
-- ----------------------------
DROP TABLE IF EXISTS `t_role_data_scope`;
CREATE TABLE `t_role_data_scope`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT,
  `data_scope_type` int(0) NOT NULL COMMENT '数据范围类型',
  `view_type` int(0) NOT NULL COMMENT '数据可见范围类型',
  `role_id` bigint(0) NOT NULL COMMENT '角色id',
  `update_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '更新时间',
  `create_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 69 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '角色的数据范围' ROW_FORMAT = Dynamic;

INSERT INTO `t_role_data_scope` VALUES (67, 1, 2, 1, '2024-03-18 20:41:00', '2024-03-18 20:41:00');

-- ----------------------------
-- Table structure for t_role_employee
-- ----------------------------
DROP TABLE IF EXISTS `t_role_employee`;
CREATE TABLE `t_role_employee`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT,
  `role_id` bigint(0) NOT NULL COMMENT '角色id',
  `employee_id` bigint(0) NOT NULL COMMENT '员工id',
  `update_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '更新时间',
  `create_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_role_employee`(`role_id`, `employee_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 342 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '角色员工功能表' ROW_FORMAT = Dynamic;

INSERT INTO `t_role_employee` VALUES (333, 1, 44, '2023-10-07 18:53:29', '2023-10-07 18:53:29');
INSERT INTO `t_role_employee` VALUES (334, 1, 47, '2023-10-07 18:55:00', '2023-10-07 18:55:00');
INSERT INTO `t_role_employee` VALUES (341, 1, 48, '2024-09-02 23:03:28', '2024-09-02 23:03:28');

-- ----------------------------
-- Table structure for t_role_menu
-- ----------------------------
DROP TABLE IF EXISTS `t_role_menu`;
CREATE TABLE `t_role_menu`  (
  `role_menu_id` bigint(0) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `role_id` bigint(0) NOT NULL COMMENT '角色id',
  `menu_id` bigint(0) NOT NULL COMMENT '菜单id',
  `update_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '更新时间',
  `create_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`role_menu_id`) USING BTREE,
  INDEX `idx_role_id`(`role_id`) USING BTREE,
  INDEX `idx_menu_id`(`menu_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 820 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '角色-菜单' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for t_serial_number
-- ----------------------------
DROP TABLE IF EXISTS `t_serial_number`;
CREATE TABLE `t_serial_number`  (
  `serial_number_id` int(0) NOT NULL,
  `business_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '业务名称',
  `format` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '格式',
  `rule_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '规则格式',
  `init_number` int unsigned NOT NULL COMMENT '初始值',
  `step_random_range` int unsigned NOT NULL COMMENT '步长随机数',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  `last_number` bigint(0) NULL DEFAULT NULL COMMENT '上次产生的单号',
  `last_time` datetime(0) NULL DEFAULT NULL COMMENT '上次产生的单号时间',
  `update_time` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0),
  `create_time` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`serial_number_id`) USING BTREE,
  UNIQUE INDEX `key_name`(`business_name`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '单号生成器定义表' ROW_FORMAT = Dynamic;

INSERT INTO `t_serial_number` VALUES (1, '订单编号', 'DK[yyyy][mm][dd]NO[nnnnn]', 'day', 1000, 10, NULL, 1, '2023-12-04 09:16:42', '2024-01-08 19:24:46', '2021-02-19 14:37:50');

-- ----------------------------
-- Table structure for t_serial_number_record
-- ----------------------------
DROP TABLE IF EXISTS `t_serial_number_record`;
CREATE TABLE `t_serial_number_record`  (
  `serial_number_id` int(0) NOT NULL,
  `record_date` date NOT NULL COMMENT '记录日期',
  `last_number` bigint(0) NOT NULL DEFAULT 0 COMMENT '最后更新值',
  `last_time` datetime(0) NOT NULL COMMENT '最后更新时间',
  `count` bigint(0) NOT NULL DEFAULT 0 COMMENT '更新次数',
  `update_time` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0),
  `create_time` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP,
  INDEX `uk_generator`(`serial_number_id`, `record_date`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = 'serial_number记录表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for t_smart_job
-- ----------------------------
DROP TABLE IF EXISTS `t_smart_job`;
CREATE TABLE `t_smart_job`  (
  `job_id` int(0) NOT NULL AUTO_INCREMENT COMMENT '任务id',
  `job_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '任务名称',
  `job_class` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '任务执行类',
  `trigger_type` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '触发类型',
  `trigger_value` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '触发配置',
  `enabled_flag` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否开启',
  `param` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '参数',
  `last_execute_time` datetime(0) NULL DEFAULT NULL COMMENT '最后一次执行时间',
  `last_execute_log_id` int(0) NULL DEFAULT NULL COMMENT '最后一次执行记录id',
  `sort` int(0) NOT NULL DEFAULT 0 COMMENT '排序',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '描述',
  `deleted_flag` tinyint(1) NOT NULL DEFAULT 0 COMMENT '删除状态',
  `update_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '更新人',
  `create_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0),
  PRIMARY KEY (`job_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '定时任务配置' ROW_FORMAT = Dynamic;

INSERT INTO `t_smart_job` VALUES (1, '示例任务1', 'net.lab1024.sa.base.module.support.job.sample.SmartJobSample1', 'cron', '10 15 0/1 * * *', 1, '执行示例任务1', NULL, NULL, 1, '执行示例任务1', 0, '管理员', '2024-06-17 20:00:46', '2024-06-17 20:00:46');
INSERT INTO `t_smart_job` VALUES (2, '示例任务2', 'net.lab1024.sa.base.module.support.job.sample.SmartJobSample2', 'fixed_delay', '120', 1, '执行示例任务2', NULL, NULL, 2, '执行示例任务2', 0, '管理员', '2024-06-18 20:45:35', '2024-06-18 20:45:35');

-- ----------------------------
-- Table structure for t_smart_job_log
-- ----------------------------
DROP TABLE IF EXISTS `t_smart_job_log`;
CREATE TABLE `t_smart_job_log`  (
  `log_id` int(0) NOT NULL AUTO_INCREMENT,
  `job_id` int(0) NOT NULL COMMENT '任务id',
  `job_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '任务名称',
  `param` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '执行参数',
  `success_flag` tinyint(1) NOT NULL COMMENT '是否成功',
  `execute_start_time` datetime(0) NOT NULL COMMENT '执行开始时间',
  `execute_time_millis` int(0) NULL DEFAULT NULL COMMENT '执行时长',
  `execute_end_time` datetime(0) NULL DEFAULT NULL COMMENT '执行结束时间',
  `execute_result` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `ip` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'ip',
  `process_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '进程id',
  `program_path` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '程序目录',
  `create_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '创建人',
  `create_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`log_id`) USING BTREE,
  INDEX `idx_job_id`(`job_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '定时任务-执行记录' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for t_table_column
-- ----------------------------
DROP TABLE IF EXISTS `t_table_column`;
CREATE TABLE `t_table_column`  (
  `table_column_id` bigint(0) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(0) NOT NULL COMMENT '用户id',
  `user_type` int(0) NOT NULL COMMENT '用户类型',
  `table_id` int(0) NOT NULL COMMENT '表格id',
  `columns` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '具体的表格列，存入的json',
  `create_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0),
  PRIMARY KEY (`table_column_id`) USING BTREE,
  UNIQUE INDEX `uni_employee_table`(`user_id`, `table_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '表格的自定义列存储' ROW_FORMAT = Dynamic;

SET FOREIGN_KEY_CHECKS = 1;

-- =====================================================
-- 业务表（服装裁剪管理系统）
-- =====================================================
SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS `t_production_process`;
DROP TABLE IF EXISTS `t_production_order_fabric`;
DROP TABLE IF EXISTS `t_production_order_detail`;
DROP TABLE IF EXISTS `t_cutting_order`;
DROP TABLE IF EXISTS `t_cutting_plan`;
DROP TABLE IF EXISTS `t_fabric_spread`;
DROP TABLE IF EXISTS `t_fabric_relax`;
DROP TABLE IF EXISTS `t_production_order`;
DROP TABLE IF EXISTS `t_garment_sku`;
DROP TABLE IF EXISTS `t_garment`;
DROP TABLE IF EXISTS `t_fabric_sku`;
DROP TABLE IF EXISTS `t_fabric`;
DROP TABLE IF EXISTS `t_cutting_part`;
DROP TABLE IF EXISTS `t_unit`;
DROP TABLE IF EXISTS `t_size_group`;
DROP TABLE IF EXISTS `t_size`;
DROP TABLE IF EXISTS `t_color_group`;
DROP TABLE IF EXISTS `t_style_color`;
DROP TABLE IF EXISTS `t_customer`;

-- 1. 客户管理表
CREATE TABLE `t_customer` (
  `customer_id`    bigint       NOT NULL AUTO_INCREMENT COMMENT '客户ID',
  `customer_code`  varchar(50)  NOT NULL COMMENT '客户编号',
  `customer_name`  varchar(100) NOT NULL COMMENT '客户名称',
  `company_name`   varchar(200) DEFAULT NULL COMMENT '公司名称',
  `contact_person` varchar(50)  DEFAULT NULL COMMENT '联系人',
  `phone`          varchar(30)  DEFAULT NULL COMMENT '电话',
  `level`          varchar(20)  DEFAULT NULL COMMENT '等级(A/B/C)',
  `disabled_flag`  tinyint      NOT NULL DEFAULT 0 COMMENT '停用标识:0-启用,1-停用',
  `deleted_flag`   tinyint      NOT NULL DEFAULT 0 COMMENT '删除标识:0-正常,1-已删除',
  `remark`         varchar(500) DEFAULT NULL COMMENT '备注',
  `create_time`    datetime     NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time`    datetime     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`customer_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COMMENT='客户管理';

INSERT INTO `t_customer` VALUES (1,'KH001','元一','元一服装有限公司','张经理','13800138001','A',0,0,'VIP客户，长期合作','2024-01-01 09:00:00','2024-01-01 09:00:00');
INSERT INTO `t_customer` VALUES (2,'KH002','美诺','美诺贸易公司','李总','13900139002','B',0,0,'稳定合作客户','2024-01-01 09:00:00','2024-01-01 09:00:00');
INSERT INTO `t_customer` VALUES (3,'KH003','鑫达','鑫达纺织集团','王主任','13700137003','A',0,0,'长期合作，优先供货','2024-01-01 09:00:00','2024-01-01 09:00:00');
INSERT INTO `t_customer` VALUES (4,'KH004','恒通','恒通服饰有限公司','陈总监','13600136004','C',0,0,'新客户','2024-03-01 09:00:00','2024-03-01 09:00:00');
INSERT INTO `t_customer` VALUES (5,'KH005','锦华','锦华时装集团','赵经理','13500135005','B',1,0,'已停用','2024-02-01 09:00:00','2024-06-01 09:00:00');

-- 2. 款式颜色表
CREATE TABLE `t_style_color` (
  `color_id`         bigint       NOT NULL AUTO_INCREMENT COMMENT '颜色ID',
  `style_no`         varchar(50)  DEFAULT NULL COMMENT '款号',
  `color_group_id`   bigint       DEFAULT NULL COMMENT '颜色组ID',
  `color_name`       varchar(50)  NOT NULL COMMENT '款式颜色名称',
  `color_code`       varchar(20)  DEFAULT NULL COMMENT '颜色编码',
  `deleted_flag`     tinyint      NOT NULL DEFAULT 0 COMMENT '删除标识:0-正常,1-已删除',
  `remark`           varchar(255) DEFAULT NULL COMMENT '备注',
  `create_user_id`   bigint       DEFAULT NULL COMMENT '创建人ID',
  `create_user_name` varchar(50)  DEFAULT NULL COMMENT '创建人姓名',
  `create_time`      datetime     NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time`      datetime     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`color_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COMMENT='款式颜色';

INSERT INTO `t_style_color` VALUES (1,'YY001',1,'米白','MW001',0,NULL,1,'管理员','2024-01-01 09:00:00','2024-01-01 09:00:00');
INSERT INTO `t_style_color` VALUES (2,'YY001',2,'黑色','HE001',0,NULL,1,'管理员','2024-01-01 09:00:00','2024-01-01 09:00:00');
INSERT INTO `t_style_color` VALUES (3,'YY002',3,'藏蓝','ZL001',0,NULL,1,'管理员','2024-01-01 09:00:00','2024-01-01 09:00:00');
INSERT INTO `t_style_color` VALUES (4,'YY002',4,'卡其','KQ001',0,NULL,1,'管理员','2024-01-01 09:00:00','2024-01-01 09:00:00');
INSERT INTO `t_style_color` VALUES (5,'YY003',5,'红色','HS001',0,NULL,1,'管理员','2024-01-01 09:00:00','2024-01-01 09:00:00');
INSERT INTO `t_style_color` VALUES (6,'YY003',6,'深灰','SH001',0,NULL,1,'管理员','2024-02-01 09:00:00','2024-02-01 09:00:00');
INSERT INTO `t_style_color` VALUES (7,'YY004',7,'天蓝','TL001',0,NULL,1,'管理员','2024-03-01 09:00:00','2024-03-01 09:00:00');

-- 2.1 颜色组表
CREATE TABLE `t_color_group` (
  `group_id`      bigint       NOT NULL AUTO_INCREMENT COMMENT '颜色组ID',
  `group_name`    varchar(50)  NOT NULL COMMENT '颜色组名称',
  `deleted_flag`  tinyint      NOT NULL DEFAULT 0 COMMENT '删除标识:0-正常,1-已删除',
  `remark`        varchar(255) DEFAULT NULL COMMENT '备注',
  `create_time`   datetime     NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time`   datetime     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`group_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COMMENT='颜色组';

INSERT INTO `t_color_group` VALUES (1,'白色组',0,NULL,'2025-08-14 15:57:21','2025-08-14 15:57:21');
INSERT INTO `t_color_group` VALUES (2,'黄色组',0,NULL,'2025-08-14 17:24:49','2025-08-14 17:24:49');
INSERT INTO `t_color_group` VALUES (3,'紫色组',0,NULL,'2025-08-16 15:32:58','2025-08-16 15:32:58');
INSERT INTO `t_color_group` VALUES (4,'蓝色组',0,NULL,'2025-08-16 15:33:21','2025-08-16 15:33:21');
INSERT INTO `t_color_group` VALUES (5,'红色组',0,NULL,'2025-08-16 15:33:40','2025-08-16 15:33:40');
INSERT INTO `t_color_group` VALUES (6,'灰色组',0,NULL,'2025-08-16 15:34:02','2025-08-16 15:34:02');
INSERT INTO `t_color_group` VALUES (7,'青色组',0,NULL,'2025-08-16 15:34:18','2025-08-16 15:34:18');

-- 3. 尺寸列表表
CREATE TABLE `t_size` (
  `size_id`      bigint       NOT NULL AUTO_INCREMENT COMMENT '尺码ID',
  `size_group_id` bigint       DEFAULT NULL COMMENT '尺码组ID',
  `size_name`    varchar(20)  NOT NULL COMMENT '尺码名称',
  `sort`         int          NOT NULL DEFAULT 0 COMMENT '排序（升序）',
  `deleted_flag` tinyint      NOT NULL DEFAULT 0 COMMENT '删除标识:0-正常,1-已删除',
  `remark`       varchar(255) DEFAULT NULL COMMENT '备注',
  `create_time`  datetime     NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time`  datetime     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`size_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COMMENT='尺寸列表';

INSERT INTO `t_size` VALUES (1,1,'XS',1,0,'超小号','2024-01-01 09:00:00','2024-01-01 09:00:00');
INSERT INTO `t_size` VALUES (2,1,'S',2,0,'小号','2024-01-01 09:00:00','2024-01-01 09:00:00');
INSERT INTO `t_size` VALUES (3,1,'M',3,0,'中号','2024-01-01 09:00:00','2024-01-01 09:00:00');
INSERT INTO `t_size` VALUES (4,2,'L',4,0,'大号','2024-01-01 09:00:00','2024-01-01 09:00:00');
INSERT INTO `t_size` VALUES (5,2,'XL',5,0,'加大号','2024-01-01 09:00:00','2024-01-01 09:00:00');
INSERT INTO `t_size` VALUES (6,3,'2XL',6,0,'超大号','2024-01-01 09:00:00','2024-01-01 09:00:00');
INSERT INTO `t_size` VALUES (7,3,'3XL',7,0,'特大号','2024-01-01 09:00:00','2024-01-01 09:00:00');

-- 3.1 尺码组表
CREATE TABLE `t_size_group` (
  `group_id`      bigint       NOT NULL AUTO_INCREMENT COMMENT '尺码组ID',
  `group_name`    varchar(50)  NOT NULL COMMENT '尺码组名称',
  `deleted_flag`  tinyint      NOT NULL DEFAULT 0 COMMENT '删除标识:0-正常,1-已删除',
  `remark`        varchar(255) DEFAULT NULL COMMENT '备注',
  `create_time`   datetime     NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time`   datetime     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`group_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COMMENT='尺码组';

INSERT INTO `t_size_group` VALUES (1,'常规组',0,NULL,'2025-08-14 15:57:21','2025-08-14 15:57:21');
INSERT INTO `t_size_group` VALUES (2,'大码组',0,NULL,'2025-08-14 17:24:49','2025-08-14 17:24:49');
INSERT INTO `t_size_group` VALUES (3,'加大组',0,NULL,'2025-08-16 15:32:58','2025-08-16 15:32:58');

-- 4. 单位管理表
CREATE TABLE `t_unit` (
  `unit_id`          bigint       NOT NULL AUTO_INCREMENT COMMENT '单位ID',
  `unit_name`        varchar(50)  NOT NULL COMMENT '单位名称',
  `unit_code`        varchar(30)  NOT NULL COMMENT '单位编码（系统生成）',
  `deleted_flag`     tinyint      NOT NULL DEFAULT 0 COMMENT '删除标识:0-正常,1-已删除',
  `remark`           varchar(255) DEFAULT NULL COMMENT '备注',
  `create_user_id`   bigint       DEFAULT NULL COMMENT '创建人ID',
  `create_user_name` varchar(50)  DEFAULT NULL COMMENT '创建人姓名',
  `update_user_id`   bigint       DEFAULT NULL COMMENT '更新人ID',
  `update_user_name` varchar(50)  DEFAULT NULL COMMENT '更新人姓名',
  `create_time`      datetime     NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time`      datetime     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`unit_id`),
  UNIQUE KEY `uk_unit_code` (`unit_code`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COMMENT='单位管理';

INSERT INTO `t_unit` VALUES (1,'米','DW000001',0,'布料长度单位',1,'管理员',1,'管理员','2024-01-01 09:00:00','2024-01-01 09:00:00');
INSERT INTO `t_unit` VALUES (2,'千克','DW000002',0,'重量单位',1,'管理员',1,'管理员','2024-01-01 09:00:00','2024-01-01 09:00:00');
INSERT INTO `t_unit` VALUES (3,'件','DW000003',0,'成衣计件单位',1,'管理员',1,'管理员','2024-01-01 09:00:00','2024-01-01 09:00:00');
INSERT INTO `t_unit` VALUES (4,'卷','DW000004',0,'面料卷装单位',1,'管理员',1,'管理员','2024-01-01 09:00:00','2024-01-01 09:00:00');
INSERT INTO `t_unit` VALUES (5,'条','DW000005',0,'裤装计件单位',1,'管理员',1,'管理员','2024-01-01 09:00:00','2024-01-01 09:00:00');
INSERT INTO `t_unit` VALUES (6,'套','DW000006',0,'套装计件单位',1,'管理员',1,'管理员','2024-01-01 09:00:00','2024-01-01 09:00:00');

-- 5. 裁片部位表
CREATE TABLE `t_cutting_part` (
  `part_id`      bigint       NOT NULL AUTO_INCREMENT COMMENT '部位ID',
  `part_name`    varchar(100) NOT NULL COMMENT '部位名称',
  `part_code`    varchar(50)  DEFAULT NULL COMMENT '部位编码',
  `deleted_flag` tinyint      NOT NULL DEFAULT 0 COMMENT '删除标识:0-正常,1-已删除',
  `remark`       varchar(255) DEFAULT NULL COMMENT '备注',
  `create_time`  datetime     NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time`  datetime     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`part_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COMMENT='裁片部位';

INSERT INTO `t_cutting_part` VALUES (1,'前片','QP',0,'服装前身部位','2024-01-01 09:00:00','2024-01-01 09:00:00');
INSERT INTO `t_cutting_part` VALUES (2,'后片','HP',0,'服装后身部位','2024-01-01 09:00:00','2024-01-01 09:00:00');
INSERT INTO `t_cutting_part` VALUES (3,'袖片','XP',0,'袖子部位','2024-01-01 09:00:00','2024-01-01 09:00:00');
INSERT INTO `t_cutting_part` VALUES (4,'领片','LP',0,'领子部位','2024-01-01 09:00:00','2024-01-01 09:00:00');
INSERT INTO `t_cutting_part` VALUES (5,'腰头','YT',0,'腰部部位','2024-01-01 09:00:00','2024-01-01 09:00:00');
INSERT INTO `t_cutting_part` VALUES (6,'口袋','KD',0,'口袋部位','2024-01-01 09:00:00','2024-01-01 09:00:00');
INSERT INTO `t_cutting_part` VALUES (7,'裤腿','KT',0,'裤腿部位','2024-01-01 09:00:00','2024-01-01 09:00:00');
INSERT INTO `t_cutting_part` VALUES (8,'门襟','MJ',0,'门襟部位','2024-01-01 09:00:00','2024-01-01 09:00:00');

-- 6. 面料表
CREATE TABLE `t_fabric` (
  `fabric_id`     bigint        NOT NULL AUTO_INCREMENT COMMENT '面料ID',
  `fabric_name`   varchar(200)  NOT NULL COMMENT '面料名称',
  `fabric_no`     varchar(50)   DEFAULT NULL COMMENT '面料编号',
  `fabric_type`   varchar(50)   DEFAULT NULL COMMENT '面料类型（梭织/针织等）',
  `spec`          varchar(100)  DEFAULT NULL COMMENT '规格型号',
  `unit_id`       bigint        DEFAULT NULL COMMENT '单位ID',
  `unit_name`     varchar(50)   DEFAULT NULL COMMENT '单位名称（冗余）',
  `gram_weight`   decimal(10,2) DEFAULT NULL COMMENT '克重(g/㎡)',
  `width`         decimal(10,2) DEFAULT NULL COMMENT '幅宽(cm)',
  `disabled_flag` tinyint       NOT NULL DEFAULT 0 COMMENT '停用标识:0-启用,1-停用',
  `deleted_flag`  tinyint       NOT NULL DEFAULT 0 COMMENT '删除标识:0-正常,1-已删除',
  `remark`        varchar(500)  DEFAULT NULL COMMENT '备注',
  `create_time`   datetime      NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time`   datetime      NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`fabric_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COMMENT='面料列表';

INSERT INTO `t_fabric` VALUES (1,'棉1X1罗纹食毛','ML152101','针织','200g/㎡ 150cm',1,'米',200.00,150.00,0,0,'主面料，适合T恤','2024-01-01 09:00:00','2024-01-01 09:00:00');
INSERT INTO `t_fabric` VALUES (2,'纯棉平纹布','ML152102','梭织','180g/㎡ 140cm',1,'米',180.00,140.00,0,0,'适合衬衫','2024-01-01 09:00:00','2024-01-01 09:00:00');
INSERT INTO `t_fabric` VALUES (3,'涤纶斜纹布','ML152103','梭织','220g/㎡ 145cm',1,'米',220.00,145.00,0,0,'适合外套','2024-01-01 09:00:00','2024-01-01 09:00:00');
INSERT INTO `t_fabric` VALUES (4,'氨纶弹力布','ML152104','针织','260g/㎡ 155cm',1,'米',260.00,155.00,0,0,'弹力面料，适合运动服','2024-02-01 09:00:00','2024-02-01 09:00:00');
INSERT INTO `t_fabric` VALUES (5,'麻棉混纺布','ML152105','梭织','190g/㎡ 148cm',1,'米',190.00,148.00,1,0,'已停用面料','2024-02-01 09:00:00','2024-06-01 09:00:00');

-- 7. 面料SKU表
CREATE TABLE `t_fabric_sku` (
  `sku_id`       bigint        NOT NULL AUTO_INCREMENT COMMENT 'SKU ID',
  `fabric_id`    bigint        NOT NULL COMMENT '面料ID',
  `color_name`   varchar(50)   DEFAULT NULL COMMENT '颜色名称',
  `color_code`   varchar(20)   DEFAULT NULL COMMENT '颜色编码',
  `sku_no`       varchar(50)   DEFAULT NULL COMMENT 'SKU编号',
  `price`        decimal(10,2) DEFAULT NULL COMMENT '价格（元/米）',
  `image_url`    varchar(500)  DEFAULT NULL COMMENT '图片地址',
  `deleted_flag` tinyint       NOT NULL DEFAULT 0 COMMENT '删除标识:0-正常,1-已删除',
  `create_time`  datetime      NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time`  datetime      NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`sku_id`),
  KEY `idx_fabric_id` (`fabric_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COMMENT='面料SKU（颜色属性）';

INSERT INTO `t_fabric_sku` VALUES (1,1,'米白','MW001','ML152101-MW001',25.00,NULL,0,'2024-01-01 09:00:00','2024-01-01 09:00:00');
INSERT INTO `t_fabric_sku` VALUES (2,1,'黑色','HE001','ML152101-HE001',25.00,NULL,0,'2024-01-01 09:00:00','2024-01-01 09:00:00');
INSERT INTO `t_fabric_sku` VALUES (3,2,'藏蓝','ZL001','ML152102-ZL001',22.00,NULL,0,'2024-01-01 09:00:00','2024-01-01 09:00:00');
INSERT INTO `t_fabric_sku` VALUES (4,2,'卡其','KQ001','ML152102-KQ001',22.00,NULL,0,'2024-01-01 09:00:00','2024-01-01 09:00:00');
INSERT INTO `t_fabric_sku` VALUES (5,3,'深灰','SH001','ML152103-SH001',30.00,NULL,0,'2024-01-01 09:00:00','2024-01-01 09:00:00');
INSERT INTO `t_fabric_sku` VALUES (6,3,'黑色','HE001','ML152103-HE001',30.00,NULL,0,'2024-01-01 09:00:00','2024-01-01 09:00:00');
INSERT INTO `t_fabric_sku` VALUES (7,4,'天蓝','TL001','ML152104-TL001',35.00,NULL,0,'2024-02-01 09:00:00','2024-02-01 09:00:00');
INSERT INTO `t_fabric_sku` VALUES (8,4,'红色','HS001','ML152104-HS001',35.00,NULL,0,'2024-02-01 09:00:00','2024-02-01 09:00:00');

-- 8. 成衣表
CREATE TABLE `t_garment` (
  `garment_id`    bigint        NOT NULL AUTO_INCREMENT COMMENT '成衣ID',
  `garment_name`  varchar(200)  NOT NULL COMMENT '物料名称',
  `garment_no`    varchar(50)   DEFAULT NULL COMMENT '物料编号',
  `garment_type`  varchar(50)   DEFAULT NULL COMMENT '成衣类型（上衣/裤子/裙子等）',
  `spec`          varchar(100)  DEFAULT NULL COMMENT '规格型号',
  `unit_id`       bigint        DEFAULT NULL COMMENT '单位ID',
  `unit_name`     varchar(50)   DEFAULT NULL COMMENT '单位名称（冗余）',
  `price`         decimal(10,2) DEFAULT NULL COMMENT '出厂价格',
  `disabled_flag` tinyint       NOT NULL DEFAULT 0 COMMENT '停用标识:0-启用,1-停用',
  `deleted_flag`  tinyint       NOT NULL DEFAULT 0 COMMENT '删除标识:0-正常,1-已删除',
  `remark`        varchar(500)  DEFAULT NULL COMMENT '备注',
  `create_time`   datetime      NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time`   datetime      NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`garment_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COMMENT='成衣列表';

INSERT INTO `t_garment` VALUES (1,'棉质圆领T恤','CY001','上衣','S/M/L/XL/2XL',3,'件',89.00,0,0,'经典款基础T恤','2024-01-01 09:00:00','2024-01-01 09:00:00');
INSERT INTO `t_garment` VALUES (2,'男款修身衬衫','CY002','上衣','S/M/L/XL',3,'件',129.00,0,0,'商务休闲衬衫','2024-01-01 09:00:00','2024-01-01 09:00:00');
INSERT INTO `t_garment` VALUES (3,'休闲直筒裤','CY003','裤子','S/M/L/XL/2XL',5,'条',159.00,0,0,'四季通用款','2024-01-01 09:00:00','2024-01-01 09:00:00');
INSERT INTO `t_garment` VALUES (4,'运动卫衣','CY004','上衣','S/M/L/XL/2XL/3XL',3,'件',199.00,0,0,'连帽运动款','2024-02-01 09:00:00','2024-02-01 09:00:00');
INSERT INTO `t_garment` VALUES (5,'商务西装外套','CY005','外套','S/M/L/XL',3,'件',599.00,1,0,'已停用款式','2024-02-01 09:00:00','2024-06-01 09:00:00');

-- 9. 成衣SKU表
CREATE TABLE `t_garment_sku` (
  `sku_id`       bigint        NOT NULL AUTO_INCREMENT COMMENT 'SKU ID',
  `garment_id`   bigint        NOT NULL COMMENT '成衣ID',
  `color_name`   varchar(50)   DEFAULT NULL COMMENT '颜色名称',
  `color_code`   varchar(20)   DEFAULT NULL COMMENT '颜色编码',
  `size_name`    varchar(20)   DEFAULT NULL COMMENT '尺码名称',
  `sku_no`       varchar(50)   DEFAULT NULL COMMENT 'SKU编号',
  `price`        decimal(10,2) DEFAULT NULL COMMENT '价格',
  `deleted_flag` tinyint       NOT NULL DEFAULT 0 COMMENT '删除标识:0-正常,1-已删除',
  `create_time`  datetime      NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time`  datetime      NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`sku_id`),
  KEY `idx_garment_id` (`garment_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COMMENT='成衣SKU（颜色+尺码）';

INSERT INTO `t_garment_sku` VALUES (1,1,'米白','MW001','S','CY001-MW001-S',89.00,0,'2024-01-01 09:00:00','2024-01-01 09:00:00');
INSERT INTO `t_garment_sku` VALUES (2,1,'米白','MW001','M','CY001-MW001-M',89.00,0,'2024-01-01 09:00:00','2024-01-01 09:00:00');
INSERT INTO `t_garment_sku` VALUES (3,1,'米白','MW001','L','CY001-MW001-L',89.00,0,'2024-01-01 09:00:00','2024-01-01 09:00:00');
INSERT INTO `t_garment_sku` VALUES (4,1,'米白','MW001','XL','CY001-MW001-XL',89.00,0,'2024-01-01 09:00:00','2024-01-01 09:00:00');
INSERT INTO `t_garment_sku` VALUES (5,1,'黑色','HE001','S','CY001-HE001-S',89.00,0,'2024-01-01 09:00:00','2024-01-01 09:00:00');
INSERT INTO `t_garment_sku` VALUES (6,1,'黑色','HE001','M','CY001-HE001-M',89.00,0,'2024-01-01 09:00:00','2024-01-01 09:00:00');
INSERT INTO `t_garment_sku` VALUES (7,1,'黑色','HE001','L','CY001-HE001-L',89.00,0,'2024-01-01 09:00:00','2024-01-01 09:00:00');
INSERT INTO `t_garment_sku` VALUES (8,1,'黑色','HE001','XL','CY001-HE001-XL',89.00,0,'2024-01-01 09:00:00','2024-01-01 09:00:00');
INSERT INTO `t_garment_sku` VALUES (9,2,'藏蓝','ZL001','M','CY002-ZL001-M',129.00,0,'2024-01-01 09:00:00','2024-01-01 09:00:00');
INSERT INTO `t_garment_sku` VALUES (10,2,'藏蓝','ZL001','L','CY002-ZL001-L',129.00,0,'2024-01-01 09:00:00','2024-01-01 09:00:00');
INSERT INTO `t_garment_sku` VALUES (11,2,'藏蓝','ZL001','XL','CY002-ZL001-XL',129.00,0,'2024-01-01 09:00:00','2024-01-01 09:00:00');
INSERT INTO `t_garment_sku` VALUES (12,3,'卡其','KQ001','M','CY003-KQ001-M',159.00,0,'2024-01-01 09:00:00','2024-01-01 09:00:00');
INSERT INTO `t_garment_sku` VALUES (13,3,'卡其','KQ001','L','CY003-KQ001-L',159.00,0,'2024-01-01 09:00:00','2024-01-01 09:00:00');
INSERT INTO `t_garment_sku` VALUES (14,3,'卡其','KQ001','XL','CY003-KQ001-XL',159.00,0,'2024-01-01 09:00:00','2024-01-01 09:00:00');

-- 10. 生产指令单（制单）表
CREATE TABLE `t_production_order` (
  `order_id`         bigint        NOT NULL AUTO_INCREMENT COMMENT '指令单ID',
  `order_no`         varchar(30)   NOT NULL COMMENT '单据编号（如SC202601210002）',
  `customer_id`      bigint        DEFAULT NULL COMMENT '客户ID',
  `customer_name`    varchar(100)  DEFAULT NULL COMMENT '客户名称（冗余）',
  `style_no`         varchar(50)   DEFAULT NULL COMMENT '款号',
  `style_name`       varchar(100)  DEFAULT NULL COMMENT '款名',
  `delivery_date`    date          DEFAULT NULL COMMENT '交货日期',
  `unit_price`       decimal(10,2) DEFAULT NULL COMMENT '单价',
  `order_quantity`   int           DEFAULT 0 COMMENT '下单数量',
  `finish_quantity`  int           DEFAULT 0 COMMENT '完成数量',
  `status`           tinyint       NOT NULL DEFAULT 1 COMMENT '生产状态:1-计划,2-下达,3-完工',
  `issue_date`       datetime      DEFAULT NULL COMMENT '下达日期',
  `deleted_flag`     tinyint       NOT NULL DEFAULT 0 COMMENT '删除标识:0-正常,1-已删除',
  `remark`           varchar(500)  DEFAULT NULL COMMENT '备注',
  `create_user_id`   bigint        DEFAULT NULL COMMENT '创建人ID',
  `create_user_name` varchar(50)   DEFAULT NULL COMMENT '创建人姓名',
  `create_time`      datetime      NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time`      datetime      NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`order_id`),
  UNIQUE KEY `uk_order_no` (`order_no`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COMMENT='生产指令单';

INSERT INTO `t_production_order` VALUES (1,'SC202601210001',1,'元一','YY001','棉质圆领T恤','2026-03-01',89.00,500,500,3,'2026-01-21 08:00:00',0,'已完工',1,'管理员','2026-01-21 08:00:00','2026-03-01 18:00:00');
INSERT INTO `t_production_order` VALUES (2,'SC202601210002',2,'美诺','YY002','男款修身衬衫','2026-04-15',129.00,300,0,2,'2026-01-21 09:00:00',0,'生产中',1,'管理员','2026-01-21 09:00:00','2026-01-21 09:00:00');
INSERT INTO `t_production_order` VALUES (3,'SC202602150001',3,'鑫达','YY003','休闲直筒裤','2026-05-01',159.00,400,0,2,'2026-02-15 10:00:00',0,'生产中',1,'管理员','2026-02-15 10:00:00','2026-02-15 10:00:00');
INSERT INTO `t_production_order` VALUES (4,'SC202603010001',1,'元一','YY004','运动卫衣','2026-06-30',199.00,200,0,1,NULL,0,'计划阶段',1,'管理员','2026-03-01 09:00:00','2026-03-01 09:00:00');
INSERT INTO `t_production_order` VALUES (5,'SC202603200001',4,'恒通','YY001','棉质圆领T恤','2026-07-15',89.00,1000,0,1,NULL,0,'大批量订单',1,'管理员','2026-03-20 09:00:00','2026-03-20 09:00:00');
INSERT INTO `t_production_order` VALUES (6,'SC202604070001',2,'美诺','YY005','夏季连衣裙','2026-08-01',219.00,600,0,1,NULL,0,'新款夏季连衣裙',1,'管理员','2026-04-07 09:00:00','2026-04-07 09:00:00');
INSERT INTO `t_production_order` VALUES (7,'SC202604080001',3,'鑫达','YY006','休闲短裤','2026-08-15',99.00,800,0,2,'2026-04-08 10:00:00',0,'已下达生产',1,'管理员','2026-04-08 09:00:00','2026-04-08 10:00:00');
INSERT INTO `t_production_order` VALUES (8,'SC202604090001',1,'元一','YY007','商务西装','2026-09-01',599.00,200,200,3,'2026-04-09 09:00:00',0,'已完工',1,'管理员','2026-04-09 09:00:00','2026-04-10 18:00:00');

-- 11. 指令单颜色尺码明细表
CREATE TABLE `t_production_order_detail` (
  `detail_id`    bigint   NOT NULL AUTO_INCREMENT COMMENT '明细ID',
  `order_id`     bigint   NOT NULL COMMENT '指令单ID',
  `color_name`   varchar(50)  DEFAULT NULL COMMENT '颜色名称',
  `size_name`    varchar(20)  DEFAULT NULL COMMENT '尺码名称',
  `quantity`     int      DEFAULT 0 COMMENT '数量',
  `deleted_flag` tinyint  NOT NULL DEFAULT 0 COMMENT '删除标识:0-正常,1-已删除',
  `create_time`  datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time`  datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`detail_id`),
  KEY `idx_order_id` (`order_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COMMENT='指令单颜色尺码明细';

INSERT INTO `t_production_order_detail` VALUES (1,1,'米白','S',50,0,'2026-01-21 08:00:00','2026-01-21 08:00:00');
INSERT INTO `t_production_order_detail` VALUES (2,1,'米白','M',80,0,'2026-01-21 08:00:00','2026-01-21 08:00:00');
INSERT INTO `t_production_order_detail` VALUES (3,1,'米白','L',100,0,'2026-01-21 08:00:00','2026-01-21 08:00:00');
INSERT INTO `t_production_order_detail` VALUES (4,1,'米白','XL',70,0,'2026-01-21 08:00:00','2026-01-21 08:00:00');
INSERT INTO `t_production_order_detail` VALUES (5,1,'黑色','S',50,0,'2026-01-21 08:00:00','2026-01-21 08:00:00');
INSERT INTO `t_production_order_detail` VALUES (6,1,'黑色','M',80,0,'2026-01-21 08:00:00','2026-01-21 08:00:00');
INSERT INTO `t_production_order_detail` VALUES (7,1,'黑色','L',50,0,'2026-01-21 08:00:00','2026-01-21 08:00:00');
INSERT INTO `t_production_order_detail` VALUES (8,1,'黑色','XL',20,0,'2026-01-21 08:00:00','2026-01-21 08:00:00');
INSERT INTO `t_production_order_detail` VALUES (9,2,'藏蓝','M',80,0,'2026-01-21 09:00:00','2026-01-21 09:00:00');
INSERT INTO `t_production_order_detail` VALUES (10,2,'藏蓝','L',120,0,'2026-01-21 09:00:00','2026-01-21 09:00:00');
INSERT INTO `t_production_order_detail` VALUES (11,2,'藏蓝','XL',60,0,'2026-01-21 09:00:00','2026-01-21 09:00:00');
INSERT INTO `t_production_order_detail` VALUES (12,2,'卡其','M',20,0,'2026-01-21 09:00:00','2026-01-21 09:00:00');
INSERT INTO `t_production_order_detail` VALUES (13,2,'卡其','L',10,0,'2026-01-21 09:00:00','2026-01-21 09:00:00');
INSERT INTO `t_production_order_detail` VALUES (14,2,'卡其','XL',10,0,'2026-01-21 09:00:00','2026-01-21 09:00:00');
INSERT INTO `t_production_order_detail` VALUES (15,3,'卡其','M',100,0,'2026-02-15 10:00:00','2026-02-15 10:00:00');
INSERT INTO `t_production_order_detail` VALUES (16,3,'卡其','L',150,0,'2026-02-15 10:00:00','2026-02-15 10:00:00');
INSERT INTO `t_production_order_detail` VALUES (17,3,'卡其','XL',100,0,'2026-02-15 10:00:00','2026-02-15 10:00:00');
INSERT INTO `t_production_order_detail` VALUES (18,3,'卡其','2XL',50,0,'2026-02-15 10:00:00','2026-02-15 10:00:00');
INSERT INTO `t_production_order_detail` VALUES (19,4,'天蓝','M',50,0,'2026-03-01 09:00:00','2026-03-01 09:00:00');
INSERT INTO `t_production_order_detail` VALUES (20,4,'天蓝','L',80,0,'2026-03-01 09:00:00','2026-03-01 09:00:00');
INSERT INTO `t_production_order_detail` VALUES (21,4,'天蓝','XL',70,0,'2026-03-01 09:00:00','2026-03-01 09:00:00');
INSERT INTO `t_production_order_detail` VALUES (22,5,'米白','M',200,0,'2026-03-20 09:00:00','2026-03-20 09:00:00');
INSERT INTO `t_production_order_detail` VALUES (23,5,'米白','L',300,0,'2026-03-20 09:00:00','2026-03-20 09:00:00');
INSERT INTO `t_production_order_detail` VALUES (24,5,'米白','XL',200,0,'2026-03-20 09:00:00','2026-03-20 09:00:00');
INSERT INTO `t_production_order_detail` VALUES (25,5,'黑色','M',100,0,'2026-03-20 09:00:00','2026-03-20 09:00:00');
INSERT INTO `t_production_order_detail` VALUES (26,5,'黑色','L',100,0,'2026-03-20 09:00:00','2026-03-20 09:00:00');
INSERT INTO `t_production_order_detail` VALUES (27,5,'黑色','XL',100,0,'2026-03-20 09:00:00','2026-03-20 09:00:00');

-- 12. 指令单面料信息表
CREATE TABLE `t_production_order_fabric` (
  `id`           bigint       NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `order_id`     bigint       NOT NULL COMMENT '指令单ID',
  `fabric_id`    bigint       DEFAULT NULL COMMENT '面料ID',
  `fabric_no`    varchar(50)  DEFAULT NULL COMMENT '面料编号',
  `fabric_name`  varchar(200) DEFAULT NULL COMMENT '面料名称',
  `color_name`   varchar(50)  DEFAULT NULL COMMENT '颜色/规格',
  `deleted_flag` tinyint      NOT NULL DEFAULT 0 COMMENT '删除标识:0-正常,1-已删除',
  `create_time`  datetime     NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time`  datetime     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_order_id` (`order_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COMMENT='指令单面料信息';

INSERT INTO `t_production_order_fabric` VALUES (1,1,1,'ML152101','棉1X1罗纹食毛','米白',0,'2026-01-21 08:00:00','2026-01-21 08:00:00');
INSERT INTO `t_production_order_fabric` VALUES (2,1,1,'ML152101','棉1X1罗纹食毛','黑色',0,'2026-01-21 08:00:00','2026-01-21 08:00:00');
INSERT INTO `t_production_order_fabric` VALUES (3,2,2,'ML152102','纯棉平纹布','藏蓝',0,'2026-01-21 09:00:00','2026-01-21 09:00:00');
INSERT INTO `t_production_order_fabric` VALUES (4,2,2,'ML152102','纯棉平纹布','卡其',0,'2026-01-21 09:00:00','2026-01-21 09:00:00');
INSERT INTO `t_production_order_fabric` VALUES (5,3,2,'ML152102','纯棉平纹布','卡其',0,'2026-02-15 10:00:00','2026-02-15 10:00:00');
INSERT INTO `t_production_order_fabric` VALUES (6,4,4,'ML152104','氨纶弹力布','天蓝',0,'2026-03-01 09:00:00','2026-03-01 09:00:00');
INSERT INTO `t_production_order_fabric` VALUES (7,5,1,'ML152101','棉1X1罗纹食毛','米白',0,'2026-03-20 09:00:00','2026-03-20 09:00:00');
INSERT INTO `t_production_order_fabric` VALUES (8,5,1,'ML152101','棉1X1罗纹食毛','黑色',0,'2026-03-20 09:00:00','2026-03-20 09:00:00');

-- 13. 生产流程工序节点表
CREATE TABLE `t_production_process` (
  `process_id`        bigint       NOT NULL AUTO_INCREMENT COMMENT '工序ID',
  `order_id`          bigint       NOT NULL COMMENT '指令单ID',
  `seq_no`            int          NOT NULL COMMENT '序号',
  `node_name`         varchar(100) NOT NULL COMMENT '节点名称',
  `principal`         varchar(100) DEFAULT NULL COMMENT '负责人',
  `duration_hours`    decimal(5,1) DEFAULT NULL COMMENT '时效(小时)',
  `plan_start_time`   datetime     DEFAULT NULL COMMENT '计划开始时间',
  `plan_end_time`     datetime     DEFAULT NULL COMMENT '计划结束时间',
  `actual_start_time` datetime     DEFAULT NULL COMMENT '实际开始时间',
  `actual_end_time`   datetime     DEFAULT NULL COMMENT '实际结束时间',
  `status`            tinyint      NOT NULL DEFAULT 0 COMMENT '状态:0-未开始,1-进行中,2-已完成',
  `deleted_flag`      tinyint      NOT NULL DEFAULT 0 COMMENT '删除标识:0-正常,1-已删除',
  `create_time`       datetime     NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time`       datetime     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`process_id`),
  KEY `idx_order_id` (`order_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COMMENT='生产流程工序';

INSERT INTO `t_production_process` VALUES (1,1,1,'松布','李师傅',8.0,'2026-01-21 08:00:00','2026-01-21 16:00:00','2026-01-21 08:30:00','2026-01-21 16:30:00',2,0,'2026-01-21 08:00:00','2026-01-21 16:30:00');
INSERT INTO `t_production_process` VALUES (2,1,2,'铺布','王师傅',4.0,'2026-01-22 08:00:00','2026-01-22 12:00:00','2026-01-22 08:00:00','2026-01-22 12:30:00',2,0,'2026-01-21 08:00:00','2026-01-22 12:30:00');
INSERT INTO `t_production_process` VALUES (3,1,3,'裁剪','张师傅',6.0,'2026-01-22 13:00:00','2026-01-22 19:00:00','2026-01-22 13:00:00','2026-01-22 18:30:00',2,0,'2026-01-21 08:00:00','2026-01-22 18:30:00');
INSERT INTO `t_production_process` VALUES (4,1,4,'缝制','陈组长',48.0,'2026-01-23 08:00:00','2026-01-25 08:00:00','2026-01-23 08:00:00','2026-01-25 10:00:00',2,0,'2026-01-21 08:00:00','2026-01-25 10:00:00');
INSERT INTO `t_production_process` VALUES (5,1,5,'质检','质检组',8.0,'2026-01-25 10:00:00','2026-01-25 18:00:00','2026-01-25 10:30:00','2026-01-25 17:00:00',2,0,'2026-01-21 08:00:00','2026-01-25 17:00:00');
INSERT INTO `t_production_process` VALUES (6,2,1,'松布','李师傅',8.0,'2026-01-22 08:00:00','2026-01-22 16:00:00','2026-01-22 08:00:00','2026-01-22 16:00:00',2,0,'2026-01-21 09:00:00','2026-01-22 16:00:00');
INSERT INTO `t_production_process` VALUES (7,2,2,'铺布','王师傅',4.0,'2026-01-23 08:00:00','2026-01-23 12:00:00','2026-01-23 08:00:00','2026-01-23 13:00:00',2,0,'2026-01-21 09:00:00','2026-01-23 13:00:00');
INSERT INTO `t_production_process` VALUES (8,2,3,'裁剪','张师傅',6.0,'2026-01-23 14:00:00','2026-01-23 20:00:00','2026-01-23 14:00:00',NULL,1,0,'2026-01-21 09:00:00','2026-01-23 14:00:00');
INSERT INTO `t_production_process` VALUES (9,2,4,'缝制','陈组长',48.0,'2026-01-24 08:00:00','2026-01-26 08:00:00',NULL,NULL,0,0,'2026-01-21 09:00:00','2026-01-21 09:00:00');
INSERT INTO `t_production_process` VALUES (10,2,5,'质检','质检组',8.0,'2026-01-26 08:00:00','2026-01-26 16:00:00',NULL,NULL,0,0,'2026-01-21 09:00:00','2026-01-21 09:00:00');
INSERT INTO `t_production_process` VALUES (11,3,1,'松布','李师傅',10.0,'2026-02-15 08:00:00','2026-02-15 18:00:00','2026-02-15 08:00:00','2026-02-15 18:00:00',2,0,'2026-02-15 10:00:00','2026-02-15 18:00:00');
INSERT INTO `t_production_process` VALUES (12,3,2,'铺布','王师傅',5.0,'2026-02-16 08:00:00','2026-02-16 13:00:00','2026-02-16 08:30:00',NULL,1,0,'2026-02-15 10:00:00','2026-02-16 08:30:00');
INSERT INTO `t_production_process` VALUES (13,3,3,'裁剪','张师傅',8.0,'2026-02-16 14:00:00','2026-02-16 22:00:00',NULL,NULL,0,0,'2026-02-15 10:00:00','2026-02-15 10:00:00');
INSERT INTO `t_production_process` VALUES (14,3,4,'缝制','陈组长',72.0,'2026-02-17 08:00:00','2026-02-20 08:00:00',NULL,NULL,0,0,'2026-02-15 10:00:00','2026-02-15 10:00:00');
INSERT INTO `t_production_process` VALUES (15,3,5,'质检','质检组',8.0,'2026-02-20 08:00:00','2026-02-20 16:00:00',NULL,NULL,0,0,'2026-02-15 10:00:00','2026-02-15 10:00:00');
INSERT INTO `t_production_process` VALUES (16,4,1,'松布','李师傅',8.0,'2026-04-01 08:00:00','2026-04-01 16:00:00',NULL,NULL,0,0,'2026-03-01 09:00:00','2026-03-01 09:00:00');
INSERT INTO `t_production_process` VALUES (17,4,2,'铺布','王师傅',4.0,'2026-04-02 08:00:00','2026-04-02 12:00:00',NULL,NULL,0,0,'2026-03-01 09:00:00','2026-03-01 09:00:00');
INSERT INTO `t_production_process` VALUES (18,4,3,'裁剪','张师傅',6.0,'2026-04-02 13:00:00','2026-04-02 19:00:00',NULL,NULL,0,0,'2026-03-01 09:00:00','2026-03-01 09:00:00');
INSERT INTO `t_production_process` VALUES (19,4,4,'缝制','陈组长',60.0,'2026-04-03 08:00:00','2026-04-05 20:00:00',NULL,NULL,0,0,'2026-03-01 09:00:00','2026-03-01 09:00:00');
INSERT INTO `t_production_process` VALUES (20,4,5,'质检','质检组',8.0,'2026-04-06 08:00:00','2026-04-06 16:00:00',NULL,NULL,0,0,'2026-03-01 09:00:00','2026-03-01 09:00:00');

-- 14. 松布任务表
CREATE TABLE `t_fabric_relax` (
  `relax_id`         bigint        NOT NULL AUTO_INCREMENT COMMENT '松布任务ID',
  `order_id`         bigint        DEFAULT NULL COMMENT '指令单ID',
  `order_no`         varchar(30)   DEFAULT NULL COMMENT '指令单编号',
  `fabric_id`        bigint        DEFAULT NULL COMMENT '面料ID',
  `fabric_no`        varchar(50)   DEFAULT NULL COMMENT '面料编号',
  `fabric_name`      varchar(200)  DEFAULT NULL COMMENT '面料名称',
  `color_name`       varchar(50)   DEFAULT NULL COMMENT '颜色',
  `require_length`   decimal(10,2) DEFAULT NULL COMMENT '需求长度(米)',
  `actual_length`    decimal(10,2) DEFAULT NULL COMMENT '实际长度(米)',
  `relax_hours`      decimal(5,1)  DEFAULT NULL COMMENT '静置时长要求(小时)',
  `relax_time`       datetime      DEFAULT NULL COMMENT '开始静置时间',
  `actual_start_time` datetime     DEFAULT NULL COMMENT '实际开始时间',
  `actual_end_time`  datetime      DEFAULT NULL COMMENT '实际结束时间',
  `status`           tinyint       NOT NULL DEFAULT 0 COMMENT '状态:0-未开始,1-进行中,2-静置完成,3-已结束',
  `relax_type`       tinyint       NOT NULL DEFAULT 1 COMMENT '类型:0-松布计划,1-松布任务',
  `deleted_flag`     tinyint       NOT NULL DEFAULT 0 COMMENT '删除标识:0-正常,1-已删除',
  `remark`           varchar(500)  DEFAULT NULL COMMENT '备注',
  `create_user_id`   bigint        DEFAULT NULL COMMENT '创建人ID',
  `create_user_name` varchar(50)   DEFAULT NULL COMMENT '创建人姓名',
  `create_time`      datetime      NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time`      datetime      NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`relax_id`),
  KEY `idx_order_id` (`order_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COMMENT='松布任务';

INSERT INTO `t_fabric_relax` VALUES (1,1,'SC202601210001',1,'ML152101','棉1X1罗纹食毛','米白',150.00,152.00,8.0,'2026-01-21 08:30:00','2026-01-21 08:30:00','2026-01-21 16:30:00',3,1,0,'已完成松布',1,'管理员','2026-01-21 08:00:00','2026-01-21 16:30:00');
INSERT INTO `t_fabric_relax` VALUES (2,1,'SC202601210001',1,'ML152101','棉1X1罗纹食毛','黑色',120.00,121.50,8.0,'2026-01-21 09:00:00','2026-01-21 09:00:00','2026-01-21 17:00:00',3,1,0,'已完成松布',1,'管理员','2026-01-21 08:00:00','2026-01-21 17:00:00');
INSERT INTO `t_fabric_relax` VALUES (3,2,'SC202601210002',2,'ML152102','纯棉平纹布','藏蓝',200.00,202.00,8.0,'2026-01-22 08:00:00','2026-01-22 08:00:00','2026-01-22 16:00:00',3,1,0,'已完成松布',1,'管理员','2026-01-21 09:00:00','2026-01-22 16:00:00');
INSERT INTO `t_fabric_relax` VALUES (4,2,'SC202601210002',2,'ML152102','纯棉平纹布','卡其',50.00,50.50,8.0,'2026-01-22 08:00:00','2026-01-22 08:00:00','2026-01-22 16:00:00',3,1,0,'已完成松布',1,'管理员','2026-01-21 09:00:00','2026-01-22 16:00:00');
INSERT INTO `t_fabric_relax` VALUES (5,3,'SC202602150001',2,'ML152102','纯棉平纹布','卡其',280.00,282.00,10.0,'2026-02-15 08:00:00','2026-02-15 08:00:00','2026-02-15 18:00:00',2,1,0,'静置已完成，等待铺布',1,'管理员','2026-02-15 10:00:00','2026-02-15 18:00:00');
INSERT INTO `t_fabric_relax` VALUES (6,4,'SC202603010001',4,'ML152104','氨纶弹力布','天蓝',130.00,NULL,8.0,NULL,NULL,NULL,0,0,0,'计划中',1,'管理员','2026-03-01 09:00:00','2026-03-01 09:00:00');
INSERT INTO `t_fabric_relax` VALUES (7,5,'SC202603200001',1,'ML152101','棉1X1罗纹食毛','米白',400.00,NULL,8.0,'2026-04-09 08:00:00','2026-04-09 08:00:00',NULL,1,1,0,'正在松布中',1,'管理员','2026-03-20 09:00:00','2026-04-09 08:00:00');
INSERT INTO `t_fabric_relax` VALUES (8,5,'SC202603200001',1,'ML152101','棉1X1罗纹食毛','黑色',200.00,NULL,8.0,NULL,NULL,NULL,0,1,0,'等待开始',1,'管理员','2026-03-20 09:00:00','2026-03-20 09:00:00');
-- 两周松布任务（2026-04-13 至 2026-04-26，松布完成查 status=2 AND update_time，仪表盘播报）
INSERT INTO `t_fabric_relax` VALUES (9,6,'SC202604070001',2,'ML152102','纯棉平纹布','白色',80.00,82.00,8.0,'2026-04-13 08:00:00','2026-04-13 08:00:00','2026-04-13 16:00:00',2,1,0,'静置完成',1,'管理员','2026-04-13 08:00:00','2026-04-13 16:00:00');
INSERT INTO `t_fabric_relax` VALUES (10,7,'SC202604080001',2,'ML152102','纯棉平纹布','卡其',120.00,122.00,8.0,'2026-04-13 09:00:00','2026-04-13 09:00:00','2026-04-13 17:00:00',2,1,0,'静置完成',1,'管理员','2026-04-13 09:00:00','2026-04-13 17:00:00');
INSERT INTO `t_fabric_relax` VALUES (11,4,'SC202603010001',4,'ML152104','氨纶弹力布','天蓝',130.00,132.00,10.0,'2026-04-14 08:00:00','2026-04-14 08:00:00','2026-04-14 18:00:00',3,1,0,'已结束',1,'管理员','2026-04-14 08:00:00','2026-04-14 18:00:00');
INSERT INTO `t_fabric_relax` VALUES (12,6,'SC202604070001',2,'ML152102','纯棉平纹布','粉色',90.00,91.00,8.0,'2026-04-14 09:00:00','2026-04-14 09:00:00','2026-04-14 17:00:00',2,1,0,'静置完成',1,'管理员','2026-04-14 09:00:00','2026-04-14 17:00:00');
INSERT INTO `t_fabric_relax` VALUES (13,7,'SC202604080001',2,'ML152102','纯棉平纹布','黑色',100.00,101.00,8.0,'2026-04-15 08:00:00','2026-04-15 08:00:00','2026-04-15 16:00:00',2,1,0,'静置完成',1,'管理员','2026-04-15 08:00:00','2026-04-15 16:00:00');
INSERT INTO `t_fabric_relax` VALUES (14,5,'SC202603200001',1,'ML152101','棉1X1罗纹食毛','黑色',200.00,202.00,8.0,'2026-04-15 09:00:00','2026-04-15 09:00:00','2026-04-15 17:00:00',2,1,0,'静置完成',1,'管理员','2026-04-15 09:00:00','2026-04-15 17:00:00');
INSERT INTO `t_fabric_relax` VALUES (15,8,'SC202604090001',2,'ML152102','纯棉平纹布','白色',110.00,112.00,8.0,'2026-04-16 08:00:00','2026-04-16 08:00:00','2026-04-16 16:00:00',2,1,0,'静置完成',1,'管理员','2026-04-16 08:00:00','2026-04-16 16:00:00');
INSERT INTO `t_fabric_relax` VALUES (16,4,'SC202603010001',4,'ML152104','氨纶弹力布','灰色',70.00,71.00,10.0,'2026-04-17 09:00:00','2026-04-17 09:00:00','2026-04-17 19:00:00',2,1,0,'静置完成',1,'管理员','2026-04-17 09:00:00','2026-04-17 19:00:00');
INSERT INTO `t_fabric_relax` VALUES (17,6,'SC202604070001',2,'ML152102','纯棉平纹布','蓝色',95.00,96.00,8.0,'2026-04-18 08:00:00','2026-04-18 08:00:00','2026-04-18 16:00:00',2,1,0,'静置完成',1,'管理员','2026-04-18 08:00:00','2026-04-18 16:00:00');
INSERT INTO `t_fabric_relax` VALUES (18,7,'SC202604080001',2,'ML152102','纯棉平纹布','卡其',150.00,NULL,8.0,'2026-04-19 09:00:00','2026-04-19 09:00:00',NULL,1,1,0,'进行中',1,'管理员','2026-04-19 09:00:00','2026-04-19 09:00:00');
INSERT INTO `t_fabric_relax` VALUES (19,5,'SC202603200001',1,'ML152101','棉1X1罗纹食毛','米白',180.00,182.00,8.0,'2026-04-20 08:00:00','2026-04-20 08:00:00','2026-04-20 16:00:00',2,1,0,'静置完成',1,'管理员','2026-04-20 08:00:00','2026-04-20 16:00:00');
INSERT INTO `t_fabric_relax` VALUES (20,8,'SC202604090001',2,'ML152102','纯棉平纹布','粉色',85.00,86.00,8.0,'2026-04-21 09:00:00','2026-04-21 09:00:00','2026-04-21 17:00:00',2,1,0,'静置完成',1,'管理员','2026-04-21 09:00:00','2026-04-21 17:00:00');
INSERT INTO `t_fabric_relax` VALUES (21,6,'SC202604070001',2,'ML152102','纯棉平纹布','白色',100.00,NULL,8.0,'2026-04-22 08:00:00','2026-04-22 08:00:00',NULL,1,1,0,'进行中',1,'管理员','2026-04-22 08:00:00','2026-04-22 08:00:00');
INSERT INTO `t_fabric_relax` VALUES (22,7,'SC202604080001',2,'ML152102','纯棉平纹布','黑色',120.00,NULL,8.0,NULL,NULL,NULL,0,1,0,'等待开始',1,'管理员','2026-04-23 09:00:00','2026-04-23 09:00:00');

-- 15. 铺布任务表
CREATE TABLE `t_fabric_spread` (
  `spread_id`        bigint        NOT NULL AUTO_INCREMENT COMMENT '铺布任务ID',
  `order_id`         bigint        NOT NULL COMMENT '指令单ID',
  `order_no`         varchar(30)   DEFAULT NULL COMMENT '指令单编号',
  `fabric_id`        bigint        DEFAULT NULL COMMENT '面料ID',
  `fabric_no`        varchar(50)   DEFAULT NULL COMMENT '面料编号',
  `fabric_name`      varchar(200)  DEFAULT NULL COMMENT '面料名称',
  `color_name`       varchar(50)   DEFAULT NULL COMMENT '颜色',
  `require_layers`   int           DEFAULT NULL COMMENT '要求铺布层数',
  `require_length`   decimal(10,2) DEFAULT NULL COMMENT '要求铺布总长度(米)',
  `actual_layers`    int           DEFAULT NULL COMMENT '实际铺布层数',
  `actual_length`    decimal(10,2) DEFAULT NULL COMMENT '实际铺布总长度(米)',
  `status`           tinyint       NOT NULL DEFAULT 0 COMMENT '状态:0-待作业,1-进行中,2-已完成',
  `issued_flag`      tinyint       NOT NULL DEFAULT 0 COMMENT '是否已下发:0-否,1-是',
  `deleted_flag`     tinyint       NOT NULL DEFAULT 0 COMMENT '删除标识:0-正常,1-已删除',
  `remark`           varchar(500)  DEFAULT NULL COMMENT '备注',
  `create_user_id`   bigint        DEFAULT NULL COMMENT '创建人ID',
  `create_user_name` varchar(50)   DEFAULT NULL COMMENT '创建人姓名',
  `create_time`      datetime      NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time`      datetime      NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`spread_id`),
  KEY `idx_order_id` (`order_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COMMENT='铺布任务';

INSERT INTO `t_fabric_spread` VALUES (1,1,'SC202601210001',1,'ML152101','棉1X1罗纹食毛','米白',30,150.00,30,152.00,2,1,0,'铺布完成',1,'管理员','2026-01-22 07:00:00','2026-01-22 12:30:00');
INSERT INTO `t_fabric_spread` VALUES (2,1,'SC202601210001',1,'ML152101','棉1X1罗纹食毛','黑色',25,120.00,25,121.50,2,1,0,'铺布完成',1,'管理员','2026-01-22 07:00:00','2026-01-22 12:30:00');
INSERT INTO `t_fabric_spread` VALUES (3,2,'SC202601210002',2,'ML152102','纯棉平纹布','藏蓝',40,200.00,40,202.00,2,1,0,'铺布完成',1,'管理员','2026-01-23 07:00:00','2026-01-23 13:00:00');
INSERT INTO `t_fabric_spread` VALUES (4,2,'SC202601210002',2,'ML152102','纯棉平纹布','卡其',10,50.00,10,50.50,2,1,0,'铺布完成',1,'管理员','2026-01-23 07:00:00','2026-01-23 13:00:00');
INSERT INTO `t_fabric_spread` VALUES (5,3,'SC202602150001',2,'ML152102','纯棉平纹布','卡其',50,280.00,NULL,NULL,1,1,0,'铺布进行中',1,'管理员','2026-02-16 07:00:00','2026-02-16 08:30:00');
INSERT INTO `t_fabric_spread` VALUES (6,4,'SC202603010001',4,'ML152104','氨纶弹力布','天蓝',30,130.00,NULL,NULL,0,0,0,'计划中',1,'管理员','2026-03-01 09:00:00','2026-03-01 09:00:00');
INSERT INTO `t_fabric_spread` VALUES (7,5,'SC202603200001',1,'ML152101','棉1X1罗纹食毛','米白',60,400.00,NULL,NULL,0,0,0,'等待松布完成',1,'管理员','2026-03-20 09:00:00','2026-03-20 09:00:00');
INSERT INTO `t_fabric_spread` VALUES (8,5,'SC202603200001',1,'ML152101','棉1X1罗纹食毛','黑色',30,200.00,NULL,NULL,0,0,0,'等待松布完成',1,'管理员','2026-03-20 09:00:00','2026-03-20 09:00:00');
-- 两周铺布任务（2026-04-13 至 2026-04-26，铺布完成查 status=2 AND update_time）
INSERT INTO `t_fabric_spread` VALUES (9,6,'SC202604070001',2,'ML152102','纯棉平纹布','白色',35,80.00,35,82.00,2,1,0,'铺布完成',1,'管理员','2026-04-13 10:00:00','2026-04-13 14:00:00');
INSERT INTO `t_fabric_spread` VALUES (10,7,'SC202604080001',2,'ML152102','纯棉平纹布','卡其',40,120.00,40,122.00,2,1,0,'铺布完成',1,'管理员','2026-04-13 11:00:00','2026-04-13 15:00:00');
INSERT INTO `t_fabric_spread` VALUES (11,4,'SC202603010001',4,'ML152104','氨纶弹力布','天蓝',30,130.00,30,132.00,2,1,0,'铺布完成',1,'管理员','2026-04-14 10:00:00','2026-04-14 15:00:00');
INSERT INTO `t_fabric_spread` VALUES (12,6,'SC202604070001',2,'ML152102','纯棉平纹布','粉色',35,90.00,35,91.00,2,1,0,'铺布完成',1,'管理员','2026-04-14 11:00:00','2026-04-14 16:00:00');
INSERT INTO `t_fabric_spread` VALUES (13,7,'SC202604080001',2,'ML152102','纯棉平纹布','黑色',40,100.00,40,101.00,2,1,0,'铺布完成',1,'管理员','2026-04-15 10:00:00','2026-04-15 14:30:00');
INSERT INTO `t_fabric_spread` VALUES (14,5,'SC202603200001',1,'ML152101','棉1X1罗纹食毛','黑色',45,200.00,45,202.00,2,1,0,'铺布完成',1,'管理员','2026-04-15 11:00:00','2026-04-15 16:00:00');
INSERT INTO `t_fabric_spread` VALUES (15,8,'SC202604090001',2,'ML152102','纯棉平纹布','白色',35,110.00,35,112.00,2,1,0,'铺布完成',1,'管理员','2026-04-16 10:00:00','2026-04-16 14:30:00');
INSERT INTO `t_fabric_spread` VALUES (16,4,'SC202603010001',4,'ML152104','氨纶弹力布','灰色',30,70.00,30,71.00,2,1,0,'铺布完成',1,'管理员','2026-04-17 11:00:00','2026-04-17 16:00:00');
INSERT INTO `t_fabric_spread` VALUES (17,6,'SC202604070001',2,'ML152102','纯棉平纹布','蓝色',35,95.00,35,96.00,2,1,0,'铺布完成',1,'管理员','2026-04-18 10:00:00','2026-04-18 14:30:00');
INSERT INTO `t_fabric_spread` VALUES (18,7,'SC202604080001',2,'ML152102','纯棉平纹布','卡其',40,150.00,NULL,NULL,1,1,0,'铺布进行中',1,'管理员','2026-04-19 11:00:00','2026-04-19 11:00:00');
INSERT INTO `t_fabric_spread` VALUES (19,5,'SC202603200001',1,'ML152101','棉1X1罗纹食毛','米白',45,180.00,45,182.00,2,1,0,'铺布完成',1,'管理员','2026-04-20 10:00:00','2026-04-20 15:00:00');
INSERT INTO `t_fabric_spread` VALUES (20,8,'SC202604090001',2,'ML152102','纯棉平纹布','粉色',35,85.00,35,86.00,2,1,0,'铺布完成',1,'管理员','2026-04-21 11:00:00','2026-04-21 15:30:00');
INSERT INTO `t_fabric_spread` VALUES (21,6,'SC202604070001',2,'ML152102','纯棉平纹布','白色',35,100.00,NULL,NULL,1,1,0,'铺布进行中',1,'管理员','2026-04-22 10:00:00','2026-04-22 10:00:00');
INSERT INTO `t_fabric_spread` VALUES (22,7,'SC202604080001',2,'ML152102','纯棉平纹布','黑色',40,120.00,NULL,NULL,0,0,0,'等待开始',1,'管理员','2026-04-23 11:00:00','2026-04-23 11:00:00');

-- 16. 裁剪计划表
CREATE TABLE `t_cutting_plan` (
  `plan_id`          bigint        NOT NULL AUTO_INCREMENT COMMENT '裁剪计划ID',
  `plan_no`          varchar(30)   NOT NULL COMMENT '计划编号（如CP20260101001）',
  `order_id`         bigint        DEFAULT NULL COMMENT '指令单ID',
  `order_no`         varchar(30)   DEFAULT NULL COMMENT '指令单编号',
  `customer_name`    varchar(100)  DEFAULT NULL COMMENT '客户名称',
  `style_no`         varchar(50)   DEFAULT NULL COMMENT '款号',
  `style_name`       varchar(100)  DEFAULT NULL COMMENT '款名',
  `plan_date`        date          DEFAULT NULL COMMENT '计划裁剪日期',
  `plan_quantity`    int           DEFAULT 0 COMMENT '计划数量',
  `actual_quantity`  int           DEFAULT 0 COMMENT '实际数量',
  `status`           tinyint       NOT NULL DEFAULT 0 COMMENT '状态:0-计划,1-进行中,2-完成',
  `deleted_flag`     tinyint       NOT NULL DEFAULT 0 COMMENT '删除标识:0-正常,1-已删除',
  `remark`           varchar(500)  DEFAULT NULL COMMENT '备注',
  `create_user_id`   bigint        DEFAULT NULL COMMENT '创建人ID',
  `create_user_name` varchar(50)   DEFAULT NULL COMMENT '创建人姓名',
  `create_time`      datetime      NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time`      datetime      NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`plan_id`),
  UNIQUE KEY `uk_plan_no` (`plan_no`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COMMENT='裁剪计划';

INSERT INTO `t_cutting_plan` VALUES (1,'CP20260122001',1,'SC202601210001','元一','YY001','棉质圆领T恤','2026-01-22',500,500,2,0,'已完成裁剪',1,'管理员','2026-01-21 18:00:00','2026-01-22 18:30:00');
INSERT INTO `t_cutting_plan` VALUES (2,'CP20260123001',2,'SC202601210002','美诺','YY002','男款修身衬衫','2026-01-23',300,0,1,0,'裁剪进行中',1,'管理员','2026-01-22 18:00:00','2026-01-23 14:00:00');
INSERT INTO `t_cutting_plan` VALUES (3,'CP20260216001',3,'SC202602150001','鑫达','YY003','休闲直筒裤','2026-02-17',400,0,1,0,'等待铺布完成',1,'管理员','2026-02-16 09:00:00','2026-02-16 09:00:00');
INSERT INTO `t_cutting_plan` VALUES (4,'CP20260410001',4,'SC202603010001','元一','YY004','运动卫衣','2026-04-10',200,0,1,0,'计划中',1,'管理员','2026-04-09 09:00:00','2026-04-09 09:00:00');
INSERT INTO `t_cutting_plan` VALUES (5,'CP20260501001',5,'SC202603200001','恒通','YY001','棉质圆领T恤','2026-05-01',1000,0,1,0,'大批量，需分批裁剪',1,'管理员','2026-04-09 09:00:00','2026-04-09 09:00:00');
INSERT INTO `t_cutting_plan` VALUES (6,'CP20260407001',4,'SC202603010001','元一','YY004','运动卫衣','2026-04-20',200,0,2,0,'本周开始裁剪',1,'管理员','2026-04-07 09:00:00','2026-04-07 09:00:00');
INSERT INTO `t_cutting_plan` VALUES (7,'CP20260408001',7,'SC202604080001','鑫达','YY006','休闲短裤','2026-04-25',800,0,2,0,'已下达裁剪',1,'管理员','2026-04-08 09:00:00','2026-04-08 09:00:00');
INSERT INTO `t_cutting_plan` VALUES (8,'CP20260409001',6,'SC202604070001','美诺','YY005','夏季连衣裙','2026-05-10',600,0,1,0,'计划中',1,'管理员','2026-04-09 09:00:00','2026-04-09 09:00:00');

-- 17. 裁床单表
CREATE TABLE `t_cutting_order` (
  `cutting_order_id`  bigint        NOT NULL AUTO_INCREMENT COMMENT '裁床单ID',
  `cutting_order_no`  varchar(30)   NOT NULL COMMENT '裁床单编号（如CO20260101001）',
  `plan_id`           bigint        DEFAULT NULL COMMENT '裁剪计划ID',
  `plan_no`           varchar(30)   DEFAULT NULL COMMENT '裁剪计划编号',
  `order_id`          bigint        DEFAULT NULL COMMENT '指令单ID',
  `order_no`          varchar(30)   DEFAULT NULL COMMENT '指令单编号',
  `customer_name`     varchar(100)  DEFAULT NULL COMMENT '客户名称',
  `style_no`          varchar(50)   DEFAULT NULL COMMENT '款号',
  `style_name`        varchar(100)  DEFAULT NULL COMMENT '款名',
  `color_name`        varchar(50)   DEFAULT NULL COMMENT '颜色',
  `size_name`         varchar(20)   DEFAULT NULL COMMENT '尺码',
  `quantity`          int           DEFAULT 0 COMMENT '裁剪数量',
  `bed_no`            varchar(50)   DEFAULT NULL COMMENT '裁床编号',
  `layers`            int           DEFAULT NULL COMMENT '铺布层数',
  `fabric_no`         varchar(50)   DEFAULT NULL COMMENT '面料编号',
  `fabric_name`       varchar(200)  DEFAULT NULL COMMENT '面料名称',
  `status`            tinyint       NOT NULL DEFAULT 1 COMMENT '状态:1-待裁,2-裁剪中,3-完成',
  `deleted_flag`      tinyint       NOT NULL DEFAULT 0 COMMENT '删除标识:0-正常,1-已删除',
  `remark`            varchar(500)  DEFAULT NULL COMMENT '备注',
  `create_user_id`    bigint        DEFAULT NULL COMMENT '创建人ID',
  `create_user_name`  varchar(50)   DEFAULT NULL COMMENT '创建人姓名',
  `create_time`       datetime      NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time`       datetime      NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`cutting_order_id`),
  UNIQUE KEY `uk_cutting_order_no` (`cutting_order_no`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COMMENT='裁床单';

INSERT INTO `t_cutting_order` VALUES (1,'CO20260122001',1,'CP20260122001',1,'SC202601210001','元一','YY001','棉质圆领T恤','米白','S',50,'A01',30,'ML152101','棉1X1罗纹食毛',2,0,'已完成',1,'管理员','2026-01-22 08:00:00','2026-01-22 18:30:00');
INSERT INTO `t_cutting_order` VALUES (2,'CO20260122002',1,'CP20260122001',1,'SC202601210001','元一','YY001','棉质圆领T恤','米白','M',80,'A01',30,'ML152101','棉1X1罗纹食毛',2,0,'已完成',1,'管理员','2026-01-22 08:00:00','2026-01-22 18:30:00');
INSERT INTO `t_cutting_order` VALUES (3,'CO20260122003',1,'CP20260122001',1,'SC202601210001','元一','YY001','棉质圆领T恤','米白','L',100,'A02',30,'ML152101','棉1X1罗纹食毛',2,0,'已完成',1,'管理员','2026-01-22 08:00:00','2026-01-22 18:30:00');
INSERT INTO `t_cutting_order` VALUES (4,'CO20260122004',1,'CP20260122001',1,'SC202601210001','元一','YY001','棉质圆领T恤','米白','XL',70,'A02',30,'ML152101','棉1X1罗纹食毛',2,0,'已完成',1,'管理员','2026-01-22 08:00:00','2026-01-22 18:30:00');
INSERT INTO `t_cutting_order` VALUES (5,'CO20260122005',1,'CP20260122001',1,'SC202601210001','元一','YY001','棉质圆领T恤','黑色','M',80,'B01',25,'ML152101','棉1X1罗纹食毛',2,0,'已完成',1,'管理员','2026-01-22 08:00:00','2026-01-22 18:30:00');
INSERT INTO `t_cutting_order` VALUES (6,'CO20260122006',1,'CP20260122001',1,'SC202601210001','元一','YY001','棉质圆领T恤','黑色','L',50,'B01',25,'ML152101','棉1X1罗纹食毛',2,0,'已完成',1,'管理员','2026-01-22 08:00:00','2026-01-22 18:30:00');
INSERT INTO `t_cutting_order` VALUES (7,'CO20260123001',2,'CP20260123001',2,'SC202601210002','美诺','YY002','男款修身衬衫','藏蓝','M',80,'A01',40,'ML152102','纯棉平纹布',2,0,'裁剪中',1,'管理员','2026-01-23 13:00:00','2026-01-23 14:00:00');
INSERT INTO `t_cutting_order` VALUES (8,'CO20260123002',2,'CP20260123001',2,'SC202601210002','美诺','YY002','男款修身衬衫','藏蓝','L',120,'A01',40,'ML152102','纯棉平纹布',1,0,'待裁',1,'管理员','2026-01-23 13:00:00','2026-01-23 13:00:00');
INSERT INTO `t_cutting_order` VALUES (9,'CO20260123003',2,'CP20260123001',2,'SC202601210002','美诺','YY002','男款修身衬衫','藏蓝','XL',60,'A02',40,'ML152102','纯棉平纹布',1,0,'待裁',1,'管理员','2026-01-23 13:00:00','2026-01-23 13:00:00');
INSERT INTO `t_cutting_order` VALUES (10,'CO20260217001',3,'CP20260216001',3,'SC202602150001','鑫达','YY003','休闲直筒裤','卡其','M',100,'B02',50,'ML152102','纯棉平纹布',1,0,'待裁',1,'管理员','2026-02-16 09:00:00','2026-02-16 09:00:00');
INSERT INTO `t_cutting_order` VALUES (11,'CO20260217002',3,'CP20260216001',3,'SC202602150001','鑫达','YY003','休闲直筒裤','卡其','L',150,'B02',50,'ML152102','纯棉平纹布',1,0,'待裁',1,'管理员','2026-02-16 09:00:00','2026-02-16 09:00:00');
INSERT INTO `t_cutting_order` VALUES (12,'CO20260217003',3,'CP20260216001',3,'SC202602150001','鑫达','YY003','休闲直筒裤','卡其','XL',100,'B02',50,'ML152102','纯棉平纹布',1,0,'待裁',1,'管理员','2026-02-16 09:00:00','2026-02-16 09:00:00');
-- 两周裁床单数据（2026-04-13 至 2026-04-26，用于首页趋势图，完工查 status=3 AND update_time）
-- 周一 2026-04-13
INSERT INTO `t_cutting_order` VALUES (13,'CO20260413001',2,'CP20260123001',2,'SC202601210002','美诺','YY002','男款修身衬衫','白色','S',60,'A01',35,'ML152102','纯棉平纹布',3,0,'完成',1,'管理员','2026-04-13 09:00:00','2026-04-13 17:00:00');
INSERT INTO `t_cutting_order` VALUES (14,'CO20260413002',6,'CP20260407001',4,'SC202603010001','元一','YY004','运动卫衣','灰色','M',50,'B01',30,'ML152101','棉1X1罗纹食毛',3,0,'完成',1,'管理员','2026-04-13 10:00:00','2026-04-13 18:00:00');
-- 周二 2026-04-14
INSERT INTO `t_cutting_order` VALUES (15,'CO20260414001',7,'CP20260408001',7,'SC202604080001','鑫达','YY006','休闲短裤','卡其','M',80,'A02',40,'ML152102','纯棉平纹布',3,0,'完成',1,'管理员','2026-04-14 09:00:00','2026-04-14 17:00:00');
INSERT INTO `t_cutting_order` VALUES (16,'CO20260414002',6,'CP20260407001',4,'SC202603010001','元一','YY004','运动卫衣','灰色','L',70,'B01',30,'ML152101','棉1X1罗纹食毛',2,0,'裁剪中',1,'管理员','2026-04-14 10:00:00','2026-04-14 10:00:00');
-- 周三 2026-04-15
INSERT INTO `t_cutting_order` VALUES (17,'CO20260415001',5,'CP20260501001',5,'SC202603200001','恒通','YY001','棉质圆领T恤','白色','S',100,'B02',45,'ML152101','棉1X1罗纹食毛',3,0,'完成',1,'管理员','2026-04-15 09:00:00','2026-04-15 17:00:00');
INSERT INTO `t_cutting_order` VALUES (18,'CO20260415002',8,'CP20260409001',6,'SC202604070001','美诺','YY005','夏季连衣裙','白色','M',90,'A01',35,'ML152102','纯棉平纹布',3,0,'完成',1,'管理员','2026-04-15 10:00:00','2026-04-15 18:00:00');
-- 周四 2026-04-16
INSERT INTO `t_cutting_order` VALUES (19,'CO20260416001',7,'CP20260408001',7,'SC202604080001','鑫达','YY006','休闲短裤','黑色','L',100,'A02',40,'ML152102','纯棉平纹布',2,0,'裁剪中',1,'管理员','2026-04-16 09:00:00','2026-04-16 09:00:00');
INSERT INTO `t_cutting_order` VALUES (20,'CO20260416002',5,'CP20260501001',5,'SC202603200001','恒通','YY001','棉质圆领T恤','白色','M',120,'B02',45,'ML152101','棉1X1罗纹食毛',3,0,'完成',1,'管理员','2026-04-16 10:00:00','2026-04-16 17:00:00');
-- 周五 2026-04-17
INSERT INTO `t_cutting_order` VALUES (21,'CO20260417001',6,'CP20260407001',4,'SC202603010001','元一','YY004','运动卫衣','黑色','M',60,'A01',30,'ML152101','棉1X1罗纹食毛',3,0,'完成',1,'管理员','2026-04-17 09:00:00','2026-04-17 17:00:00');
INSERT INTO `t_cutting_order` VALUES (22,'CO20260417002',8,'CP20260409001',6,'SC202604070001','美诺','YY005','夏季连衣裙','粉色','L',80,'A02',35,'ML152102','纯棉平纹布',1,0,'待裁',1,'管理员','2026-04-17 10:00:00','2026-04-17 10:00:00');
-- 周六 2026-04-18
INSERT INTO `t_cutting_order` VALUES (23,'CO20260418001',7,'CP20260408001',7,'SC202604080001','鑫达','YY006','休闲短裤','卡其','XL',70,'B01',40,'ML152102','纯棉平纹布',3,0,'完成',1,'管理员','2026-04-18 09:00:00','2026-04-18 17:00:00');
-- 周日 2026-04-19
INSERT INTO `t_cutting_order` VALUES (24,'CO20260419001',5,'CP20260501001',5,'SC202603200001','恒通','YY001','棉质圆领T恤','黑色','L',130,'B02',45,'ML152101','棉1X1罗纹食毛',3,0,'完成',1,'管理员','2026-04-19 09:00:00','2026-04-19 17:00:00');
-- 下周一 2026-04-20
INSERT INTO `t_cutting_order` VALUES (25,'CO20260420001',6,'CP20260407001',4,'SC202603010001','元一','YY004','运动卫衣','灰色','XL',40,'A01',30,'ML152101','棉1X1罗纹食毛',3,0,'完成',1,'管理员','2026-04-20 09:00:00','2026-04-20 17:00:00');
-- 下周二 2026-04-21
INSERT INTO `t_cutting_order` VALUES (26,'CO20260421001',8,'CP20260409001',6,'SC202604070001','美诺','YY005','夏季连衣裙','白色','S',60,'A02',35,'ML152102','纯棉平纹布',3,0,'完成',1,'管理员','2026-04-21 09:00:00','2026-04-21 17:00:00');
-- 下周三 2026-04-22
INSERT INTO `t_cutting_order` VALUES (27,'CO20260422001',7,'CP20260408001',7,'SC202604080001','鑫达','YY006','休闲短裤','黑色','M',90,'B01',40,'ML152102','纯棉平纹布',3,0,'完成',1,'管理员','2026-04-22 09:00:00','2026-04-22 17:00:00');
-- 下周四 2026-04-23
INSERT INTO `t_cutting_order` VALUES (28,'CO20260423001',5,'CP20260501001',5,'SC202603200001','恒通','YY001','棉质圆领T恤','黑色','XL',90,'B02',45,'ML152101','棉1X1罗纹食毛',1,0,'待裁',1,'管理员','2026-04-23 09:00:00','2026-04-23 09:00:00');

-- =====================================================
-- 18. 菜单数据（服装裁剪系统菜单）
-- 清空旧菜单及角色菜单关联，插入最新业务菜单
-- =====================================================
DELETE FROM `t_role_menu`;
DELETE FROM `t_menu`;
ALTER TABLE `t_menu` AUTO_INCREMENT = 10001;

INSERT INTO `t_menu` (`menu_id`,`menu_name`,`menu_type`,`parent_id`,`sort`,`path`,`component`,`perms_type`,`api_perms`,`web_perms`,`icon`,`context_menu_id`,`frame_flag`,`frame_url`,`cache_flag`,`visible_flag`,`disabled_flag`,`deleted_flag`,`create_user_id`,`create_time`,`update_user_id`,`update_time`)
VALUES
(10001,'生产管理',1,0,1,'/production','NULL',NULL,NULL,NULL,'ToolOutlined',NULL,0,NULL,0,1,0,0,1,NOW(),1,NOW()),
(10002,'生产制单',2,10001,1,'/production/order','business/cutting/production/order/order-list',NULL,NULL,NULL,'FileTextOutlined',NULL,0,NULL,1,1,0,0,1,NOW(),1,NOW()),
(10003,'裁剪数据',1,0,2,'/cutting',NULL,NULL,NULL,NULL,'ScissorOutlined',NULL,0,NULL,0,1,0,0,1,NOW(),1,NOW()),
(10004,'裁剪计划',2,10003,1,'/cutting/plan','business/cutting/cutting-plan/cutting-plan-list',NULL,NULL,NULL,'CalendarOutlined',NULL,0,NULL,1,1,0,0,1,NOW(),1,NOW()),
(10005,'裁床单列表',2,10003,2,'/cutting/order','business/cutting/cutting-order/cutting-order-list',NULL,NULL,NULL,'OrderedListOutlined',NULL,0,NULL,1,1,0,0,1,NOW(),1,NOW()),
(10006,'松布管理',1,0,3,'/relax',NULL,NULL,NULL,NULL,'ExpandOutlined',NULL,0,NULL,0,1,0,0,1,NOW(),1,NOW()),
(10007,'松布仪表盘',2,10006,1,'/relax/dashboard','business/cutting/relax/relax-dashboard',NULL,NULL,NULL,'DashboardOutlined',NULL,0,NULL,1,1,0,0,1,NOW(),1,NOW()),
(10008,'松布计划',2,10006,2,'/relax/plan','business/cutting/relax/relax-plan-list',NULL,NULL,NULL,'ProfileOutlined',NULL,0,NULL,1,1,0,0,1,NOW(),1,NOW()),
(10009,'松布任务',2,10006,3,'/relax/task','business/cutting/relax/relax-task-list',NULL,NULL,NULL,'UnorderedListOutlined',NULL,0,NULL,1,1,0,0,1,NOW(),1,NOW()),
(10010,'铺布管理',1,0,4,'/spread',NULL,NULL,NULL,NULL,'AppstoreOutlined',NULL,0,NULL,0,1,0,0,1,NOW(),1,NOW()),
(10011,'铺布仪表盘',2,10010,1,'/spread/dashboard','business/cutting/spread/spread-dashboard',NULL,NULL,NULL,'DashboardOutlined',NULL,0,NULL,1,1,0,0,1,NOW(),1,NOW()),
(10012,'铺布任务',2,10010,2,'/spread/task','business/cutting/spread/spread-task-list',NULL,NULL,NULL,'UnorderedListOutlined',NULL,0,NULL,1,1,0,0,1,NOW(),1,NOW()),
(10013,'铺布工作台',2,10010,3,'/spread/workbench','business/cutting/spread/spread-workbench',NULL,NULL,NULL,'DesktopOutlined',NULL,0,NULL,1,1,0,0,1,NOW(),1,NOW()),
(10014,'物料管理',1,0,5,'/material',NULL,NULL,NULL,NULL,'DatabaseOutlined',NULL,0,NULL,0,1,0,0,1,NOW(),1,NOW()),
(10015,'成衣列表',2,10014,1,'/material/garment','business/cutting/basic/garment/garment-list',NULL,NULL,NULL,'ShoppingOutlined',NULL,0,NULL,1,1,0,0,1,NOW(),1,NOW()),
(10016,'面料列表',2,10014,2,'/material/fabric','business/cutting/basic/fabric/fabric-list',NULL,NULL,NULL,'TagOutlined',NULL,0,NULL,1,1,0,0,1,NOW(),1,NOW()),
(10017,'基础管理',1,0,6,'/basic',NULL,NULL,NULL,NULL,'SettingOutlined',NULL,0,NULL,0,1,0,0,1,NOW(),1,NOW()),
(10018,'基础数据',1,10017,1,'/basic/data',NULL,NULL,NULL,NULL,'FolderOutlined',NULL,0,NULL,0,1,0,0,1,NOW(),1,NOW()),
(10019,'裁片部位',2,10018,1,'/basic/cutting-part','business/cutting/basic/cuttingpart/cuttingpart-list',NULL,NULL,NULL,'BlockOutlined',NULL,0,NULL,1,1,0,0,1,NOW(),1,NOW()),
(10020,'客户管理',2,10018,2,'/basic/customer','business/cutting/basic/customer/customer-list',NULL,NULL,NULL,'TeamOutlined',NULL,0,NULL,1,1,0,0,1,NOW(),1,NOW()),
(10021,'款式颜色',2,10018,3,'/basic/style-color','business/cutting/basic/stylecolor/stylecolor-list',NULL,NULL,NULL,'BgColorsOutlined',NULL,0,NULL,1,1,0,0,1,NOW(),1,NOW()),
(10022,'尺寸列表',2,10018,4,'/basic/size','business/cutting/basic/size/size-list',NULL,NULL,NULL,'ColumnWidthOutlined',NULL,0,NULL,1,1,0,0,1,NOW(),1,NOW()),
(10023,'单位管理',2,10018,5,'/basic/unit','business/cutting/basic/unit/unit-list',NULL,NULL,NULL,'NumberOutlined',NULL,0,NULL,1,1,0,0,1,NOW(),1,NOW());

-- 给超级管理员角色（role_id=1）分配所有菜单权限
INSERT INTO `t_role_menu` (`role_id`, `menu_id`)
SELECT 1, menu_id FROM `t_menu` WHERE deleted_flag = 0;

SET FOREIGN_KEY_CHECKS = 1;

-- =====================================================
-- 更新系统基础数据
-- =====================================================
UPDATE `t_department` SET `department_name` = '乐博实验室' WHERE `department_id` = 1;

