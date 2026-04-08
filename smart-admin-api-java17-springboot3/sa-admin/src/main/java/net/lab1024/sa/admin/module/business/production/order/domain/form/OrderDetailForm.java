package net.lab1024.sa.admin.module.business.production.order.domain.form;

import lombok.Data;

@Data
public class OrderDetailForm {
    private Long detailId;
    private String colorName;
    private String sizeName;
    private Integer quantity;
}
