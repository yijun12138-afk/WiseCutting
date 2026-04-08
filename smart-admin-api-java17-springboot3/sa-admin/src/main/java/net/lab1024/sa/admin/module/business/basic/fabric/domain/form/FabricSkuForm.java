package net.lab1024.sa.admin.module.business.basic.fabric.domain.form;

import lombok.Data;
import java.math.BigDecimal;

@Data
public class FabricSkuForm {
    private Long skuId;
    private String colorName;
    private String colorCode;
    private String skuNo;
    private BigDecimal price;
    private String imageUrl;
}
