package net.lab1024.sa.admin.module.business.production.order.domain.form;

import lombok.Data;
import net.lab1024.sa.base.common.domain.PageParam;

@Data
public class ProductionOrderQueryForm extends PageParam {
    private String orderNo;
    private String styleNo;
    private String customerName;
    private Integer status;
    private Boolean deletedFlag;
}