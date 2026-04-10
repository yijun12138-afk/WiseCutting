package net.lab1024.sa.admin.module.business.basic.sizegroup.domain.form;

import lombok.Data;
import net.lab1024.sa.base.common.domain.PageParam;

@Data
public class SizeGroupQueryForm extends PageParam {
    private String searchWord;
    private Boolean deletedFlag;
}
