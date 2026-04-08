package net.lab1024.sa.admin.module.business.basic.size.domain.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import java.time.LocalDateTime;

/**
 * 尺寸列表 实体类
 */
@Data
@TableName("t_size")
public class SizeEntity {

    @TableId(type = IdType.AUTO)
    private Long sizeId;

    /** 尺码名称 */
    private String sizeName;

    /** 排序 */
    private Integer sort;

    /** 删除标识 */
    private Boolean deletedFlag;

    /** 备注 */
    private String remark;

    private LocalDateTime createTime;
    private LocalDateTime updateTime;
}
