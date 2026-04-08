package net.lab1024.sa.admin.module.business.basic.unit.domain.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import java.time.LocalDateTime;

/**
 * 单位管理 实体类
 */
@Data
@TableName("t_unit")
public class UnitEntity {

    @TableId(type = IdType.AUTO)
    private Long unitId;

    /** 单位名称 */
    private String unitName;

    /** 单位编码（系统生成） */
    private String unitCode;

    /** 删除标识 */
    private Boolean deletedFlag;

    /** 备注 */
    private String remark;

    private Long createUserId;
    private String createUserName;
    private Long updateUserId;
    private String updateUserName;

    private LocalDateTime createTime;
    private LocalDateTime updateTime;
}
