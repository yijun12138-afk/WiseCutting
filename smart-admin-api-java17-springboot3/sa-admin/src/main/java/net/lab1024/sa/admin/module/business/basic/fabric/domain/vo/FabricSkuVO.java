package net.lab1024.sa.admin.module.business.basic.fabric.domain.vo;

import lombok.Data;
import java.math.BigDecimal;

@Data
public class FabricSkuVO {
    private Long skuId;
    private Long fabricId;
    private String colorName;
    private String colorCode;
    private String skuNo;
    private BigDecimal price;
    private String imageUrl;
}
