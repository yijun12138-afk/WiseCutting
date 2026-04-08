package net.lab1024.sa.admin.module.business.production.spread.domain.form;

import lombok.Data;
import net.lab1024.sa.base.common.domain.PageParam;

@Data
public class FabricSpreadQueryForm extends PageParam {
    private String orderNo;
    private Integer status;
    private Boolean issuedFlag;
    private Boolean deletedFlag;
}
