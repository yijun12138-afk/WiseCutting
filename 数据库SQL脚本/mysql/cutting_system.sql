-- =====================================================
-- 服装裁剪管理系统 - 业务数据库建表脚本
-- 数据库: smart_admin_v3
-- 说明: 每次执行会先删除旧表/旧数据，再重建并插入最新测试数据
-- =====================================================
USE `smart_admin_v3`;

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- =====================================================
-- 按依赖顺序删除旧业务表（子表先删）
-- =====================================================
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
DROP TABLE IF EXISTS `t_size`;
DROP TABLE IF EXISTS `t_style_color`;
DROP TABLE IF EXISTS `t_customer`;

-- =====================================================
-- 1. 客户管理表
-- =====================================================
CREATE TABLE `t_customer` (
  `customer_id`    bigint       NOT NULL AUTO_INCREMENT COMMENT '客户ID',
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

INSERT INTO `t_customer` (`customer_id`,`customer_name`,`company_name`,`contact_person`,`phone`,`level`,`disabled_flag`,`deleted_flag`,`remark`,`create_time`,`update_time`) VALUES
(1,'元一','元一服装有限公司','张经理','13800138001','A',0,0,'VIP客户，长期合作','2024-01-01 09:00:00','2024-01-01 09:00:00'),
(2,'美诺','美诺贸易公司','李总','13900139002','B',0,0,'稳定合作客户','2024-01-01 09:00:00','2024-01-01 09:00:00'),
(3,'鑫达','鑫达纺织集团','王主任','13700137003','A',0,0,'长期合作，优先供货','2024-01-01 09:00:00','2024-01-01 09:00:00'),
(4,'恒通','恒通服饰有限公司','陈总监','13600136004','C',0,0,'新客户','2024-03-01 09:00:00','2024-03-01 09:00:00'),
(5,'锦华','锦华时装集团','赵经理','13500135005','B',1,0,'已停用','2024-02-01 09:00:00','2024-06-01 09:00:00');

-- =====================================================
-- 2. 款式颜色表
-- =====================================================
CREATE TABLE `t_style_color` (
  `color_id`         bigint       NOT NULL AUTO_INCREMENT COMMENT '颜色ID',
  `style_no`         varchar(50)  DEFAULT NULL COMMENT '款号',
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

INSERT INTO `t_style_color` (`color_id`,`style_no`,`color_name`,`color_code`,`deleted_flag`,`remark`,`create_user_id`,`create_user_name`,`create_time`,`update_time`) VALUES
(1,'YY001','米白','MW001',0,NULL,1,'管理员','2024-01-01 09:00:00','2024-01-01 09:00:00'),
(2,'YY001','黑色','HE001',0,NULL,1,'管理员','2024-01-01 09:00:00','2024-01-01 09:00:00'),
(3,'YY002','藏蓝','ZL001',0,NULL,1,'管理员','2024-01-01 09:00:00','2024-01-01 09:00:00'),
(4,'YY002','卡其','KQ001',0,NULL,1,'管理员','2024-01-01 09:00:00','2024-01-01 09:00:00'),
(5,'YY003','红色','HS001',0,NULL,1,'管理员','2024-01-01 09:00:00','2024-01-01 09:00:00'),
(6,'YY003','深灰','SH001',0,NULL,1,'管理员','2024-02-01 09:00:00','2024-02-01 09:00:00'),
(7,'YY004','天蓝','TL001',0,NULL,1,'管理员','2024-03-01 09:00:00','2024-03-01 09:00:00');

-- =====================================================
-- 3. 尺寸列表表
-- =====================================================
CREATE TABLE `t_size` (
  `size_id`      bigint       NOT NULL AUTO_INCREMENT COMMENT '尺码ID',
  `size_name`    varchar(20)  NOT NULL COMMENT '尺码名称',
  `sort`         int          NOT NULL DEFAULT 0 COMMENT '排序（升序）',
  `deleted_flag` tinyint      NOT NULL DEFAULT 0 COMMENT '删除标识:0-正常,1-已删除',
  `remark`       varchar(255) DEFAULT NULL COMMENT '备注',
  `create_time`  datetime     NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time`  datetime     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`size_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COMMENT='尺寸列表';

INSERT INTO `t_size` (`size_id`,`size_name`,`sort`,`deleted_flag`,`remark`,`create_time`,`update_time`) VALUES
(1,'XS',1,0,'超小号','2024-01-01 09:00:00','2024-01-01 09:00:00'),
(2,'S',2,0,'小号','2024-01-01 09:00:00','2024-01-01 09:00:00'),
(3,'M',3,0,'中号','2024-01-01 09:00:00','2024-01-01 09:00:00'),
(4,'L',4,0,'大号','2024-01-01 09:00:00','2024-01-01 09:00:00'),
(5,'XL',5,0,'加大号','2024-01-01 09:00:00','2024-01-01 09:00:00'),
(6,'2XL',6,0,'超大号','2024-01-01 09:00:00','2024-01-01 09:00:00'),
(7,'3XL',7,0,'特大号','2024-01-01 09:00:00','2024-01-01 09:00:00');

-- =====================================================
-- 4. 单位管理表
-- =====================================================
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

INSERT INTO `t_unit` (`unit_id`,`unit_name`,`unit_code`,`deleted_flag`,`remark`,`create_user_id`,`create_user_name`,`update_user_id`,`update_user_name`,`create_time`,`update_time`) VALUES
(1,'米','DW000001',0,'布料长度单位',1,'管理员',1,'管理员','2024-01-01 09:00:00','2024-01-01 09:00:00'),
(2,'千克','DW000002',0,'重量单位',1,'管理员',1,'管理员','2024-01-01 09:00:00','2024-01-01 09:00:00'),
(3,'件','DW000003',0,'成衣计件单位',1,'管理员',1,'管理员','2024-01-01 09:00:00','2024-01-01 09:00:00'),
(4,'卷','DW000004',0,'面料卷装单位',1,'管理员',1,'管理员','2024-01-01 09:00:00','2024-01-01 09:00:00'),
(5,'条','DW000005',0,'裤装计件单位',1,'管理员',1,'管理员','2024-01-01 09:00:00','2024-01-01 09:00:00'),
(6,'套','DW000006',0,'套装计件单位',1,'管理员',1,'管理员','2024-01-01 09:00:00','2024-01-01 09:00:00');

-- =====================================================
-- 5. 裁片部位表
-- =====================================================
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

INSERT INTO `t_cutting_part` (`part_id`,`part_name`,`part_code`,`deleted_flag`,`remark`,`create_time`,`update_time`) VALUES
(1,'前片','QP',0,'服装前身部位','2024-01-01 09:00:00','2024-01-01 09:00:00'),
(2,'后片','HP',0,'服装后身部位','2024-01-01 09:00:00','2024-01-01 09:00:00'),
(3,'袖片','XP',0,'袖子部位','2024-01-01 09:00:00','2024-01-01 09:00:00'),
(4,'领片','LP',0,'领子部位','2024-01-01 09:00:00','2024-01-01 09:00:00'),
(5,'腰头','YT',0,'腰部部位','2024-01-01 09:00:00','2024-01-01 09:00:00'),
(6,'口袋','KD',0,'口袋部位','2024-01-01 09:00:00','2024-01-01 09:00:00'),
(7,'裤腿','KT',0,'裤腿部位','2024-01-01 09:00:00','2024-01-01 09:00:00'),
(8,'门襟','MJ',0,'门襟部位','2024-01-01 09:00:00','2024-01-01 09:00:00');

-- =====================================================
-- 6. 面料表
-- =====================================================
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

INSERT INTO `t_fabric` (`fabric_id`,`fabric_name`,`fabric_no`,`fabric_type`,`spec`,`unit_id`,`unit_name`,`gram_weight`,`width`,`disabled_flag`,`deleted_flag`,`remark`,`create_time`,`update_time`) VALUES
(1,'棉1X1罗纹食毛','ML152101','针织','200g/㎡ 150cm',1,'米',200.00,150.00,0,0,'主面料，适合T恤','2024-01-01 09:00:00','2024-01-01 09:00:00'),
(2,'纯棉平纹布','ML152102','梭织','180g/㎡ 140cm',1,'米',180.00,140.00,0,0,'适合衬衫','2024-01-01 09:00:00','2024-01-01 09:00:00'),
(3,'涤纶斜纹布','ML152103','梭织','220g/㎡ 145cm',1,'米',220.00,145.00,0,0,'适合外套','2024-01-01 09:00:00','2024-01-01 09:00:00'),
(4,'氨纶弹力布','ML152104','针织','260g/㎡ 155cm',1,'米',260.00,155.00,0,0,'弹力面料，适合运动服','2024-02-01 09:00:00','2024-02-01 09:00:00'),
(5,'麻棉混纺布','ML152105','梭织','190g/㎡ 148cm',1,'米',190.00,148.00,1,0,'已停用面料','2024-02-01 09:00:00','2024-06-01 09:00:00');

-- =====================================================
-- 7. 面料SKU表（颜色属性）
-- =====================================================
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

INSERT INTO `t_fabric_sku` (`sku_id`,`fabric_id`,`color_name`,`color_code`,`sku_no`,`price`,`image_url`,`deleted_flag`,`create_time`,`update_time`) VALUES
(1,1,'米白','MW001','ML152101-MW001',25.00,NULL,0,'2024-01-01 09:00:00','2024-01-01 09:00:00'),
(2,1,'黑色','HE001','ML152101-HE001',25.00,NULL,0,'2024-01-01 09:00:00','2024-01-01 09:00:00'),
(3,2,'藏蓝','ZL001','ML152102-ZL001',22.00,NULL,0,'2024-01-01 09:00:00','2024-01-01 09:00:00'),
(4,2,'卡其','KQ001','ML152102-KQ001',22.00,NULL,0,'2024-01-01 09:00:00','2024-01-01 09:00:00'),
(5,3,'深灰','SH001','ML152103-SH001',30.00,NULL,0,'2024-01-01 09:00:00','2024-01-01 09:00:00'),
(6,3,'黑色','HE001','ML152103-HE001',30.00,NULL,0,'2024-01-01 09:00:00','2024-01-01 09:00:00'),
(7,4,'天蓝','TL001','ML152104-TL001',35.00,NULL,0,'2024-02-01 09:00:00','2024-02-01 09:00:00'),
(8,4,'红色','HS001','ML152104-HS001',35.00,NULL,0,'2024-02-01 09:00:00','2024-02-01 09:00:00');

-- =====================================================
-- 8. 成衣表
-- =====================================================
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

INSERT INTO `t_garment` (`garment_id`,`garment_name`,`garment_no`,`garment_type`,`spec`,`unit_id`,`unit_name`,`price`,`disabled_flag`,`deleted_flag`,`remark`,`create_time`,`update_time`) VALUES
(1,'棉质圆领T恤','CY001','上衣','S/M/L/XL/2XL',3,'件',89.00,0,0,'经典款基础T恤','2024-01-01 09:00:00','2024-01-01 09:00:00'),
(2,'男款修身衬衫','CY002','上衣','S/M/L/XL',3,'件',129.00,0,0,'商务休闲衬衫','2024-01-01 09:00:00','2024-01-01 09:00:00'),
(3,'休闲直筒裤','CY003','裤子','S/M/L/XL/2XL',5,'条',159.00,0,0,'四季通用款','2024-01-01 09:00:00','2024-01-01 09:00:00'),
(4,'运动卫衣','CY004','上衣','S/M/L/XL/2XL/3XL',3,'件',199.00,0,0,'连帽运动款','2024-02-01 09:00:00','2024-02-01 09:00:00'),
(5,'商务西装外套','CY005','外套','S/M/L/XL',3,'件',599.00,1,0,'已停用款式','2024-02-01 09:00:00','2024-06-01 09:00:00');

-- =====================================================
-- 9. 成衣SKU表（颜色+尺码属性）
-- =====================================================
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

INSERT INTO `t_garment_sku` (`sku_id`,`garment_id`,`color_name`,`color_code`,`size_name`,`sku_no`,`price`,`deleted_flag`,`create_time`,`update_time`) VALUES
-- 棉质圆领T恤（米白、黑色 各S/M/L/XL）
(1,1,'米白','MW001','S','CY001-MW001-S',89.00,0,'2024-01-01 09:00:00','2024-01-01 09:00:00'),
(2,1,'米白','MW001','M','CY001-MW001-M',89.00,0,'2024-01-01 09:00:00','2024-01-01 09:00:00'),
(3,1,'米白','MW001','L','CY001-MW001-L',89.00,0,'2024-01-01 09:00:00','2024-01-01 09:00:00'),
(4,1,'米白','MW001','XL','CY001-MW001-XL',89.00,0,'2024-01-01 09:00:00','2024-01-01 09:00:00'),
(5,1,'黑色','HE001','S','CY001-HE001-S',89.00,0,'2024-01-01 09:00:00','2024-01-01 09:00:00'),
(6,1,'黑色','HE001','M','CY001-HE001-M',89.00,0,'2024-01-01 09:00:00','2024-01-01 09:00:00'),
(7,1,'黑色','HE001','L','CY001-HE001-L',89.00,0,'2024-01-01 09:00:00','2024-01-01 09:00:00'),
(8,1,'黑色','HE001','XL','CY001-HE001-XL',89.00,0,'2024-01-01 09:00:00','2024-01-01 09:00:00'),
-- 男款修身衬衫（藏蓝 M/L/XL）
(9,2,'藏蓝','ZL001','M','CY002-ZL001-M',129.00,0,'2024-01-01 09:00:00','2024-01-01 09:00:00'),
(10,2,'藏蓝','ZL001','L','CY002-ZL001-L',129.00,0,'2024-01-01 09:00:00','2024-01-01 09:00:00'),
(11,2,'藏蓝','ZL001','XL','CY002-ZL001-XL',129.00,0,'2024-01-01 09:00:00','2024-01-01 09:00:00'),
-- 休闲直筒裤（卡其 M/L/XL）
(12,3,'卡其','KQ001','M','CY003-KQ001-M',159.00,0,'2024-01-01 09:00:00','2024-01-01 09:00:00'),
(13,3,'卡其','KQ001','L','CY003-KQ001-L',159.00,0,'2024-01-01 09:00:00','2024-01-01 09:00:00'),
(14,3,'卡其','KQ001','XL','CY003-KQ001-XL',159.00,0,'2024-01-01 09:00:00','2024-01-01 09:00:00');

-- =====================================================
-- 10. 生产指令单（制单）表
-- =====================================================
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

INSERT INTO `t_production_order` (`order_id`,`order_no`,`customer_id`,`customer_name`,`style_no`,`style_name`,`delivery_date`,`unit_price`,`order_quantity`,`finish_quantity`,`status`,`issue_date`,`deleted_flag`,`remark`,`create_user_id`,`create_user_name`,`create_time`,`update_time`) VALUES
(1,'SC202601210001',1,'元一','YY001','棉质圆领T恤','2026-03-01',89.00,500,500,3,'2026-01-21 08:00:00',0,'已完工',1,'管理员','2026-01-21 08:00:00','2026-03-01 18:00:00'),
(2,'SC202601210002',2,'美诺','YY002','男款修身衬衫','2026-04-15',129.00,300,0,2,'2026-01-21 09:00:00',0,'生产中',1,'管理员','2026-01-21 09:00:00','2026-01-21 09:00:00'),
(3,'SC202602150001',3,'鑫达','YY003','休闲直筒裤','2026-05-01',159.00,400,0,2,'2026-02-15 10:00:00',0,'生产中',1,'管理员','2026-02-15 10:00:00','2026-02-15 10:00:00'),
(4,'SC202603010001',1,'元一','YY004','运动卫衣','2026-06-30',199.00,200,0,1,NULL,0,'计划阶段',1,'管理员','2026-03-01 09:00:00','2026-03-01 09:00:00'),
(5,'SC202603200001',4,'恒通','YY001','棉质圆领T恤','2026-07-15',89.00,1000,0,1,NULL,0,'大批量订单',1,'管理员','2026-03-20 09:00:00','2026-03-20 09:00:00');

-- =====================================================
-- 11. 指令单颜色尺码明细表
-- =====================================================
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

INSERT INTO `t_production_order_detail` (`detail_id`,`order_id`,`color_name`,`size_name`,`quantity`,`deleted_flag`,`create_time`,`update_time`) VALUES
-- 指令单1：元一 YY001 500件
(1,1,'米白','S',50,0,'2026-01-21 08:00:00','2026-01-21 08:00:00'),
(2,1,'米白','M',80,0,'2026-01-21 08:00:00','2026-01-21 08:00:00'),
(3,1,'米白','L',100,0,'2026-01-21 08:00:00','2026-01-21 08:00:00'),
(4,1,'米白','XL',70,0,'2026-01-21 08:00:00','2026-01-21 08:00:00'),
(5,1,'黑色','S',50,0,'2026-01-21 08:00:00','2026-01-21 08:00:00'),
(6,1,'黑色','M',80,0,'2026-01-21 08:00:00','2026-01-21 08:00:00'),
(7,1,'黑色','L',50,0,'2026-01-21 08:00:00','2026-01-21 08:00:00'),
(8,1,'黑色','XL',20,0,'2026-01-21 08:00:00','2026-01-21 08:00:00'),
-- 指令单2：美诺 YY002 300件
(9,2,'藏蓝','M',80,0,'2026-01-21 09:00:00','2026-01-21 09:00:00'),
(10,2,'藏蓝','L',120,0,'2026-01-21 09:00:00','2026-01-21 09:00:00'),
(11,2,'藏蓝','XL',60,0,'2026-01-21 09:00:00','2026-01-21 09:00:00'),
(12,2,'卡其','M',20,0,'2026-01-21 09:00:00','2026-01-21 09:00:00'),
(13,2,'卡其','L',10,0,'2026-01-21 09:00:00','2026-01-21 09:00:00'),
(14,2,'卡其','XL',10,0,'2026-01-21 09:00:00','2026-01-21 09:00:00'),
-- 指令单3：鑫达 YY003 400件
(15,3,'卡其','M',100,0,'2026-02-15 10:00:00','2026-02-15 10:00:00'),
(16,3,'卡其','L',150,0,'2026-02-15 10:00:00','2026-02-15 10:00:00'),
(17,3,'卡其','XL',100,0,'2026-02-15 10:00:00','2026-02-15 10:00:00'),
(18,3,'卡其','2XL',50,0,'2026-02-15 10:00:00','2026-02-15 10:00:00'),
-- 指令单4：元一 YY004 200件
(19,4,'天蓝','M',50,0,'2026-03-01 09:00:00','2026-03-01 09:00:00'),
(20,4,'天蓝','L',80,0,'2026-03-01 09:00:00','2026-03-01 09:00:00'),
(21,4,'天蓝','XL',70,0,'2026-03-01 09:00:00','2026-03-01 09:00:00'),
-- 指令单5：恒通 YY001 1000件
(22,5,'米白','M',200,0,'2026-03-20 09:00:00','2026-03-20 09:00:00'),
(23,5,'米白','L',300,0,'2026-03-20 09:00:00','2026-03-20 09:00:00'),
(24,5,'米白','XL',200,0,'2026-03-20 09:00:00','2026-03-20 09:00:00'),
(25,5,'黑色','M',100,0,'2026-03-20 09:00:00','2026-03-20 09:00:00'),
(26,5,'黑色','L',100,0,'2026-03-20 09:00:00','2026-03-20 09:00:00'),
(27,5,'黑色','XL',100,0,'2026-03-20 09:00:00','2026-03-20 09:00:00');

-- =====================================================
-- 12. 指令单面料信息表
-- =====================================================
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

INSERT INTO `t_production_order_fabric` (`id`,`order_id`,`fabric_id`,`fabric_no`,`fabric_name`,`color_name`,`deleted_flag`,`create_time`,`update_time`) VALUES
(1,1,1,'ML152101','棉1X1罗纹食毛','米白',0,'2026-01-21 08:00:00','2026-01-21 08:00:00'),
(2,1,1,'ML152101','棉1X1罗纹食毛','黑色',0,'2026-01-21 08:00:00','2026-01-21 08:00:00'),
(3,2,2,'ML152102','纯棉平纹布','藏蓝',0,'2026-01-21 09:00:00','2026-01-21 09:00:00'),
(4,2,2,'ML152102','纯棉平纹布','卡其',0,'2026-01-21 09:00:00','2026-01-21 09:00:00'),
(5,3,2,'ML152102','纯棉平纹布','卡其',0,'2026-02-15 10:00:00','2026-02-15 10:00:00'),
(6,4,4,'ML152104','氨纶弹力布','天蓝',0,'2026-03-01 09:00:00','2026-03-01 09:00:00'),
(7,5,1,'ML152101','棉1X1罗纹食毛','米白',0,'2026-03-20 09:00:00','2026-03-20 09:00:00'),
(8,5,1,'ML152101','棉1X1罗纹食毛','黑色',0,'2026-03-20 09:00:00','2026-03-20 09:00:00');

-- =====================================================
-- 13. 生产流程工序节点表
-- =====================================================
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

INSERT INTO `t_production_process` (`process_id`,`order_id`,`seq_no`,`node_name`,`principal`,`duration_hours`,`plan_start_time`,`plan_end_time`,`actual_start_time`,`actual_end_time`,`status`,`deleted_flag`,`create_time`,`update_time`) VALUES
-- 指令单1（已完工）全部工序已完成
(1,1,1,'松布','李师傅',8.0,'2026-01-21 08:00:00','2026-01-21 16:00:00','2026-01-21 08:30:00','2026-01-21 16:30:00',2,0,'2026-01-21 08:00:00','2026-01-21 16:30:00'),
(2,1,2,'铺布','王师傅',4.0,'2026-01-22 08:00:00','2026-01-22 12:00:00','2026-01-22 08:00:00','2026-01-22 12:30:00',2,0,'2026-01-21 08:00:00','2026-01-22 12:30:00'),
(3,1,3,'裁剪','张师傅',6.0,'2026-01-22 13:00:00','2026-01-22 19:00:00','2026-01-22 13:00:00','2026-01-22 18:30:00',2,0,'2026-01-21 08:00:00','2026-01-22 18:30:00'),
(4,1,4,'缝制','陈组长',48.0,'2026-01-23 08:00:00','2026-01-25 08:00:00','2026-01-23 08:00:00','2026-01-25 10:00:00',2,0,'2026-01-21 08:00:00','2026-01-25 10:00:00'),
(5,1,5,'质检','质检组',8.0,'2026-01-25 10:00:00','2026-01-25 18:00:00','2026-01-25 10:30:00','2026-01-25 17:00:00',2,0,'2026-01-21 08:00:00','2026-01-25 17:00:00'),
-- 指令单2（生产中）松布铺布已完成，裁剪进行中
(6,2,1,'松布','李师傅',8.0,'2026-01-22 08:00:00','2026-01-22 16:00:00','2026-01-22 08:00:00','2026-01-22 16:00:00',2,0,'2026-01-21 09:00:00','2026-01-22 16:00:00'),
(7,2,2,'铺布','王师傅',4.0,'2026-01-23 08:00:00','2026-01-23 12:00:00','2026-01-23 08:00:00','2026-01-23 13:00:00',2,0,'2026-01-21 09:00:00','2026-01-23 13:00:00'),
(8,2,3,'裁剪','张师傅',6.0,'2026-01-23 14:00:00','2026-01-23 20:00:00','2026-01-23 14:00:00',NULL,1,0,'2026-01-21 09:00:00','2026-01-23 14:00:00'),
(9,2,4,'缝制','陈组长',48.0,'2026-01-24 08:00:00','2026-01-26 08:00:00',NULL,NULL,0,0,'2026-01-21 09:00:00','2026-01-21 09:00:00'),
(10,2,5,'质检','质检组',8.0,'2026-01-26 08:00:00','2026-01-26 16:00:00',NULL,NULL,0,0,'2026-01-21 09:00:00','2026-01-21 09:00:00'),
-- 指令单3（生产中）松布完成，铺布进行中
(11,3,1,'松布','李师傅',10.0,'2026-02-15 08:00:00','2026-02-15 18:00:00','2026-02-15 08:00:00','2026-02-15 18:00:00',2,0,'2026-02-15 10:00:00','2026-02-15 18:00:00'),
(12,3,2,'铺布','王师傅',5.0,'2026-02-16 08:00:00','2026-02-16 13:00:00','2026-02-16 08:30:00',NULL,1,0,'2026-02-15 10:00:00','2026-02-16 08:30:00'),
(13,3,3,'裁剪','张师傅',8.0,'2026-02-16 14:00:00','2026-02-16 22:00:00',NULL,NULL,0,0,'2026-02-15 10:00:00','2026-02-15 10:00:00'),
(14,3,4,'缝制','陈组长',72.0,'2026-02-17 08:00:00','2026-02-20 08:00:00',NULL,NULL,0,0,'2026-02-15 10:00:00','2026-02-15 10:00:00'),
(15,3,5,'质检','质检组',8.0,'2026-02-20 08:00:00','2026-02-20 16:00:00',NULL,NULL,0,0,'2026-02-15 10:00:00','2026-02-15 10:00:00'),
-- 指令单4（计划阶段）工序全部未开始
(16,4,1,'松布','李师傅',8.0,'2026-04-01 08:00:00','2026-04-01 16:00:00',NULL,NULL,0,0,'2026-03-01 09:00:00','2026-03-01 09:00:00'),
(17,4,2,'铺布','王师傅',4.0,'2026-04-02 08:00:00','2026-04-02 12:00:00',NULL,NULL,0,0,'2026-03-01 09:00:00','2026-03-01 09:00:00'),
(18,4,3,'裁剪','张师傅',6.0,'2026-04-02 13:00:00','2026-04-02 19:00:00',NULL,NULL,0,0,'2026-03-01 09:00:00','2026-03-01 09:00:00'),
(19,4,4,'缝制','陈组长',60.0,'2026-04-03 08:00:00','2026-04-05 20:00:00',NULL,NULL,0,0,'2026-03-01 09:00:00','2026-03-01 09:00:00'),
(20,4,5,'质检','质检组',8.0,'2026-04-06 08:00:00','2026-04-06 16:00:00',NULL,NULL,0,0,'2026-03-01 09:00:00','2026-03-01 09:00:00');

-- =====================================================
-- 14. 松布任务表
-- =====================================================
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
  `deleted_flag`     tinyint       NOT NULL DEFAULT 0 COMMENT '删除标识:0-正常,1-已删除',
  `remark`           varchar(500)  DEFAULT NULL COMMENT '备注',
  `create_user_id`   bigint        DEFAULT NULL COMMENT '创建人ID',
  `create_user_name` varchar(50)   DEFAULT NULL COMMENT '创建人姓名',
  `create_time`      datetime      NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time`      datetime      NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`relax_id`),
  KEY `idx_order_id` (`order_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COMMENT='松布任务';

INSERT INTO `t_fabric_relax` (`relax_id`,`order_id`,`order_no`,`fabric_id`,`fabric_no`,`fabric_name`,`color_name`,`require_length`,`actual_length`,`relax_hours`,`relax_time`,`actual_start_time`,`actual_end_time`,`status`,`deleted_flag`,`remark`,`create_user_id`,`create_user_name`,`create_time`,`update_time`) VALUES
-- 指令单1 松布任务（已结束）
(1,1,'SC202601210001',1,'ML152101','棉1X1罗纹食毛','米白',150.00,152.00,8.0,'2026-01-21 08:30:00','2026-01-21 08:30:00','2026-01-21 16:30:00',3,0,'已完成松布',1,'管理员','2026-01-21 08:00:00','2026-01-21 16:30:00'),
(2,1,'SC202601210001',1,'ML152101','棉1X1罗纹食毛','黑色',120.00,121.50,8.0,'2026-01-21 09:00:00','2026-01-21 09:00:00','2026-01-21 17:00:00',3,0,'已完成松布',1,'管理员','2026-01-21 08:00:00','2026-01-21 17:00:00'),
-- 指令单2 松布任务（已结束）
(3,2,'SC202601210002',2,'ML152102','纯棉平纹布','藏蓝',200.00,202.00,8.0,'2026-01-22 08:00:00','2026-01-22 08:00:00','2026-01-22 16:00:00',3,0,'已完成松布',1,'管理员','2026-01-21 09:00:00','2026-01-22 16:00:00'),
(4,2,'SC202601210002',2,'ML152102','纯棉平纹布','卡其',50.00,50.50,8.0,'2026-01-22 08:00:00','2026-01-22 08:00:00','2026-01-22 16:00:00',3,0,'已完成松布',1,'管理员','2026-01-21 09:00:00','2026-01-22 16:00:00'),
-- 指令单3 松布任务（静置完成，等待下一步）
(5,3,'SC202602150001',2,'ML152102','纯棉平纹布','卡其',280.00,282.00,10.0,'2026-02-15 08:00:00','2026-02-15 08:00:00','2026-02-15 18:00:00',2,0,'静置已完成，等待铺布',1,'管理员','2026-02-15 10:00:00','2026-02-15 18:00:00'),
-- 指令单4 松布任务（未开始）
(6,4,'SC202603010001',4,'ML152104','氨纶弹力布','天蓝',130.00,NULL,8.0,NULL,NULL,NULL,0,0,'计划中',1,'管理员','2026-03-01 09:00:00','2026-03-01 09:00:00'),
-- 指令单5 松布任务（进行中）
(7,5,'SC202603200001',1,'ML152101','棉1X1罗纹食毛','米白',400.00,NULL,8.0,'2026-04-09 08:00:00','2026-04-09 08:00:00',NULL,1,0,'正在松布中',1,'管理员','2026-03-20 09:00:00','2026-04-09 08:00:00'),
(8,5,'SC202603200001',1,'ML152101','棉1X1罗纹食毛','黑色',200.00,NULL,8.0,NULL,NULL,NULL,0,0,'等待开始',1,'管理员','2026-03-20 09:00:00','2026-03-20 09:00:00');

-- =====================================================
-- 15. 铺布任务表
-- =====================================================
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

INSERT INTO `t_fabric_spread` (`spread_id`,`order_id`,`order_no`,`fabric_id`,`fabric_no`,`fabric_name`,`color_name`,`require_layers`,`require_length`,`actual_layers`,`actual_length`,`status`,`issued_flag`,`deleted_flag`,`remark`,`create_user_id`,`create_user_name`,`create_time`,`update_time`) VALUES
-- 指令单1 铺布任务（已完成）
(1,1,'SC202601210001',1,'ML152101','棉1X1罗纹食毛','米白',30,150.00,30,152.00,2,1,0,'铺布完成',1,'管理员','2026-01-22 07:00:00','2026-01-22 12:30:00'),
(2,1,'SC202601210001',1,'ML152101','棉1X1罗纹食毛','黑色',25,120.00,25,121.50,2,1,0,'铺布完成',1,'管理员','2026-01-22 07:00:00','2026-01-22 12:30:00'),
-- 指令单2 铺布任务（已完成）
(3,2,'SC202601210002',2,'ML152102','纯棉平纹布','藏蓝',40,200.00,40,202.00,2,1,0,'铺布完成',1,'管理员','2026-01-23 07:00:00','2026-01-23 13:00:00'),
(4,2,'SC202601210002',2,'ML152102','纯棉平纹布','卡其',10,50.00,10,50.50,2,1,0,'铺布完成',1,'管理员','2026-01-23 07:00:00','2026-01-23 13:00:00'),
-- 指令单3 铺布任务（进行中，已下发）
(5,3,'SC202602150001',2,'ML152102','纯棉平纹布','卡其',50,280.00,NULL,NULL,1,1,0,'铺布进行中',1,'管理员','2026-02-16 07:00:00','2026-02-16 08:30:00'),
-- 指令单4 铺布任务（待作业，未下发）
(6,4,'SC202603010001',4,'ML152104','氨纶弹力布','天蓝',30,130.00,NULL,NULL,0,0,0,'计划中',1,'管理员','2026-03-01 09:00:00','2026-03-01 09:00:00'),
-- 指令单5 铺布任务（待作业，未下发）
(7,5,'SC202603200001',1,'ML152101','棉1X1罗纹食毛','米白',60,400.00,NULL,NULL,0,0,0,'等待松布完成',1,'管理员','2026-03-20 09:00:00','2026-03-20 09:00:00'),
(8,5,'SC202603200001',1,'ML152101','棉1X1罗纹食毛','黑色',30,200.00,NULL,NULL,0,0,0,'等待松布完成',1,'管理员','2026-03-20 09:00:00','2026-03-20 09:00:00');

-- =====================================================
-- 16. 裁剪计划表
-- =====================================================
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

INSERT INTO `t_cutting_plan` (`plan_id`,`plan_no`,`order_id`,`order_no`,`customer_name`,`style_no`,`style_name`,`plan_date`,`plan_quantity`,`actual_quantity`,`status`,`deleted_flag`,`remark`,`create_user_id`,`create_user_name`,`create_time`,`update_time`) VALUES
(1,'CP20260122001',1,'SC202601210001','元一','YY001','棉质圆领T恤','2026-01-22',500,500,2,0,'已完成裁剪',1,'管理员','2026-01-21 18:00:00','2026-01-22 18:30:00'),
(2,'CP20260123001',2,'SC202601210002','美诺','YY002','男款修身衬衫','2026-01-23',300,0,1,0,'裁剪进行中',1,'管理员','2026-01-22 18:00:00','2026-01-23 14:00:00'),
(3,'CP20260216001',3,'SC202602150001','鑫达','YY003','休闲直筒裤','2026-02-17',400,0,0,0,'等待铺布完成',1,'管理员','2026-02-16 09:00:00','2026-02-16 09:00:00'),
(4,'CP20260410001',4,'SC202603010001','元一','YY004','运动卫衣','2026-04-10',200,0,0,0,'计划中',1,'管理员','2026-04-09 09:00:00','2026-04-09 09:00:00'),
(5,'CP20260501001',5,'SC202603200001','恒通','YY001','棉质圆领T恤','2026-05-01',1000,0,0,0,'大批量，需分批裁剪',1,'管理员','2026-04-09 09:00:00','2026-04-09 09:00:00');

-- =====================================================
-- 17. 裁床单表
-- =====================================================
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
  `status`            tinyint       NOT NULL DEFAULT 0 COMMENT '状态:0-待裁,1-裁剪中,2-完成',
  `deleted_flag`      tinyint       NOT NULL DEFAULT 0 COMMENT '删除标识:0-正常,1-已删除',
  `remark`            varchar(500)  DEFAULT NULL COMMENT '备注',
  `create_user_id`    bigint        DEFAULT NULL COMMENT '创建人ID',
  `create_user_name`  varchar(50)   DEFAULT NULL COMMENT '创建人姓名',
  `create_time`       datetime      NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time`       datetime      NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`cutting_order_id`),
  UNIQUE KEY `uk_cutting_order_no` (`cutting_order_no`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COMMENT='裁床单';

INSERT INTO `t_cutting_order` (`cutting_order_id`,`cutting_order_no`,`plan_id`,`plan_no`,`order_id`,`order_no`,`customer_name`,`style_no`,`style_name`,`color_name`,`size_name`,`quantity`,`bed_no`,`layers`,`fabric_no`,`fabric_name`,`status`,`deleted_flag`,`remark`,`create_user_id`,`create_user_name`,`create_time`,`update_time`) VALUES
-- 计划1（已完成）的裁床单
(1,'CO20260122001',1,'CP20260122001',1,'SC202601210001','元一','YY001','棉质圆领T恤','米白','S',50,'A01',30,'ML152101','棉1X1罗纹食毛',2,0,'已完成',1,'管理员','2026-01-22 08:00:00','2026-01-22 18:30:00'),
(2,'CO20260122002',1,'CP20260122001',1,'SC202601210001','元一','YY001','棉质圆领T恤','米白','M',80,'A01',30,'ML152101','棉1X1罗纹食毛',2,0,'已完成',1,'管理员','2026-01-22 08:00:00','2026-01-22 18:30:00'),
(3,'CO20260122003',1,'CP20260122001',1,'SC202601210001','元一','YY001','棉质圆领T恤','米白','L',100,'A02',30,'ML152101','棉1X1罗纹食毛',2,0,'已完成',1,'管理员','2026-01-22 08:00:00','2026-01-22 18:30:00'),
(4,'CO20260122004',1,'CP20260122001',1,'SC202601210001','元一','YY001','棉质圆领T恤','米白','XL',70,'A02',30,'ML152101','棉1X1罗纹食毛',2,0,'已完成',1,'管理员','2026-01-22 08:00:00','2026-01-22 18:30:00'),
(5,'CO20260122005',1,'CP20260122001',1,'SC202601210001','元一','YY001','棉质圆领T恤','黑色','M',80,'B01',25,'ML152101','棉1X1罗纹食毛',2,0,'已完成',1,'管理员','2026-01-22 08:00:00','2026-01-22 18:30:00'),
(6,'CO20260122006',1,'CP20260122001',1,'SC202601210001','元一','YY001','棉质圆领T恤','黑色','L',50,'B01',25,'ML152101','棉1X1罗纹食毛',2,0,'已完成',1,'管理员','2026-01-22 08:00:00','2026-01-22 18:30:00'),
-- 计划2（进行中）的裁床单
(7,'CO20260123001',2,'CP20260123001',2,'SC202601210002','美诺','YY002','男款修身衬衫','藏蓝','M',80,'A01',40,'ML152102','纯棉平纹布',1,0,'裁剪中',1,'管理员','2026-01-23 13:00:00','2026-01-23 14:00:00'),
(8,'CO20260123002',2,'CP20260123001',2,'SC202601210002','美诺','YY002','男款修身衬衫','藏蓝','L',120,'A01',40,'ML152102','纯棉平纹布',0,0,'待裁',1,'管理员','2026-01-23 13:00:00','2026-01-23 13:00:00'),
(9,'CO20260123003',2,'CP20260123001',2,'SC202601210002','美诺','YY002','男款修身衬衫','藏蓝','XL',60,'A02',40,'ML152102','纯棉平纹布',0,0,'待裁',1,'管理员','2026-01-23 13:00:00','2026-01-23 13:00:00'),
-- 计划3（计划阶段）的裁床单
(10,'CO20260217001',3,'CP20260216001',3,'SC202602150001','鑫达','YY003','休闲直筒裤','卡其','M',100,'B02',50,'ML152102','纯棉平纹布',0,0,'等待铺布',1,'管理员','2026-02-16 09:00:00','2026-02-16 09:00:00'),
(11,'CO20260217002',3,'CP20260216001',3,'SC202602150001','鑫达','YY003','休闲直筒裤','卡其','L',150,'B02',50,'ML152102','纯棉平纹布',0,0,'等待铺布',1,'管理员','2026-02-16 09:00:00','2026-02-16 09:00:00'),
(12,'CO20260217003',3,'CP20260216001',3,'SC202602150001','鑫达','YY003','休闲直筒裤','卡其','XL',100,'B02',50,'ML152102','纯棉平纹布',0,0,'等待铺布',1,'管理员','2026-02-16 09:00:00','2026-02-16 09:00:00');

-- =====================================================
-- 18. 菜单数据（服装裁剪系统菜单）
-- 先清空旧菜单及角色菜单关联，再插入最新业务菜单
-- menu_type: 1=目录, 2=菜单, 3=按钮
-- =====================================================
DELETE FROM `t_role_menu`;
DELETE FROM `t_menu`;
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
(10007,'松布仪表盘',2,10006,1,'/relax/dashboard','business/cutting/relax/relax-dashboard',NULL,NULL,NULL,'DashboardOutlined',NULL,0,NULL,1,1,0,0,1,NOW(),1,NOW()),
(10008,'松布计划',2,10006,2,'/relax/plan','business/cutting/relax/relax-plan-list',NULL,NULL,NULL,'ProfileOutlined',NULL,0,NULL,1,1,0,0,1,NOW(),1,NOW()),
(10009,'松布任务',2,10006,3,'/relax/task','business/cutting/relax/relax-task-list',NULL,NULL,NULL,'UnorderedListOutlined',NULL,0,NULL,1,1,0,0,1,NOW(),1,NOW()),

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

-- =====================================================
-- 更新系统基础数据
-- =====================================================
-- 将根部门名称更新为"裁匠实验室"
UPDATE `t_department` SET `department_name` = '裁匠实验室' WHERE `department_id` = 1;
