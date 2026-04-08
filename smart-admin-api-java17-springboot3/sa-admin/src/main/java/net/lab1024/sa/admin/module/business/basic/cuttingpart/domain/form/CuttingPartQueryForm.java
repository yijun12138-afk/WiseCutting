package net.lab1024.sa.admin.module.business.basic.cuttingpart.domain.form;

import lombok.Data;
import net.lab1024.sa.base.common.domain.PageParam;

@Data
public class CuttingPartQueryForm extends PageParam {
    private String partName;
    private Boolean deletedFlag;
}
