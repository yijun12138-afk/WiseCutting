package net.lab1024.sa.admin.module.business.basic.unit.domain.form;

import lombok.Data;
import net.lab1024.sa.base.common.domain.PageParam;

@Data
public class UnitQueryForm extends PageParam {
    private String unitName;
    private Boolean deletedFlag;
}
