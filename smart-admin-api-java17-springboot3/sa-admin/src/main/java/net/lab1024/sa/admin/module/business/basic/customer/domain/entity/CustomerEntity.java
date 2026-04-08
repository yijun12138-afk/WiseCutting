package net.lab1024.sa.admin.module.business.basic.customer.domain.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import java.time.LocalDateTime;

/**
 * 客户管理 实体类
 */
@Data
@TableName("t_customer")
public class CustomerEntity {

    @TableId(type = IdType.AUTO)
    private Long customerId;

    /** 客户名称 */
    private String customerName;

    /** 公司名称 */
    private String companyName;

    /** 联系人 */
    private String contactPerson;

    /** 电话 */
    private String phone;

    /** 等级 */
    private String level;

    /** 停用标识 */
    private Boolean disabledFlag;

    /** 删除标识 */
    private Boolean deletedFlag;

    /** 备注 */
    private String remark;

    private LocalDateTime createTime;
    private LocalDateTime updateTime;
}
