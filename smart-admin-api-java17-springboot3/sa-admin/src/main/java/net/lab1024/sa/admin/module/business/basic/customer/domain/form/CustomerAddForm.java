package net.lab1024.sa.admin.module.business.basic.customer.domain.form;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotBlank;
import lombok.Data;

/**
 * 客户 新增/修改表单
 */
@Data
public class CustomerAddForm {

    @Schema(description = "客户ID（修改时必填）")
    private Long customerId;

    @NotBlank(message = "客户名称不能为空")
    @Schema(description = "客户名称")
    private String customerName;

    @Schema(description = "公司名称")
    private String companyName;

    @Schema(description = "联系人")
    private String contactPerson;

    @Schema(description = "电话")
    private String phone;

    @Schema(description = "等级")
    private String level;

    @Schema(description = "停用标识")
    private Boolean disabledFlag;

    @Schema(description = "备注")
    private String remark;
}
