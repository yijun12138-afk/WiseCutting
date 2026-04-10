package net.lab1024.sa.admin.module.business.basic.customer.domain.vo;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.time.LocalDateTime;

/**
 * 客户 VO
 */
@Data
public class CustomerVO {

    @Schema(description = "客户ID")
    private Long customerId;

    @Schema(description = "客户编号")
    private String customerCode;

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

    @Schema(description = "创建时间")
    private LocalDateTime createTime;
}
