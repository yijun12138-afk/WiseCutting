package net.lab1024.sa.admin.module.business.basic.size.domain.form;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

@Data
public class SizeAddForm {
    private Long sizeId;

    @NotNull(message = "尺码组不能为空")
    private Long sizeGroupId;

    @NotBlank(message = "尺码名称不能为空")
    private String sizeName;

    private Integer sort;
    private String remark;
}
