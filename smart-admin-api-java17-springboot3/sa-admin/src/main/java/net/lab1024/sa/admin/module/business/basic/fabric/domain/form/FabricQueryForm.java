package net.lab1024.sa.admin.module.business.basic.fabric.domain.form;

import lombok.Data;
import net.lab1024.sa.base.common.domain.PageParam;

@Data
public class FabricQueryForm extends PageParam {
    private String searchWord;
    private Boolean disabledFlag;
    private Boolean deletedFlag;
}
