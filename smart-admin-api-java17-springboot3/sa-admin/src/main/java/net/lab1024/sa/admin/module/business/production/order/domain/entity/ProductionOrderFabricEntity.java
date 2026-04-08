package net.lab1024.sa.admin.module.business.production.order.domain.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import java.time.LocalDateTime;

/**
 * 指令单面料信息 实体类
 */
@Data
@TableName("t_production_order_fabric")
public class ProductionOrderFabricEntity {

    @TableId(type = IdType.AUTO)
    private Long id;
    private Long orderId;
    private Long fabricId;
    private String fabricNo;
    private String fabricName;
    private String colorName;
    private Boolean deletedFlag;
    private LocalDateTime createTime;
    private LocalDateTime updateTime;
}
