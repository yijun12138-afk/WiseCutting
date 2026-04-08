package net.lab1024.sa.admin.module.business.production.order.domain.vo;

import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

@Data
public class ProductionOrderVO {
    private Long orderId;
    private String orderNo;
    private Long customerId;
    private String customerName;
    private String styleNo;
    private String styleName;
    private LocalDate deliveryDate;
    private BigDecimal unitPrice;
    private Integer orderQuantity;
    private Integer finishQuantity;
    private Integer status;
    private String statusName;
    private LocalDateTime issueDate;
    private String remark;
    private String createUserName;
    private LocalDateTime createTime;

    private List<OrderDetailVO> detailList;
    private List<OrderFabricVO> fabricList;
    private List<OrderProcessVO> processList;
}
