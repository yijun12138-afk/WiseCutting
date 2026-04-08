package net.lab1024.sa.admin.module.business.cutting.order.domain.form;

import lombok.Data;

@Data
public class CuttingOrderAddForm {
    private Long cuttingOrderId;
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
    private String remark;
}
