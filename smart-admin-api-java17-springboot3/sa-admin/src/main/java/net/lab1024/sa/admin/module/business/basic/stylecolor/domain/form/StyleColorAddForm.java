package net.lab1024.sa.admin.module.business.basic.stylecolor.domain.form;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotBlank;
import lombok.Data;

@Data
public class StyleColorAddForm {

    @Schema(description = "颜色ID（修改时必填）")
    private Long colorId;

    @NotBlank(message = "款号不能为空")
    @Schema(description = "款号")
    private String styleNo;

    @NotBlank(message = "颜色名称不能为空")
    @Schema(description = "颜色名称")
    private String colorName;

    @Schema(description = "颜色编码")
    private String colorCode;

    @Schema(description = "备注")
    private String remark;
}
