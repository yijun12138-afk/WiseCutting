package net.lab1024.sa.admin.module.business.basic.garment.domain.form;

import lombok.Data;
import java.math.BigDecimal;

@Data
public class GarmentSkuForm {
    private Long skuId;
    private String colorName;
    private String colorCode;
    private String sizeName;
    private String skuNo;
    private BigDecimal price;
}
