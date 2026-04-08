package net.lab1024.sa.admin.module.business.basic.unit.domain.form;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;

@Data
public class UnitAddForm {
    private Long unitId;
    @NotBlank(message = "单位名称不能为空")
    private String unitName;
    private String remark;
}
