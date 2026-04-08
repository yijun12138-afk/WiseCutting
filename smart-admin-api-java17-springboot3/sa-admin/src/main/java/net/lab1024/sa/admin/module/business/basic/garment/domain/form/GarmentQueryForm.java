package net.lab1024.sa.admin.module.business.basic.garment.domain.form;

import lombok.Data;
import net.lab1024.sa.base.common.domain.PageParam;

@Data
public class GarmentQueryForm extends PageParam {
    private String garmentNo;
    private String garmentName;
    private Boolean deletedFlag;
}
