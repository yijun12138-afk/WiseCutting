package net.lab1024.sa.admin.module.business.production.spread.domain.vo;

import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
public class FabricSpreadVO {
    private Long spreadId;
    private Long orderId;
    private String orderNo;
    private Long fabricId;
    private String fabricNo;
    private String fabricName;
    private String colorName;
    private Integer requireLayers;
    private BigDecimal requireLength;
    private Integer actualLayers;
    private BigDecimal actualLength;
    private Integer status;
    private String statusName;
    private Boolean issuedFlag;
    private String remark;
    private String createUserName;
    private LocalDateTime createTime;
}
