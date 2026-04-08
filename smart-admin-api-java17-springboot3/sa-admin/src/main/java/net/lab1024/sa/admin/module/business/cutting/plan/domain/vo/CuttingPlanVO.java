package net.lab1024.sa.admin.module.business.cutting.plan.domain.vo;

import lombok.Data;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Data
public class CuttingPlanVO {
    private Long planId;
    private String planNo;
    private Long orderId;
    private String orderNo;
    private String customerName;
    private String styleNo;
    private String styleName;
    private LocalDate planDate;
    private Integer planQuantity;
    private Integer actualQuantity;
    private Integer status;
    private String statusName;
    private String remark;
    private String createUserName;
    private LocalDateTime createTime;
}
