package net.lab1024.sa.admin.module.business.production.order.domain.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

/**
 * 生产指令单 实体类
 */
@Data
@TableName("t_production_order")
public class ProductionOrderEntity {

    @TableId(type = IdType.AUTO)
    private Long orderId;

    /** 单据编号 */
    private String orderNo;

    /** 客户ID */
    private Long customerId;

    /** 客户名称 */
    private String customerName;

    /** 款号 */
    private String styleNo;

    /** 款名 */
    private String styleName;

    /** 交货日期 */
    private LocalDate deliveryDate;

    /** 单价 */
    private BigDecimal unitPrice;

    /** 下单数量 */
    private Integer orderQuantity;

    /** 完成数量 */
    private Integer finishQuantity;

    /**
     * 生产状态: 1-计划, 2-下达, 3-完工
     */
    private Integer status;

    /** 下达日期 */
    private LocalDateTime issueDate;

    /** 删除标识 */
    private Boolean deletedFlag;

    /** 备注 */
    private String remark;

    private Long createUserId;
    private String createUserName;

    private LocalDateTime createTime;
    private LocalDateTime updateTime;
}
