package net.lab1024.sa.admin.module.business.production.order.domain.vo;

import lombok.Data;

@Data
public class OrderFabricVO {
    private Long id;
    private Long orderId;
    private Long fabricId;
    private String fabricNo;
    private String fabricName;
    private String colorName;
}
