package net.lab1024.sa.admin.module.business.basic.fabric.domain.form;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotBlank;
import lombok.Data;
import java.math.BigDecimal;
import java.util.List;

@Data
public class FabricAddForm {
    private Long fabricId;

    @NotBlank(message = "面料名称不能为空")
    private String fabricName;

    private String fabricNo;
    private String fabricType;
    private String spec;
    private Long unitId;
    private String unitName;
    private BigDecimal gramWeight;
    private BigDecimal width;
    private Boolean disabledFlag;
    private String remark;

    @Schema(description = "SKU列表（颜色属性）")
    private List<FabricSkuForm> skuList;
}
