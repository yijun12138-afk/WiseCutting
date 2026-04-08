package net.lab1024.sa.admin.module.business.cutting.plan.domain.form;

import lombok.Data;
import net.lab1024.sa.base.common.domain.PageParam;

@Data
public class CuttingPlanQueryForm extends PageParam {
    private String planNo;
    private String orderNo;
    private Integer status;
    private Boolean deletedFlag;
}
