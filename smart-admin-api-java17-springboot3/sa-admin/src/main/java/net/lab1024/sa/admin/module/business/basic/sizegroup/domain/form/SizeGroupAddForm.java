package net.lab1024.sa.admin.module.business.basic.sizegroup.domain.form;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotBlank;
import lombok.Data;

@Data
public class SizeGroupAddForm {

    @Schema(description = "尺码组ID（修改时必填）")
    private Long groupId;

    @NotBlank(message = "尺码组不能为空")
    @Schema(description = "尺码组名称")
    private String groupName;

    @Schema(description = "备注")
    private String remark;
}
