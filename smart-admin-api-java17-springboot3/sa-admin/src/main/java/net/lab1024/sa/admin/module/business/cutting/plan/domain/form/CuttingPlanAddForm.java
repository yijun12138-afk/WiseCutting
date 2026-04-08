package net.lab1024.sa.admin.module.business.cutting.plan.domain.form;

import jakarta.validation.constraints.NotNull;
import lombok.Data;
import java.time.LocalDate;

@Data
public class CuttingPlanAddForm {
    private Long planId;
    private Long orderId;
    private String orderNo;
    private String customerName;
    private String styleNo;
    private String styleName;
    private LocalDate planDate;
    private Integer planQuantity;
    private Integer actualQuantity;
    private Integer status;
    private String remark;
}
