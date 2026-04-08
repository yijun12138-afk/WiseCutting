package net.lab1024.sa.admin.module.business.production.spread.domain.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * 铺布任务 实体类
 */
@Data
@TableName("t_fabric_spread")
public class FabricSpreadEntity {

    @TableId(type = IdType.AUTO)
    private Long spreadId;
    private Long orderId;
    private String orderNo;
    private Long fabricId;
    private String fabricNo;
    private String fabricName;
    private String colorName;
    private Integer requireLayers;
    private BigDecimal requireLength;
    private Integer actualLayers;
    private BigDecimal actualLength;
    /** 状态: 0-待作业, 1-进行中, 2-已完成 */
    private Integer status;
    /** 是否已下发: 0-否, 1-是 */
    private Boolean issuedFlag;
    private Boolean deletedFlag;
    private String remark;
    private Long createUserId;
    private String createUserName;
    private LocalDateTime createTime;
    private LocalDateTime updateTime;
}
