package net.lab1024.sa.admin.module.business.basic.fabric.domain.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * 面料 实体类
 */
@Data
@TableName("t_fabric")
public class FabricEntity {

    @TableId(type = IdType.AUTO)
    private Long fabricId;

    /** 面料名称 */
    private String fabricName;

    /** 面料编号 */
    private String fabricNo;

    /** 面料类型 */
    private String fabricType;

    /** 规格型号 */
    private String spec;

    /** 单位ID */
    private Long unitId;

    /** 单位名称 */
    private String unitName;

    /** 克重 */
    private BigDecimal gramWeight;

    /** 宽度 */
    private BigDecimal width;

    /** 停用标识 */
    private Boolean disabledFlag;

    /** 删除标识 */
    private Boolean deletedFlag;

    /** 备注 */
    private String remark;

    private LocalDateTime createTime;
    private LocalDateTime updateTime;
}
