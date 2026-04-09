-- =====================================================
-- 服装裁剪管理系统 - 业务数据库建表脚本
-- 数据库: smart_admin_v3
-- =====================================================
USE `smart_admin_v3`;

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- 1. 客户管理表
-- ----------------------------
DROP TABLE IF EXISTS `t_customer`;
CREATE TABLE `t_customer` (
  `customer_id`    bigint       NOT NULL AUTO_INCREMENT COMMENT '客户ID',
  `customer_name`  varchar(100) NOT NULL COMMENT '客户名称',
  `company_name`   varchar(200) DEFAULT NULL COMMENT '公司名称',
  `contact_person` varchar(50)  DEFAULT NULL COMMENT '联系人',
  `phone`          varchar(30)  DEFAULT NULL COMMENT '电话',
  `level`          varchar(20)  DEFAULT NULL COMMENT '等级',
  `disabled_flag`  tinyint      NOT NULL DEFAULT 0 COMMENT '停用标识:0-启用,1-停用',
  `deleted_flag`   tinyint      NOT NULL DEFAULT 0 COMMENT '删除标识',
  `remark`         varchar(500) DEFAULT NULL COMMENT '备注',
  `create_time`    datetime     NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time`    datetime     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`customer_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COMMENT='客户管理';

INSERT INTO `t_customer` VALUES (1,'元一','元一服装有限公司','张经理','13800138001','A',0,0,'VIP客户','2024-01-01 09:00:00','2024-01-01 09:00:00');
INSERT INTO `t_customer` VALUES (2,'美诺','美诺贸易公司','李总','13900139002','B',0,0,NULL,'2024-01-01 09:00:00','2024-01-01 09:00:00');
INSERT INTO `t_customer` VALUES (3,'鑫达','鑫达纺织集团','王主任','13700137003','A',0,0,'长期合作客户','2024-01-01 09:00:00','2024-01-01 09:00:00');

-- ----------------------------
-- 2. 款式颜色表
-- ----------------------------
DROP TABLE IF EXISTS `t_style_color`;
CREATE TABLE `t_style_color` (
  `color_id`    bigint       NOT NULL AUTO_INCREMENT COMMENT '颜色ID',
  `style_no`    varchar(50)  DEFAULT NULL COMMENT '款号',
  `color_name`  varchar(50)  NOT NULL COMMENT '款式颜色名称',
  `color_code`  varchar(20)  DEFAULT NULL COMMENT '颜色编码',
  `deleted_flag` tinyint     NOT NULL DEFAULT 0 COMMENT '删除标识',
  `remark`      varchar(255) DEFAULT NULL COMMENT '备注',
  `create_user_id`   bigint  DEFAULT NULL COMMENT '创建人ID',
  `create_user_name` varchar(50) DEFAULT NULL COMMENT '创建人姓名',
  `create_time` datetime     NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`color_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COMMENT='款式颜色';

INSERT INTO `t_style_color` VALUES (1,'YY001','米白','MW001',0,NULL,1,'管理员','2024-01-01 09:00:00','2024-01-01 09:00:00');
INSERT INTO `t_style_color` VALUES (2,'YY001','黑色','HE001',0,NULL,1,'管理员','2024-01-01 09:00:00','2024-01-01 09:00:00');
INSERT INTO `t_style_color` VALUES (3,'YY002','藏蓝','ZL001',0,NULL,1,'管理员','2024-01-01 09:00:00','2024-01-01 09:00:00');
INSERT INTO `t_style_color` VALUES (4,'YY002','卡其','KQ001',0,NULL,1,'管理员','2024-01-01 09:00:00','2024-01-01 09:00:00');
INSERT INTO `t_style_color` VALUES (5,'YY003','红色','HS001',0,NULL,1,'管理员','2024-01-01 09:00:00','2024-01-01 09:00:00');

-- ----------------------------
-- 3. 尺寸列表表
-- ----------------------------
DROP TABLE IF EXISTS `t_size`;
CREATE TABLE `t_size` (
  `size_id`      bigint       NOT NULL AUTO_INCREMENT COMMENT '尺码ID',
  `size_name`    varchar(20)  NOT NULL COMMENT '尺码名称',
  `sort`         int          NOT NULL DEFAULT 0 COMMENT '排序',
  `deleted_flag` tinyint      NOT NULL DEFAULT 0 COMMENT '删除标识',
  `remark`       varchar(255) DEFAULT NULL COMMENT '备注',
  `create_time`  datetime     NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time`  datetime     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`size_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COMMENT='尺寸列表';

INSERT INTO `t_size` VALUES (1,'XS',1,0,'超小号','2024-01-01 09:00:00','2024-01-01 09:00:00');
INSERT INTO `t_size` VALUES (2,'S',2,0,'小号','2024-01-01 09:00:00','2024-01-01 09:00:00');
INSERT INTO `t_size` VALUES (3,'M',3,0,'中号','2024-01-01 09:00:00','2024-01-01 09:00:00');
INSERT INTO `t_size` VALUES (4,'L',4,0,'大号','2024-01-01 09:00:00','2024-01-01 09:00:00');
INSERT INTO `t_size` VALUES (5,'XL',5,0,'加大号','2024-01-01 09:00:00','2024-01-01 09:00:00');
INSERT INTO `t_size` VALUES (6,'2XL',6,0,'超大号','2024-01-01 09:00:00','2024-01-01 09:00:00');

-- ----------------------------
-- 4. 单位管理表
-- ----------------------------
DROP TABLE IF EXISTS `t_unit`;
CREATE TABLE `t_unit` (
  `unit_id`      bigint       NOT NULL AUTO_INCREMENT COMMENT '单位ID',
  `unit_name`    varchar(50)  NOT NULL COMMENT '单位名称',
  `unit_code`    varchar(30)  NOT NULL COMMENT '单位编码（系统生成）',
  `deleted_flag` tinyint      NOT NULL DEFAULT 0 COMMENT '删除标识',
  `remark`       varchar(255) DEFAULT NULL COMMENT '备注',
  `create_user_id`   bigint  DEFAULT NULL COMMENT '创建人ID',
  `create_user_name` varchar(50) DEFAULT NULL COMMENT '创建人姓名',
  `update_user_id`   bigint  DEFAULT NULL COMMENT '更新人ID',
  `update_user_name` varchar(50) DEFAULT NULL COMMENT '更新人姓名',
  `create_time`  datetime     NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time`  datetime     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`unit_id`),
  UNIQUE KEY `uk_unit_code` (`unit_code`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COMMENT='单位管理';

INSERT INTO `t_unit` VALUES (1,'米','DW000001',0,NULL,1,'管理员',1,'管理员','2024-01-01 09:00:00','2024-01-01 09:00:00');
INSERT INTO `t_unit` VALUES (2,'千克','DW000002',0,NULL,1,'管理员',1,'管理员','2024-01-01 09:00:00','2024-01-01 09:00:00');
INSERT INTO `t_unit` VALUES (3,'件','DW000003',0,NULL,1,'管理员',1,'管理员','2024-01-01 09:00:00','2024-01-01 09:00:00');
INSERT INTO `t_unit` VALUES (4,'卷','DW000004',0,NULL,1,'管理员',1,'管理员','2024-01-01 09:00:00','2024-01-01 09:00:00');
INSERT INTO `t_unit` VALUES (5,'条','DW000005',0,NULL,1,'管理员',1,'管理员','2024-01-01 09:00:00','2024-01-01 09:00:00');

-- ----------------------------
-- 5. 裁片部位表
-- ----------------------------
DROP TABLE IF EXISTS `t_cutting_part`;
CREATE TABLE `t_cutting_part` (
  `part_id`      bigint       NOT NULL AUTO_INCREMENT COMMENT '部位ID',
  `part_name`    varchar(100) NOT NULL COMMENT '部位名称',
  `part_code`    varchar(50)  DEFAULT NULL COMMENT '部位编码',
  `deleted_flag` tinyint      NOT NULL DEFAULT 0 COMMENT '删除标识',
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

-- ----------------------------
-- 6. 面料表
-- ----------------------------
DROP TABLE IF EXISTS `t_fabric`;
CREATE TABLE `t_fabric` (
  `fabric_id`    bigint       NOT NULL AUTO_INCREMENT COMMENT '面料ID',
  `fabric_name`  varchar(200) NOT NULL COMMENT '面料名称',
  `fabric_no`    varchar(50)  DEFAULT NULL COMMENT '面料编号',
  `fabric_type`  varchar(50)  DEFAULT NULL COMMENT '面料类型（梭织/针织等）',
  `spec`         varchar(100) DEFAULT NULL COMMENT '规格型号',
  `unit_id`      bigint       DEFAULT NULL COMMENT '单位ID',
  `unit_name`    varchar(50)  DEFAULT NULL COMMENT '单位名称',
  `gram_weight`  decimal(10,2) DEFAULT NULL COMMENT '克重(g/㎡)',
  `width`        decimal(10,2) DEFAULT NULL COMMENT '宽度(cm)',
  `disabled_flag` tinyint     NOT NULL DEFAULT 0 COMMENT '停用标识',
  `deleted_flag` tinyint      NOT NULL DEFAULT 0 COMMENT '删除标识',
  `remark`       varchar(500) DEFAULT NULL COMMENT '备注',
  `create_time`  datetime     NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time`  datetime     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`fabric_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COMMENT='面料列表';

-- ----------------------------
-- 7. 面料SKU表（颜色属性）
-- ----------------------------
DROP TABLE IF EXISTS `t_fabric_sku`;
CREATE TABLE `t_fabric_sku` (
  `sku_id`       bigint       NOT NULL AUTO_INCREMENT COMMENT 'SKU ID',
  `fabric_id`    bigint       NOT NULL COMMENT '面料ID',
  `color_name`   varchar(50)  DEFAULT NULL COMMENT '颜色名称',
  `color_code`   varchar(20)  DEFAULT NULL COMMENT '颜色编码',
  `sku_no`       varchar(50)  DEFAULT NULL COMMENT 'SKU编号',
  `price`        decimal(10,2) DEFAULT NULL COMMENT '价格',
  `image_url`    varchar(500) DEFAULT NULL COMMENT '图片地址',
  `deleted_flag` tinyint      NOT NULL DEFAULT 0 COMMENT '删除标识',
  `create_time`  datetime     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time`  datetime     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`sku_id`),
  KEY `idx_fabric_id` (`fabric_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COMMENT='面料SKU（颜色属性）';

INSERT INTO `t_fabric` VALUES (1,'棉1X1罗纹食毛','ML152101','针织',NULL,1,'米',200.00,150.00,0,0,'主面料','2024-01-01 09:00:00','2024-01-01 09:00:00');
INSERT INTO `t_fabric` VALUES (2,'纯棉平纹布','ML152102','梭织',NULL,1,'米',180.00,140.00,0,0,NULL,'2024-01-01 09:00:00','2024-01-01 09:00:00');
INSERT INTO `t_fabric_sku` VALUES (1,1,'米白','MW001','ML152101-MW001',25.00,NULL,0,'2024-01-01 09:00:00','2024-01-01 09:00:00');
INSERT INTO `t_fabric_sku` VALUES (2,1,'黑色','HE001','ML152101-HE001',25.00,NULL,0,'2024-01-01 09:00:00','2024-01-01 09:00:00');

-- ----------------------------
-- 8. 成衣表
-- ----------------------------
DROP TABLE IF EXISTS `t_garment`;
CREATE TABLE `t_garment` (
  `garment_id`   bigint       NOT NULL AUTO_INCREMENT COMMENT '成衣ID',
  `garment_name` varchar(200) NOT NULL COMMENT '物料名称',
  `garment_no`   varchar(50)  DEFAULT NULL COMMENT '物料编号',
  `garment_type` varchar(50)  DEFAULT NULL COMMENT '成衣类型（上衣/裤子/裙子等）',
  `spec`         varchar(100) DEFAULT NULL COMMENT '规格型号',
  `unit_id`      bigint       DEFAULT NULL COMMENT '单位ID',
  `unit_name`    varchar(50)  DEFAULT NULL COMMENT '单位名称',
  `price`        decimal(10,2) DEFAULT NULL COMMENT '价格',
  `disabled_flag` tinyint     NOT NULL DEFAULT 0 COMMENT '停用标识',
  `deleted_flag` tinyint      NOT NULL DEFAULT 0 COMMENT '删除标识',
  `remark`       varchar(500) DEFAULT NULL COMMENT '备注',
  `create_time`  datetime     NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time`  datetime     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`garment_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COMMENT='成衣列表';

-- ----------------------------
-- 9. 成衣SKU表（颜色+尺码属性）
-- ----------------------------
DROP TABLE IF EXISTS `t_garment_sku`;
CREATE TABLE `t_garment_sku` (
  `sku_id`       bigint       NOT NULL AUTO_INCREMENT COMMENT 'SKU ID',
  `garment_id`   bigint       NOT NULL COMMENT '成衣ID',
  `color_name`   varchar(50)  DEFAULT NULL COMMENT '颜色名称',
  `color_code`   varchar(20)  DEFAULT NULL COMMENT '颜色编码',
  `size_name`    varchar(20)  DEFAULT NULL COMMENT '尺码名称',
  `sku_no`       varchar(50)  DEFAULT NULL COMMENT 'SKU编号',
  `price`        decimal(10,2) DEFAULT NULL COMMENT '价格',
  `deleted_flag` tinyint      NOT NULL DEFAULT 0 COMMENT '删除标识',
  `create_time`  datetime     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time`  datetime     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`sku_id`),
  KEY `idx_garment_id` (`garment_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COMMENT='成衣SKU（颜色+尺码）';

-- ----------------------------
-- 10. 生产指令单（制单）表
-- ----------------------------
DROP TABLE IF EXISTS `t_production_order`;
CREATE TABLE `t_production_order` (
  `order_id`       bigint       NOT NULL AUTO_INCREMENT COMMENT '指令单ID',
  `order_no`       varchar(30)  NOT NULL COMMENT '单据编号（如SC202601210002）',
  `customer_id`    bigint       DEFAULT NULL COMMENT '客户ID',
  `customer_name`  varchar(100) DEFAULT NULL COMMENT '客户名称',
  `style_no`       varchar(50)  DEFAULT NULL COMMENT '款号',
  `style_name`     varchar(100) DEFAULT NULL COMMENT '款名',
  `delivery_date`  date         DEFAULT NULL COMMENT '交货日期',
  `unit_price`     decimal(10,2) DEFAULT NULL COMMENT '单价',
  `order_quantity` int          DEFAULT 0 COMMENT '下单数量',
  `finish_quantity` int         DEFAULT 0 COMMENT '完成数量',
  `status`         tinyint      NOT NULL DEFAULT 1 COMMENT '生产状态:1-计划,2-下达,3-完工',
  `issue_date`     datetime     DEFAULT NULL COMMENT '下达日期',
  `deleted_flag`   tinyint      NOT NULL DEFAULT 0 COMMENT '删除标识',
  `remark`         varchar(500) DEFAULT NULL COMMENT '备注',
  `create_user_id`   bigint     DEFAULT NULL COMMENT '创建人ID',
  `create_user_name` varchar(50) DEFAULT NULL COMMENT '创建人姓名',
  `create_time`    datetime     NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time`    datetime     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`order_id`),
  UNIQUE KEY `uk_order_no` (`order_no`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COMMENT='生产指令单';

-- ----------------------------
-- 11. 指令单颜色尺码明细表
-- ----------------------------
DROP TABLE IF EXISTS `t_production_order_detail`;
CREATE TABLE `t_production_order_detail` (
  `detail_id`    bigint       NOT NULL AUTO_INCREMENT COMMENT '明细ID',
  `order_id`     bigint       NOT NULL COMMENT '指令单ID',
  `color_name`   varchar(50)  DEFAULT NULL COMMENT '颜色名称',
  `size_name`    varchar(20)  DEFAULT NULL COMMENT '尺码名称',
  `quantity`     int          DEFAULT 0 COMMENT '数量',
  `deleted_flag` tinyint      NOT NULL DEFAULT 0 COMMENT '删除标识',
  `create_time`  datetime     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time`  datetime     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`detail_id`),
  KEY `idx_order_id` (`order_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COMMENT='指令单颜色尺码明细';

-- ----------------------------
-- 12. 指令单面料信息表
-- ----------------------------
DROP TABLE IF EXISTS `t_production_order_fabric`;
CREATE TABLE `t_production_order_fabric` (
  `id`           bigint       NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `order_id`     bigint       NOT NULL COMMENT '指令单ID',
  `fabric_id`    bigint       DEFAULT NULL COMMENT '面料ID',
  `fabric_no`    varchar(50)  DEFAULT NULL COMMENT '面料编号',
  `fabric_name`  varchar(200) DEFAULT NULL COMMENT '面料名称',
  `color_name`   varchar(50)  DEFAULT NULL COMMENT '颜色/规格',
  `deleted_flag` tinyint      NOT NULL DEFAULT 0 COMMENT '删除标识',
  `create_time`  datetime     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time`  datetime     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_order_id` (`order_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COMMENT='指令单面料信息';

-- ----------------------------
-- 13. 生产流程工序节点表
-- ----------------------------
DROP TABLE IF EXISTS `t_production_process`;
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
  `deleted_flag`      tinyint      NOT NULL DEFAULT 0 COMMENT '删除标识',
  `create_time`       datetime     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time`       datetime     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`process_id`),
  KEY `idx_order_id` (`order_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COMMENT='生产流程工序';

-- ----------------------------
-- 14. 松布任务表
-- ----------------------------
DROP TABLE IF EXISTS `t_fabric_relax`;
CREATE TABLE `t_fabric_relax` (
  `relax_id`       bigint       NOT NULL AUTO_INCREMENT COMMENT '松布任务ID',
  `order_id`       bigint       DEFAULT NULL COMMENT '指令单ID',
  `order_no`       varchar(30)  DEFAULT NULL COMMENT '指令单编号',
  `fabric_id`      bigint       DEFAULT NULL COMMENT '面料ID',
  `fabric_no`      varchar(50)  DEFAULT NULL COMMENT '面料编号',
  `fabric_name`    varchar(200) DEFAULT NULL COMMENT '面料名称',
  `color_name`     varchar(50)  DEFAULT NULL COMMENT '颜色',
  `require_length` decimal(10,2) DEFAULT NULL COMMENT '需求长度(米)',
  `actual_length`  decimal(10,2) DEFAULT NULL COMMENT '实际长度(米)',
  `relax_hours`    decimal(5,1) DEFAULT NULL COMMENT '松布时长(小时)',
  `status`         tinyint      NOT NULL DEFAULT 0 COMMENT '状态:0-计划,1-进行中,2-完成',
  `deleted_flag`   tinyint      NOT NULL DEFAULT 0 COMMENT '删除标识',
  `remark`         varchar(500) DEFAULT NULL COMMENT '备注',
  `create_user_id`   bigint     DEFAULT NULL COMMENT '创建人ID',
  `create_user_name` varchar(50) DEFAULT NULL COMMENT '创建人姓名',
  `create_time`    datetime     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time`    datetime     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`relax_id`),
  KEY `idx_order_id` (`order_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COMMENT='松布任务';

-- ----------------------------
-- 15. 铺布任务表
-- ----------------------------
DROP TABLE IF EXISTS `t_fabric_spread`;
CREATE TABLE `t_fabric_spread` (
  `spread_id`       bigint       NOT NULL AUTO_INCREMENT COMMENT '铺布任务ID',
  `order_id`        bigint       NOT NULL COMMENT '指令单ID',
  `order_no`        varchar(30)  DEFAULT NULL COMMENT '指令单编号',
  `fabric_id`       bigint       DEFAULT NULL COMMENT '面料ID',
  `fabric_no`       varchar(50)  DEFAULT NULL COMMENT '面料编号',
  `fabric_name`     varchar(200) DEFAULT NULL COMMENT '面料名称',
  `color_name`      varchar(50)  DEFAULT NULL COMMENT '颜色',
  `require_layers`  int          DEFAULT NULL COMMENT '要求铺布层数',
  `require_length`  decimal(10,2) DEFAULT NULL COMMENT '要求铺布总长度(米)',
  `actual_layers`   int          DEFAULT NULL COMMENT '实际铺布层数',
  `actual_length`   decimal(10,2) DEFAULT NULL COMMENT '实际铺布总长度(米)',
  `status`          tinyint      NOT NULL DEFAULT 0 COMMENT '状态:0-待作业,1-进行中,2-已完成',
  `issued_flag`     tinyint      NOT NULL DEFAULT 0 COMMENT '是否已下发:0-否,1-是',
  `deleted_flag`    tinyint      NOT NULL DEFAULT 0 COMMENT '删除标识',
  `remark`          varchar(500) DEFAULT NULL COMMENT '备注',
  `create_user_id`   bigint      DEFAULT NULL COMMENT '创建人ID',
  `create_user_name` varchar(50) DEFAULT NULL COMMENT '创建人姓名',
  `create_time`     datetime     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time`     datetime     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`spread_id`),
  KEY `idx_order_id` (`order_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COMMENT='铺布任务';

-- ----------------------------
-- 16. 裁剪计划表
-- ----------------------------
DROP TABLE IF EXISTS `t_cutting_plan`;
CREATE TABLE `t_cutting_plan` (
  `plan_id`        bigint       NOT NULL AUTO_INCREMENT COMMENT '裁剪计划ID',
  `plan_no`        varchar(30)  NOT NULL COMMENT '计划编号（如CP20260101001）',
  `order_id`       bigint       DEFAULT NULL COMMENT '指令单ID',
  `order_no`       varchar(30)  DEFAULT NULL COMMENT '指令单编号',
  `customer_name`  varchar(100) DEFAULT NULL COMMENT '客户名称',
  `style_no`       varchar(50)  DEFAULT NULL COMMENT '款号',
  `style_name`     varchar(100) DEFAULT NULL COMMENT '款名',
  `plan_date`      date         DEFAULT NULL COMMENT '计划裁剪日期',
  `plan_quantity`  int          DEFAULT 0 COMMENT '计划数量',
  `actual_quantity` int         DEFAULT 0 COMMENT '实际数量',
  `status`         tinyint      NOT NULL DEFAULT 0 COMMENT '状态:0-计划,1-进行中,2-完成',
  `deleted_flag`   tinyint      NOT NULL DEFAULT 0 COMMENT '删除标识',
  `remark`         varchar(500) DEFAULT NULL COMMENT '备注',
  `create_user_id`   bigint     DEFAULT NULL COMMENT '创建人ID',
  `create_user_name` varchar(50) DEFAULT NULL COMMENT '创建人姓名',
  `create_time`    datetime     NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time`    datetime     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`plan_id`),
  UNIQUE KEY `uk_plan_no` (`plan_no`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COMMENT='裁剪计划';

-- ----------------------------
-- 17. 裁床单表
-- ----------------------------
DROP TABLE IF EXISTS `t_cutting_order`;
CREATE TABLE `t_cutting_order` (
  `cutting_order_id`  bigint       NOT NULL AUTO_INCREMENT COMMENT '裁床单ID',
  `cutting_order_no`  varchar(30)  NOT NULL COMMENT '裁床单编号（如CO20260101001）',
  `plan_id`           bigint       DEFAULT NULL COMMENT '裁剪计划ID',
  `plan_no`           varchar(30)  DEFAULT NULL COMMENT '裁剪计划编号',
  `order_id`          bigint       DEFAULT NULL COMMENT '指令单ID',
  `order_no`          varchar(30)  DEFAULT NULL COMMENT '指令单编号',
  `customer_name`     varchar(100) DEFAULT NULL COMMENT '客户名称',
  `style_no`          varchar(50)  DEFAULT NULL COMMENT '款号',
  `style_name`        varchar(100) DEFAULT NULL COMMENT '款名',
  `color_name`        varchar(50)  DEFAULT NULL COMMENT '颜色',
  `size_name`         varchar(20)  DEFAULT NULL COMMENT '尺码',
  `quantity`          int          DEFAULT 0 COMMENT '裁剪数量',
  `bed_no`            varchar(50)  DEFAULT NULL COMMENT '裁床编号',
  `layers`            int          DEFAULT NULL COMMENT '铺布层数',
  `fabric_no`         varchar(50)  DEFAULT NULL COMMENT '面料编号',
  `fabric_name`       varchar(200) DEFAULT NULL COMMENT '面料名称',
  `status`            tinyint      NOT NULL DEFAULT 0 COMMENT '状态:0-待裁,1-裁剪中,2-完成',
  `deleted_flag`      tinyint      NOT NULL DEFAULT 0 COMMENT '删除标识',
  `remark`            varchar(500) DEFAULT NULL COMMENT '备注',
  `create_user_id`    bigint       DEFAULT NULL COMMENT '创建人ID',
  `create_user_name`  varchar(50)  DEFAULT NULL COMMENT '创建人姓名',
  `create_time`       datetime     NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time`       datetime     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`cutting_order_id`),
  UNIQUE KEY `uk_cutting_order_no` (`cutting_order_no`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COMMENT='裁床单';

-- ----------------------------
-- 18. 菜单数据（服装裁剪系统菜单）
-- 删除所有SmartAdmin默认菜单，只保留本系统业务菜单
-- menu_type: 1=目录, 2=菜单, 3=按钮
-- ----------------------------

-- 清空所有旧菜单及角色菜单关联
DELETE FROM `t_role_menu`;
DELETE FROM `t_menu`;

-- 重置自增（如有需要）
ALTER TABLE `t_menu` AUTO_INCREMENT = 10001;

INSERT INTO `t_menu` (`menu_id`,`menu_name`,`menu_type`,`parent_id`,`sort`,`path`,`component`,`perms_type`,`api_perms`,`web_perms`,`icon`,`context_menu_id`,`frame_flag`,`frame_url`,`cache_flag`,`visible_flag`,`disabled_flag`,`deleted_flag`,`create_user_id`,`create_time`,`update_user_id`,`update_time`)
VALUES
-- ===================== 生产管理 =====================
(10001,'生产管理',1,0,1,'/production','NULL',NULL,NULL,NULL,'ToolOutlined',NULL,0,NULL,0,1,0,0,1,NOW(),1,NOW()),
(10002,'生产制单',2,10001,1,'/production/order','business/cutting/production/order/order-list',NULL,NULL,NULL,'FileTextOutlined',NULL,0,NULL,1,1,0,0,1,NOW(),1,NOW()),

-- ===================== 裁剪数据 =====================
(10003,'裁剪数据',1,0,2,'/cutting',NULL,NULL,NULL,NULL,'ScissorOutlined',NULL,0,NULL,0,1,0,0,1,NOW(),1,NOW()),
(10004,'裁剪计划',2,10003,1,'/cutting/plan','business/cutting/cutting-plan/cutting-plan-list',NULL,NULL,NULL,'CalendarOutlined',NULL,0,NULL,1,1,0,0,1,NOW(),1,NOW()),
(10005,'裁床单列表',2,10003,2,'/cutting/order','business/cutting/cutting-order/cutting-order-list',NULL,NULL,NULL,'OrderedListOutlined',NULL,0,NULL,1,1,0,0,1,NOW(),1,NOW()),

-- ===================== 松布管理 =====================
(10006,'松布管理',1,0,3,'/relax',NULL,NULL,NULL,NULL,'ExpandOutlined',NULL,0,NULL,0,1,0,0,1,NOW(),1,NOW()),
(10007,'松布计划',2,10006,1,'/relax/plan','business/cutting/relax/relax-plan-list',NULL,NULL,NULL,'ProfileOutlined',NULL,0,NULL,1,1,0,0,1,NOW(),1,NOW()),
(10008,'松布任务',2,10006,2,'/relax/task','business/cutting/relax/relax-task-list',NULL,NULL,NULL,'UnorderedListOutlined',NULL,0,NULL,1,1,0,0,1,NOW(),1,NOW()),
(10009,'松布仪表盘',2,10006,3,'/relax/dashboard','business/cutting/relax/relax-dashboard',NULL,NULL,NULL,'DashboardOutlined',NULL,0,NULL,1,1,0,0,1,NOW(),1,NOW()),

-- ===================== 铺布管理 =====================
(10010,'铺布管理',1,0,4,'/spread',NULL,NULL,NULL,NULL,'AppstoreOutlined',NULL,0,NULL,0,1,0,0,1,NOW(),1,NOW()),
(10011,'铺布仪表盘',2,10010,1,'/spread/dashboard','business/cutting/spread/spread-dashboard',NULL,NULL,NULL,'DashboardOutlined',NULL,0,NULL,1,1,0,0,1,NOW(),1,NOW()),
(10012,'铺布任务',2,10010,2,'/spread/task','business/cutting/spread/spread-task-list',NULL,NULL,NULL,'UnorderedListOutlined',NULL,0,NULL,1,1,0,0,1,NOW(),1,NOW()),
(10013,'铺布工作台',2,10010,3,'/spread/workbench','business/cutting/spread/spread-workbench',NULL,NULL,NULL,'DesktopOutlined',NULL,0,NULL,1,1,0,0,1,NOW(),1,NOW()),

-- ===================== 物料管理 =====================
(10014,'物料管理',1,0,5,'/material',NULL,NULL,NULL,NULL,'DatabaseOutlined',NULL,0,NULL,0,1,0,0,1,NOW(),1,NOW()),
(10015,'成衣列表',2,10014,1,'/material/garment','business/cutting/basic/garment/garment-list',NULL,NULL,NULL,'ShoppingOutlined',NULL,0,NULL,1,1,0,0,1,NOW(),1,NOW()),
(10016,'面料列表',2,10014,2,'/material/fabric','business/cutting/basic/fabric/fabric-list',NULL,NULL,NULL,'TagOutlined',NULL,0,NULL,1,1,0,0,1,NOW(),1,NOW()),

-- ===================== 基础管理 =====================
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

select * from t_customer