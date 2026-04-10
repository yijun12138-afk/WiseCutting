package net.lab1024.sa.admin.module.business.basic.stylecolor.domain.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.time.LocalDateTime;

/**
 * 款式颜色 实体类
 */
@Data
@TableName("t_style_color")
public class StyleColorEntity {

    @TableId(type = IdType.AUTO)
    private Long colorId;

    /** 款号 */
    private String styleNo;

    /** 颜色组ID */
    private Long colorGroupId;

    /** 颜色名称 */
    private String colorName;

    /** 颜色编码 */
    private String colorCode;

    /** 删除标识 */
    private Boolean deletedFlag;

    /** 备注 */
    private String remark;

    private Long createUserId;
    private String createUserName;
    private LocalDateTime createTime;
    private LocalDateTime updateTime;
}
