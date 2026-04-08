package net.lab1024.sa.admin.module.business.basic.fabric.domain.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * 面料SKU 实体类
 */
@Data
@TableName("t_fabric_sku")
public class FabricSkuEntity {

    @TableId(type = IdType.AUTO)
    private Long skuId;

    private Long fabricId;
    private String colorName;
    private String colorCode;
    private String skuNo;
    private BigDecimal price;
    private String imageUrl;
    private Boolean deletedFlag;

    private LocalDateTime createTime;
    private LocalDateTime updateTime;
}
