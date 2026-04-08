package net.lab1024.sa.admin.module.business.basic.cuttingpart.domain.form;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;

@Data
public class CuttingPartAddForm {
    private Long partId;
    @NotBlank(message = "部位名称不能为空")
    private String partName;
    private String partCode;
    private String remark;
}
