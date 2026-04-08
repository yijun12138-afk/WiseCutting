package net.lab1024.sa.admin.module.business.production.spread.domain.form;

import jakarta.validation.constraints.NotNull;
import lombok.Data;
import java.math.BigDecimal;

@Data
public class FabricSpreadAddForm {
    private Long spreadId;

    @NotNull(message = "指令单不能为空")
    private Long orderId;
    private String orderNo;
    private Long fabricId;
    private String fabricNo;
    private String fabricName;
    private String colorName;
    private Integer requireLayers;
    private BigDecimal requireLength;
    private String remark;
}
