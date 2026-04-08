package net.lab1024.sa.admin.module.business.basic.garment.domain.vo;

import lombok.Data;
import java.math.BigDecimal;

@Data
public class GarmentSkuVO {
    private Long skuId;
    private Long garmentId;
    private String colorName;
    private String colorCode;
    private String sizeName;
    private String skuNo;
    private BigDecimal price;
}
