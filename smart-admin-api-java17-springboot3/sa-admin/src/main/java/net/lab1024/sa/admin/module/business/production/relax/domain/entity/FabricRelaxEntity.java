package net.lab1024.sa.admin.module.business.production.relax.domain.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * 松布任务 实体类
 */
@Data
@TableName("t_fabric_relax")
public class FabricRelaxEntity {

    @TableId(type = IdType.AUTO)
    private Long relaxId;
    private Long orderId;
    private String orderNo;
    private Long fabricId;
    private String fabricNo;
    private String fabricName;
    private String colorName;
    private BigDecimal requireLength;
    private BigDecimal actualLength;
    private BigDecimal relaxHours;
    @TableField(exist = false)
    private String customerName;
    private LocalDateTime relaxTime;
    private LocalDateTime actualStartTime;
    private LocalDateTime actualEndTime;
    /** 状态: 0-计划, 1-进行中, 2-完成 */
    private Integer status;
    private Boolean deletedFlag;
    private String remark;
    private Long createUserId;
    private String createUserName;
    private LocalDateTime createTime;
    private LocalDateTime updateTime;
}
