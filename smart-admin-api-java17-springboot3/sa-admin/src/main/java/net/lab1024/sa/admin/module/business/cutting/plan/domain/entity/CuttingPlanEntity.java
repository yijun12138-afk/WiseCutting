package net.lab1024.sa.admin.module.business.cutting.plan.domain.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Data
@TableName("t_cutting_plan")
public class CuttingPlanEntity {
    @TableId(type = IdType.AUTO)
    private Long planId;
    private String planNo;
    private Long orderId;
    private String orderNo;
    private String customerName;
    private String styleNo;
    private String styleName;
    private LocalDate planDate;
    private Integer planQuantity;
    private Integer actualQuantity;
    /** 状态: 1-计划, 2-进行中, 3-完成 */
    private Integer status;
    private Boolean deletedFlag;
    private String remark;
    private Long createUserId;
    private String createUserName;
    private LocalDateTime createTime;
    private LocalDateTime updateTime;
}
