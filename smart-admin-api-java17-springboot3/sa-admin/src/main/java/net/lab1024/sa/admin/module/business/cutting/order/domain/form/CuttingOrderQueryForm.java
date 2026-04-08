package net.lab1024.sa.admin.module.business.cutting.order.domain.form;

import lombok.Data;
import net.lab1024.sa.base.common.domain.PageParam;

@Data
public class CuttingOrderQueryForm extends PageParam {
    private String cuttingOrderNo;
    private String orderNo;
    private Integer status;
    private Boolean deletedFlag;
}
