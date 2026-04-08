package net.lab1024.sa.admin.module.business.production.order.domain.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import java.time.LocalDateTime;

/**
 * 指令单颜色尺码明细 实体类
 */
@Data
@TableName("t_production_order_detail")
public class ProductionOrderDetailEntity {

    @TableId(type = IdType.AUTO)
    private Long detailId;
    private Long orderId;
    private String colorName;
    private String sizeName;
    private Integer quantity;
    private Boolean deletedFlag;
    private LocalDateTime createTime;
    private LocalDateTime updateTime;
}
