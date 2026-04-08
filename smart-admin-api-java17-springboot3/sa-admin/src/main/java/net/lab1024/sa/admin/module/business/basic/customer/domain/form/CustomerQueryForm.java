package net.lab1024.sa.admin.module.business.basic.customer.domain.form;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;
import net.lab1024.sa.base.common.domain.PageParam;

/**
 * 客户 查询表单
 */
@Data
public class CustomerQueryForm extends PageParam {

    @Schema(description = "关键字（客户名称/公司名称）")
    private String searchWord;

    @Schema(hidden = true)
    private Boolean deletedFlag;

    @Schema(description = "停用标识")
    private Boolean disabledFlag;
}
