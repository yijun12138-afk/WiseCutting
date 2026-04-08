package net.lab1024.sa.admin.module.business.production.spread.domain.form;

import jakarta.validation.constraints.NotNull;
import lombok.Data;
import java.math.BigDecimal;

@Data
public class FabricSpreadCompleteForm {
    @NotNull(message = "铺布任务ID不能为空")
    private Long spreadId;
    private Integer actualLayers;
    private BigDecimal actualLength;
}
