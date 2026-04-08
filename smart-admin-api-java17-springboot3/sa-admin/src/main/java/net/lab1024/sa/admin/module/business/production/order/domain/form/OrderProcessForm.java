package net.lab1024.sa.admin.module.business.production.order.domain.form;

import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
public class OrderProcessForm {
    private Long processId;
    private Integer seqNo;
    private String nodeName;
    private String principal;
    private BigDecimal durationHours;
    private LocalDateTime planStartTime;
    private LocalDateTime planEndTime;
}
