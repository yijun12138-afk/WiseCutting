package net.lab1024.sa.admin.module.business.production.order.domain.form;

import lombok.Data;

@Data
public class OrderFabricForm {
    private Long id;
    private Long fabricId;
    private String fabricNo;
    private String fabricName;
    private String colorName;
}
