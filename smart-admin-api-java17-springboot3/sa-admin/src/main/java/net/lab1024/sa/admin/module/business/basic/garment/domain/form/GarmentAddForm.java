package net.lab1024.sa.admin.module.business.basic.garment.domain.form;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;
import java.math.BigDecimal;
import java.util.List;

@Data
public class GarmentAddForm {
    private Long garmentId;

    @NotBlank(message = "物料名称不能为空")
    private String garmentName;

    private String garmentNo;
    private String garmentType;
    private String spec;
    private Long unitId;
    private String unitName;
    private BigDecimal price;
    private Boolean disabledFlag;
    private String remark;

    private List<GarmentSkuForm> skuList;
}
