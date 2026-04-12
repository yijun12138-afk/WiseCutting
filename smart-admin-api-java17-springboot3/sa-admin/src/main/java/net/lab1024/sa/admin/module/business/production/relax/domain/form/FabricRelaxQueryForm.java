package net.lab1024.sa.admin.module.business.production.relax.domain.form;

import lombok.Data;
import net.lab1024.sa.base.common.domain.PageParam;

@Data
public class FabricRelaxQueryForm extends PageParam {
    private String orderNo;
    private Integer status;
    private Integer relaxType;
    private Boolean deletedFlag;
}
