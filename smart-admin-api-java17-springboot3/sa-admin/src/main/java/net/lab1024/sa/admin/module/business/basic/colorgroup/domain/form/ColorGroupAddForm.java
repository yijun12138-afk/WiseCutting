package net.lab1024.sa.admin.module.business.basic.colorgroup.domain.form;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotBlank;
import lombok.Data;

@Data
public class ColorGroupAddForm {

    @Schema(description = "颜色组ID（修改时必填）")
    private Long groupId;

    @NotBlank(message = "颜色组不能为空")
    @Schema(description = "颜色组名称")
    private String groupName;

    @Schema(description = "备注")
    private String remark;
}
