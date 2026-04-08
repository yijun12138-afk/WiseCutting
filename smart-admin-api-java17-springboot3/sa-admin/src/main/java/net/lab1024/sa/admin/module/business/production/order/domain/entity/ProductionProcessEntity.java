package net.lab1024.sa.admin.module.business.production.order.domain.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * 生产流程工序 实体类
 */
@Data
@TableName("t_production_process")
public class ProductionProcessEntity {

    @TableId(type = IdType.AUTO)
    private Long processId;
    private Long orderId;
    private Integer seqNo;
    private String nodeName;
    private String principal;
    private BigDecimal durationHours;
    private LocalDateTime planStartTime;
    private LocalDateTime planEndTime;
    private LocalDateTime actualStartTime;
    private LocalDateTime actualEndTime;
    private Integer status;
    private Boolean deletedFlag;
    private LocalDateTime createTime;
    private LocalDateTime updateTime;
}
