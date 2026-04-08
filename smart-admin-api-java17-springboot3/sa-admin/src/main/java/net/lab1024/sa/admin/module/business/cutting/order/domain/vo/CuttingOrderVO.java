package net.lab1024.sa.admin.module.business.cutting.order.domain.vo;

import lombok.Data;
import java.time.LocalDateTime;

@Data
public class CuttingOrderVO {
    private Long cuttingOrderId;
    private String cuttingOrderNo;
    private Long planId;
    private String planNo;
    private Long orderId;
    private String orderNo;
    private String customerName;
    private String styleNo;
    private String styleName;
    private String colorName;
    private String sizeName;
    private Integer quantity;
    private String bedNo;
    private Integer layers;
    private String fabricNo;
    private String fabricName;
    private Integer status;
    private String statusName;
    private String remark;
    private String createUserName;
    private LocalDateTime createTime;
}
