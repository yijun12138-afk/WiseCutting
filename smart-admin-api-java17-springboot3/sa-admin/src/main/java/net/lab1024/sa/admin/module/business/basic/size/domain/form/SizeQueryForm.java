package net.lab1024.sa.admin.module.business.basic.size.domain.form;

import lombok.Data;
import net.lab1024.sa.base.common.domain.PageParam;

@Data
public class SizeQueryForm extends PageParam {
    private String searchWord;
    private Boolean deletedFlag;
}
