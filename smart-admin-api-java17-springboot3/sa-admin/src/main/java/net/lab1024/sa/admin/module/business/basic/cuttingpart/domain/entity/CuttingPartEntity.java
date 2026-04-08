package net.lab1024.sa.admin.module.business.basic.cuttingpart.domain.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import java.time.LocalDateTime;

/**
 * 裁片部位 实体类
 */
@Data
@TableName("t_cutting_part")
public class CuttingPartEntity {

    @TableId(type = IdType.AUTO)
    private Long partId;

    /** 部位名称 */
    private String partName;

    /** 部位编码 */
    private String partCode;

    /** 删除标识 */
    private Boolean deletedFlag;

    /** 备注 */
    private String remark;

    private LocalDateTime createTime;
    private LocalDateTime updateTime;
}
