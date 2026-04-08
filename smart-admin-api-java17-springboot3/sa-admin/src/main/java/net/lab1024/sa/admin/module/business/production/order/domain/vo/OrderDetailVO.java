package net.lab1024.sa.admin.module.business.production.order.domain.vo;

import lombok.Data;

@Data
public class OrderDetailVO {
    private Long detailId;
    private Long orderId;
    private String colorName;
    private String sizeName;
    private Integer quantity;
}
