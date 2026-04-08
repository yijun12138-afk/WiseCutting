package net.lab1024.sa.admin.module.business.basic.stylecolor.domain.form;

import lombok.Data;
import net.lab1024.sa.base.common.domain.PageParam;

@Data
public class StyleColorQueryForm extends PageParam {
    private String styleNo;
    private String colorName;
    private Boolean deletedFlag;
}
