package net.lab1024.sa.admin.module.business.basic.stylecolor.domain.form;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

@Data
public class StyleColorAddForm {

    @Schema(description = "颜色ID（修改时必填）")
    private Long colorId;

    @NotNull(message = "颜色组不能为空")
    @Schema(description = "颜色组ID")
    private Long colorGroupId;

    @NotBlank(message = "颜色名称不能为空")
    @Schema(description = "颜色名称")
    private String colorName;

    @Schema(description = "备注")
    private String remark;
}
