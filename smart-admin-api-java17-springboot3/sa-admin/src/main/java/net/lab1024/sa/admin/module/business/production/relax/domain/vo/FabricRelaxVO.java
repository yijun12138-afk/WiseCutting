package net.lab1024.sa.admin.module.business.production.relax.domain.vo;

import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
public class FabricRelaxVO {
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
    private Integer status;
    private String statusName;
    private String remark;
    private String createUserName;
    private LocalDateTime createTime;
}
