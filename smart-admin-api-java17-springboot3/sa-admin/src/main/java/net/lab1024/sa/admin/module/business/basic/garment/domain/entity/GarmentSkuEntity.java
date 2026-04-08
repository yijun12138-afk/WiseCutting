package net.lab1024.sa.admin.module.business.basic.garment.domain.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * 成衣SKU 实体类
 */
@Data
@TableName("t_garment_sku")
public class GarmentSkuEntity {

    @TableId(type = IdType.AUTO)
    private Long skuId;

    private Long garmentId;
    private String colorName;
    private String colorCode;
    private String sizeName;
    private String skuNo;
    private BigDecimal price;
    private Boolean deletedFlag;

    private LocalDateTime createTime;
    private LocalDateTime updateTime;
}
