package net.lab1024.sa.admin.module.business.production.relax.domain.form;

import lombok.Data;
import java.math.BigDecimal;

@Data
public class FabricRelaxAddForm {
    private Long relaxId;
    private Long orderId;
    private String orderNo;
    private Long fabricId;
    private String fabricNo;
    private String fabricName;
    private String colorName;
    private BigDecimal requireLength;
    private BigDecimal actualLength;
    private BigDecimal relaxHours;
    private String customerName;
    private java.time.LocalDateTime relaxTime;
    private java.time.LocalDateTime actualStartTime;
    private java.time.LocalDateTime actualEndTime;
    private Integer status;
    private Integer relaxType;
    private String remark;
}
