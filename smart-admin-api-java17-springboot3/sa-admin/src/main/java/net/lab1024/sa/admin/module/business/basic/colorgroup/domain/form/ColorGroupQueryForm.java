package net.lab1024.sa.admin.module.business.basic.colorgroup.domain.form;

import lombok.Data;
import net.lab1024.sa.base.common.domain.PageParam;

@Data
public class ColorGroupQueryForm extends PageParam {
    private String searchWord;
    private Boolean deletedFlag;
}
