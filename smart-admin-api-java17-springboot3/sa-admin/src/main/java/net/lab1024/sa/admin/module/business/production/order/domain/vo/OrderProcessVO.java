package net.lab1024.sa.admin.module.business.production.order.domain.vo;

import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
public class OrderProcessVO {
    private Long processId;
    private Long orderId;
    private Integer seqNo;
    private String nodeName;
    private String principal;
    private BigDecimal durationHours;
    private LocalDateTime planStartTime;
    private LocalDateTime planEndTime;
    private LocalDateTime actualStartTime;
    private LocalDateTime actualEndTime;
    private Integer status;
}
